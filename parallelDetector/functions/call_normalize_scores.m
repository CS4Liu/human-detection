% call normalize scores
annotation_results = '/Users/ire/Desktop/Code/parallelDetector/results/dpm_dpm/default/dpm_dpm_default_dpm2scores.mat';
gt_path = '/Users/ire/Desktop/Code/VOCdevkit/VOC2007/Annotations/smallSet/GT_tables/gt_bboxes.mat';

outfile_path = '/Users/ire/Desktop/Code/parallelDetector/results/dpm_dpm/default/';
outfile_name = 'dpm_dpm_norm_dpm2score.mat';

normalize_scores(gt_path, annotation_results, outfile_path, outfile_name);