% call centroid parallel detector
gt_path = '/Users/ire/Desktop/Code/VOCdevkit/VOC2007/Annotations/smallSet/GT_tables/gt_bboxes.mat';
inpath_det1 = '/Users/ire/Desktop/Code/parallelDetector/results/hog_dpm_acf_ldcf_alt_alt/step4/dpm_dpm_acf_ldcf_step4.mat';
inpath_det2 = '/Users/ire/Desktop/Code/parallelDetector/results/dpm_ldcf/default/dpm_ldcf_norm_aggregate_score.mat';
image_input = '/Users/ire/Desktop/Code/VOCdevkit/VOC2007/JPEGImages/smallSet/';

min_overlap = 0.45;
annotation_path = '/Users/ire/Desktop/Code/parallelDetector/annotations/hog_dpm_acf_ldcf_alt_alt/step5/';
output_impath = '//';

[total_boxes1, total_boxes2] = centroid_parallel_detector_alt(gt_path, image_input,inpath_det1, inpath_det2, annotation_path, output_impath, min_overlap);

results = get_detection_results(annotation_path);
load(gt_path);
out_boxes = get_total_boxes(table2struct(results), table2struct(gt_bboxes));
outfile_path = '/Users/ire/Desktop/Code/parallelDetector/results/hog_dpm_acf_ldcf_alt_alt/step5/';
outfile_name = 'dpm_dpm_acf_ldcf_step5.mat';
save(strcat(outfile_path,outfile_name),'results');