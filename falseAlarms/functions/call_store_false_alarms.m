% call store false alarms

gt_path = '/Users/ire/Desktop/Code/VOCdevkit/VOC2007/Annotations/smallSet/GT_tables/gt_bboxes.mat';
det_path = '/Users/ire/Desktop/Code/ACF/annotations/2007/smallSet/result_tables/';
store_path = '/Users/ire/Desktop/Code/truePositives/ACF/inria/tdef_msnms/acf-ms-inria-default-results-table.mat';
store_false_alarms(gt_path,det_path,store_path);
