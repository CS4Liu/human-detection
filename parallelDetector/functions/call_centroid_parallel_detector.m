% call centroid parallel detector
gt_path = '/Users/ire/Desktop/Code/VOCdevkit/VOC2007/Annotations/smallSet/GT_tables/gt_bboxes.mat';
inpath_det1 = '/Users/ire/Desktop/Code/DPM/annotations/2007/smallSet/result_tables/dpm-default-inria-results-table.mat';
inpath_det2 = '/Users/ire/Desktop/Code/DPM/annotations/2007/smallSet/result_tables/dpm-default-inria-results-table.mat';
image_input = '/Users/ire/Desktop/Code/VOCdevkit/VOC2007/JPEGImages/smallSet/';

min_overlap = 0.45;
annotation_path = '/Users/ire/Desktop/Code/parallelDetector/annotations/dpm_dpm/default/';
output_impath = '/Users/ire/Desktop/Code/parallelDetector/processed/dpm_dpm/dpmt2_acft2/';

[total_boxes1, total_boxes2] = centroid_parallel_detector(gt_path, image_input,inpath_det1, inpath_det2, annotation_path, output_impath, min_overlap);

results = get_detection_results_cascade(annotation_path);
load(gt_path);
out_boxes = get_total_boxes(table2struct(results), table2struct(gt_bboxes));

outfile_path = '/Users/ire/Desktop/Code/parallelDetector/results/dpm_dpm/default/';
outfile_name = 'dpm_dpm_default_bothscores.mat';
save(strcat(outfile_path,outfile_name),'results');