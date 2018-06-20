% call false alarm pairs
fa_dpm = '/Users/ire/Desktop/Code/falseAlarms/recurring_false_alarms/small_hog_dpm/';
fa_hog = '/Users/ire/Desktop/Code/falseAlarms/HOG/thresh0/small_model/';
gt = '/Users/ire/Desktop/Code/VOCdevkit/VOC2007/Annotations/smallSet/';
store_path = '/Users/ire/Desktop/Code/falseAlarms/recurring_false_alarms/small_hog_dpm/';
false_alarm_pairs(fa_dpm, fa_hog,gt, store_path);