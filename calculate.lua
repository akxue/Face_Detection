local calculate = {}


local function getEmpiricalError(Y_train, proj_min, alpha_t, F_T, t)
	--[[  
			Y_train     total_imgs x 1  -  true classifications (1, -1)
			proj_min    total_imgs x 1  -  all images projected classifier with
									       min weighted error
			alpha_t     1 x 1           -  the t-th calculated weight for class.
			F_T         total_imgs x T  -  calculated F_values for all imgs,
										-  for each image (across rows)

		return  F  		total_imgs x 1  -  calculated F_value for all imgs for
									 	   iteration t of adabost
				err 	1 x 1  			-  empirical error for strong
										   classification result
	--]] 

	print('in getEmpiricalError() function');
	F, strong_classify = calculate.strongClass(alpha_t, proj_min, F_T, t);

	-- create indicator matrix for incorrect class
	err_vector = torch.ne(strong_classify, Y_train);
	-- sum the incorrect classifications
	total_err  = torch.sum(err_vector);
	err        = 1 / Y_train:size()[1] * total_err;

	return err, F;
end


local function strongClass(alpha_t, proj_min, F_T, t)
	--[[  
			alpha_t    1 x 1          -- true classifications (1, -1)
			proj_min   total_imgs x 1 -- all images projected classifier with
									  -- min weighted error
			F_T        T x 1          -- elements, t+1, ..., T are zero

			return the classification for all images (total_imgs x 1) -- +/-1
	--]] 

	wt_proj = alpha_t * proj_min;
	if t > 1 then
		F_prev = F_T[t-1];
	else
		F_prev = 0;
	end

	F_t = F_prev + wt_proj;

	-- strong_decision = sign(F_t) -- (total_imgs x 1)
	strong_decision = sign(F_t);

	return strong_decision, F_t;
end


local function updateWeights(Y_train, F_t, wts_prev, Z_T)

	-- compute exponential portion
	Y_F = F_t * Y_train:t();
	

	return wts_curr, Z;
end




local function displayErrorTime(iter, error, start_time)

	end_iter_time = os.time();
	time = os.difftime(end_iter_time, iter_start);
	print('iter '..iter.. '  '..
		'empirical error: '.. error.. '\n'..
		'\telapsed time:    '.. time.. ' seconds');
end


-------- function delcarations -------------------------------------------------
calculate.getEmpiricalError = getEmpiricalError;
calculate.strongClass       = strongClass;
calculate.displayErrorTime  = displayErrorTime;
-------- end function delcarations ---------------------------------------------


return calculate;