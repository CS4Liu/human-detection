% call classify scores

gt_path = '/Users/ire/Desktop/Code/VOCdevkit/VOC2007/Annotations/smallSet/GT_tables/gt_bboxes.mat';
include_difficult = false;
min_overlap = 0.5;

det_path='/Users/ire/Desktop/Code/DPM/annotations/2007/smallSet/result_tables/dpm-results-inria-t-1.mat';
[true_positives_dpm_inria_t1, false_positives_dpm_inria_t1, misdetections_dpm_inria_t1, true_positive_scores_dpm_inria_t1, false_positive_scores_dpm_inria_t1] = classify_scores(gt_path, det_path, min_overlap, include_difficult);

det_path='/Users/ire/Desktop/Code/DPM/annotations/2007/smallSet/result_tables/dpm-results-voc07person-t-1.mat';
[true_positives_dpm_voc07person_t1, false_positives_dpm_voc07person_t1, misdetections_dpm_voc07person_t1, true_positive_scores_dpm_voc07person_t1, false_positive_scores_dpm_voc07person_t1] = classify_scores(gt_path, det_path, min_overlap, include_difficult);
