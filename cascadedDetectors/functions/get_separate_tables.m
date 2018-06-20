% get separate tables
load('/Users/ire/Desktop/Code/parallelDetector/results/dpm_acf/tdef_t2.mat');

% results_dummy = table2struct(results);

results_1_score = table(results.Boxes, results.Scores_A, results.File_ID);
results_1_score.Properties.VariableNames = {'Boxes' 'Scores' 'File_ID'};
results_2_score = table(results.Boxes, results.Scores_B, results.File_ID);
results_2_score.Properties.VariableNames = {'Boxes' 'Scores' 'File_ID'};