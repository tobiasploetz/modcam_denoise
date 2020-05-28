function [  ] = vis_plot_likelihood(  )
%VIS_PLOT_LIKELIHOOD Summary of this function goes here
%   Detailed explanation goes here
nlf = struct; nlf.a=1e-1; nlf.b = 1e-3;
bitdepth = 10;
target_bitdepth = 16;

nlf.bitdepth = bitdepth;
nlf = adapt_nlf(nlf, target_bitdepth);
p = 0.99;
exposures = exposure_times_florian( bitdepth, target_bitdepth, nlf, p, 100);
exposures

%% Full
% weights = ones(size(exposures));
weights = exposures.^2;

foe = learned_models.cvpr_pw_mrf;

energy_opt = struct;
% energy_opt.clipped = true;
energy_opt.clipped = false;
energy_opt.prior = foe;
energy_opt.lambda = getlambda(bitdepth, nlf);
energy_opt.normalizer = 1;
energy_opt


%%
Im = 2^9;

figure(1);clf;
h = fplot(@(R) nll_modcam( R./2^target_bitdepth, Im, exposures(4), bitdepth, target_bitdepth, nlf, energy_opt ), [0,1].*2^target_bitdepth);
basepath = '~/Documents/phdthesis/Chapters/Modcam/Tobias/figures/generated/';
%%
set(gca, 'fontsize', 16)
set(h, 'linewidth', 2)
xlabel('R')
ylabel('NLL')
ylim([-2,22])
p = get(gcf, 'position');
p(3:4) = [650,400];
set(gcf, 'position', p)
export_fig(fullfile(basepath, 'nll1.pdf'), '-transparent');
export_fig(fullfile(basepath, 'nll1.png'), '-transparent');
savefig(fullfile(basepath, 'nll1.fig'))

%%
Im = 2^9;

figure(1);clf;
h = fplot(@(R) nll_modcam( R./2^target_bitdepth, Im, exposures(2), bitdepth, target_bitdepth, nlf, energy_opt ), [0,1].*2^target_bitdepth);
basepath = '~/Documents/phdthesis/Chapters/Modcam/Tobias/figures/generated/';
%%
set(gca, 'fontsize', 16)
set(h, 'linewidth', 2)
xlabel('R')
ylabel('NLL')
ylim([-50,2.2e3])
p = get(gcf, 'position');
p(3:4) = [650,400];
set(gcf, 'position', p)
%%
export_fig(fullfile(basepath, 'nll2.pdf'), '-transparent');
export_fig(fullfile(basepath, 'nll2.png'), '-transparent');
savefig(fullfile(basepath, 'nll2.fig'))
end

