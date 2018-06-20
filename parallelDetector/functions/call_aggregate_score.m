% call aggregate scores
% call normalize scores
annotation_results1 = '/Users/ire/Desktop/Code/parallelDetector/results/dpm_dpm/default/dpm_dpm_norm_dpmscore.mat';
annotation_results2 = '/Users/ire/Desktop/Code/parallelDetector/results/dpm_dpm/default/dpm_dpm_norm_dpm2score.mat';
gt_path = '/Users/ire/Desktop/Code/VOCdevkit/VOC2007/Annotations/smallSet/GT_tables/gt_bboxes.mat';

outfile_path = '/Users/ire/Desktop/Code/parallelDetector/results/dpm_dpm/default/';
outfile_name = 'dpm_dpm_norm_aggregate_score.mat';

aggregate_scores(gt_path, annotation_results1, annotation_results2, outfile_path, outfile_name);