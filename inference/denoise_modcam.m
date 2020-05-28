function [ R ] = denoise_modcam( Rinit, Ims, exposures, weights, bitdepth, target_bitdepth, nlf, energy_opt, optim_opt)
check_nlf(nlf);
ni = numel(exposures);

try 
    energy_opt.prior.imdims = size(Ims(:,:,1));
catch
end

% sort exposure times ascending;
[exposures, sortidx] = sort(exposures);
weights = weights(sortidx);
Ims = Ims(:,:,sortidx);

weight_strategy = getOpt(optim_opt, 'weight_strategy', 'merge');
refit_at_end = getOpt(optim_opt, 'refit_at_end', false);
init_with_florian = getOpt(optim_opt, 'init_with_florian', false);
update_with_florian = getOpt(optim_opt, 'update_with_florian', false);
minfunc_opt_user = getOpt(optim_opt, 'minfunc_opt', struct);
rescale_weights = getOpt(optim_opt, 'rescale_weights', true);

% loop over increasing subsets of images
R = Rinit;
if strcmp(weight_strategy, 'all')
    refit_at_end=true;
else
    for i=1:ni
%         figure(10+i);
%         clf;
%         imagesc(R);
%         pause(0.1);
        

        if strcmp(weight_strategy, 'merge')
            Ims_iter = Ims(:,:,1:i);
            exposures_iter = exposures(1:i);
            weights_iter = weights(1:i);
        elseif strcmp(weight_strategy, 'single')
            Ims_iter = Ims(:,:,i);
            exposures_iter = exposures(i);
            weights_iter = weights(i);
        end
        if rescale_weights
            weights_iter = weights_iter ./ sum(weights_iter);
        end
        
        if init_with_florian
            R_florian = baselines.florian(Ims_iter(:,:,end), exposures_iter(end), nlf, bitdepth, target_bitdepth, R);
            R_zhao = baselines.zhao(Ims_iter(:,:,end), exposures_iter(end), nlf, bitdepth, target_bitdepth, R);
            f_florian = f_and_grad(R_florian, Ims_iter, exposures_iter, weights_iter, bitdepth, target_bitdepth, nlf, energy_opt, optim_opt, size(Rinit));
            f_zhao = f_and_grad(R_zhao, Ims_iter, exposures_iter, weights_iter, bitdepth, target_bitdepth, nlf, energy_opt, optim_opt, size(Rinit));
            f_ours = f_and_grad(R, Ims_iter, exposures_iter, weights_iter, bitdepth, target_bitdepth, nlf, energy_opt, optim_opt, size(Rinit));
            if f_florian < f_ours
                R = R_florian;
                f_ours = f_florian;
            end
            if f_zhao < f_ours
                R = R_zhao;
                f_ours = f_zhao;
            end            
        end
        
        R = optimize_minfunc(R, minfunc_opt_user, Ims_iter, exposures_iter, weights_iter, bitdepth, target_bitdepth, nlf, energy_opt, optim_opt, size(Rinit));
        
%         if init_with_florian
%             R_florian = baselines.florian(Ims_iter, exposures_iter, nlf, bitdepth, target_bitdepth);
%             f_florian = f_and_grad(R_florian, Ims_iter, exposures_iter, weights_iter, bitdepth, target_bitdepth, nlf, energy_opt, optim_opt, size(Rinit));
%             f_ours = f_and_grad(R, Ims_iter, exposures_iter, weights_iter, bitdepth, target_bitdepth, nlf, energy_opt, optim_opt, size(Rinit));
%             if f_florian < f_ours
%                 R = R_florian;
%             end            
%         end
    end
end

if refit_at_end
    R = optimize_minfunc(R, minfunc_opt_user, Ims, exposures, weights, bitdepth, target_bitdepth, nlf, energy_opt, optim_opt, size(Rinit));
end

end

function R = optimize_minfunc(R, minfunc_opt_user, varargin)
    minfunc_opt = struct;
    minfunc_opt.Method = 'sd';
    minfunc_opt.MaxIter = 75;
    minfunc_opt.Display = 'off';   
    minfunc_opt = setopts(minfunc_opt, minfunc_opt_user);
    
    sz = size(R);
    [R,f,exitflag,output] = minFunc(@f_and_grad, R(:), minfunc_opt, varargin{:});
    R = reshape(R, sz);
%     R = min(1, max(R,0));
    R = max(R,0);
end

function R = optimize_ada(R, ada_opt_user, varargin)
    ada_opt = struct;
    ada_opt.Method = 'Adagrad';
    ada_opt.MaxIter = 75;
    ada_opt.Display = 'on';   
    ada_opt.epsilon = sqrt(eps);
    ada_opt.stepsize = 1e-2;
    ada_opt = setopts(ada_opt, ada_opt_user);
    
    sz = size(R);
    R = AdaGrad(@(idx, x) grad(x, varargin{:}), R(:), ada_opt.MaxIter, ones(numel(R),1), ada_opt.stepsize, ada_opt.epsilon);
    R = reshape(R(:,end), sz);
%     R = min(1, max(R,0));
    R = max(R,0);
end

function [f,g] = f_and_grad(R, Ims, exposures, weights, bitdepth, target_bitdepth, nlf, energy_opt, optim_opt, sz)

precond = getOpt(optim_opt, 'precond', false);

R = reshape(R, sz);

[f,g, pc] = posterior_modcam(R, Ims, exposures, weights, bitdepth, target_bitdepth, nlf, energy_opt);

g = g(:);    
if precond
    g = g.*pc(:)./mean(abs(pc(:)));
end


end

function [g] = grad(R, Ims, exposures, weights, bitdepth, target_bitdepth, nlf, energy_opt, optim_opt, sz)

precond = getOpt(optim_opt, 'precond', false);

R = reshape(R, sz);

[f,g, pc] = posterior_modcam(R, Ims, exposures, weights, bitdepth, target_bitdepth, nlf, energy_opt);

g = g(:);    

if precond
    g = g.*pc(:)./mean(abs(pc(:)));
end

end