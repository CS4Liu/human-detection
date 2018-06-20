
gt_path = '/Users/ire/Desktop/Code/VOCdevkit/VOC2007/Annotations/smallSet/GT_tables/gt_bboxes.mat';
det_path='/Users/ire/Desktop/Code/parallelDetector/results/hog_dpm_acf_ldcf_alt_alt/step5/dpm_dpm_acf_ldcf_step5.mat';
[ap_dpm_dpm_acf_ldcf_alt_alt, precision_dpm_dpm_acf_ldcf_alt_alt, recall_dpm_dpm_acf_ldcf_alt_alt, ap_nd_dpm_dpm_acf_ldcf_alt_alt, precision_nd_dpm_dpm_acf_ldcf_alt_alt, recall_nd_dpm_dpm_acf_ldcf_alt_alt] = get_pr_values(det_path, gt_path);

save('/Users/ire/Desktop/Code/parallelDetector/results/hog_dpm_acf_ldcf_alt_alt/step5/pr-aggregate.mat');

