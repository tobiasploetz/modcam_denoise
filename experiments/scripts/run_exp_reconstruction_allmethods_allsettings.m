function run_exp_reconstruction_allmethods_allsettings(bitdepth, algos)

if ~exist('algos', 'var')
    algos = {'r_init'};
end

target_bitdepth = 16;
% datasets = {'debevec', 'psftools', 'hdrps', 'cityscapes'};
datasets = {'debevec', 'psftools', 'hdrps'};
for i=1:numel(datasets)
	dataset = datasets{i}
	nlf = struct('a', 1e-2, 'b', 1e-4);
	run_exp_reconstruction_all_methods( dataset, nlf, bitdepth, target_bitdepth, algos);

	nlf = struct('a', 1e-1, 'b', 1e-3);
	run_exp_reconstruction_all_methods( dataset, nlf, bitdepth, target_bitdepth, algos);

	nlf = struct('a', 1e-3, 'b', 1e-5);
	run_exp_reconstruction_all_methods( dataset, nlf, bitdepth, target_bitdepth, algos);

	nlf = struct('a', 1e-4, 'b', 1e-6);
	run_exp_reconstruction_all_methods( dataset, nlf, bitdepth, target_bitdepth, algos);
end

end