% store individual scores
% get separate tables
outfile_path = '/Users/ire/Desktop/Code/parallelDetector/results/dpm_dpm/default/';
outfile_name = 'dpm_dpm_default_bothscores.mat';
load(strcat(outfile_path,outfile_name));

results_dummy = results;

results = table(results_dummy.Boxes, results_dummy.Scores_A, results_dummy.File_ID);
results.Properties.VariableNames = {'Boxes' 'Scores' 'File_ID'};
outfile_name1 = 'dpm_dpm_default_dpmscores.mat';
save(strcat(outfile_path,outfile_name1),'results');

results = table(results_dummy.Boxes, results_dummy.Scores_B, results_dummy.File_ID);
results.Properties.VariableNames = {'Boxes' 'Scores' 'File_ID'};
outfile_name2 = 'dpm_dpm_default_dpm2scores.mat';
save(strcat(outfile_path,outfile_name2),'results');