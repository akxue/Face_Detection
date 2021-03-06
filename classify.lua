---------------- classify.lua

local classify = {}


local function findMinWtErr(weights, error_matrix, dim, DEBUG, t)

	min_ind    = -1;
	min_wt_err = 9999;

	error_vec = weights:t() * error_matrix; -- 1 x delta_size

	for i = 1, dim do
		val = torch.squeeze(error_vec[{{1},{i}}])
		if  val < min_wt_err then
			min_wt_err = val;
			min_ind = i;
		end
	end

	return min_wt_err, min_ind;
end


local function ll_classify(proj_i, m0, s0, m1, s1)
	--[[ 
		element-wise intuition: 
			- each element in proj_i is the projection of the j-th image 
			  onto the i-th weak classifier, so each element corresponds to an
			  image (face, nonface)
			- for each of the j projections, we compare to the mean/sd of the
			  face/nonfaces calculated in calcThreshold(), and do kmeans class.
			- if the ratio > 0, then classify as face, else classify as nonface
	--]]

	-- center the projections w.r.t. faces, nonfaces

	local sq = torch.pow;
	local lg = torch.log;

	local cent_faces     = sq((proj_i - m0), 2) / s0^2;
	local cent_nonfaces  = sq((proj_i - m1), 2) / s1^2;

	--local cent_faces     = (proj_i - m0)^2 / s0^2;
	--local cent_nonfaces  = (proj_i - m1)^2 / s1^2;


	--print('size of centered face: '..cent_faces:size()[1]);
	--print('size of centered nonface: '..cent_nonfaces:size()[1]);

	-- calculate ratios, take sign to classify
	local ratio = -0.5 * (cent_faces - cent_nonfaces + lg(s0) - lg(s1));
	
	--print('size of ratio: '..ratio:size()[1]);

	return torch.sign(ratio);

end

--------function declarations -------------------------
classify.ll_classify = ll_classify;
classify.findMinWtErr = findMinWtErr;
------------------- end function declarations ---------


return classify



