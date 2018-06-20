% call combined models
inpath = '/Users/ire/Desktop/Code/VOCdevkit/VOC2007/JPEGImages/smallSet/';
annotation_path = '/Users/ire/Desktop/Code/cascadedDetectors/annotations/2007/smallSet/small_hog_dpm/default_t1/hog_scores/';
output_impath = '/Users/ire/Desktop/Code/cascadedDetectors/processed/2007/smallSet/small_hog_dpm/default_t1/hog_scores/';
thresh_hog = 0;
thresh_dpm = 0; % not setting dpm thresh here
hog_score = true;
cascade_hog_dpm(inpath, annotation_path, output_impath, thresh_hog, thresh_dpm, hog_score)
