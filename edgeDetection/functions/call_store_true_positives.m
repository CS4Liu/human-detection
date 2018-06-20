% call store true positives
gt_path = '/Users/ire/Desktop/Code/VOCdevkit/VOC2007/Annotations/smallSet/GT_tables/gt_bboxes.mat';
det_path = '/Users/ire/Desktop/Code/DPM/annotations/2007/smallSet/result_tables/dpm-default-inria-results-table.mat';
store_path = '/Users/ire/Desktop/Code/edgeDetection/all_true_positives/dpm/';
store_true_positives(gt_path,det_path,store_path);