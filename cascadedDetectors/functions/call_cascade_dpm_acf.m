% call cascade dpm acf

inpath = '/Users/ire/Desktop/Code/DPM/annotations/2007/smallSet/result_tables/dpm-default-inria-results-table.mat';
image_path = '/Users/ire/Desktop/Code/VOCdevkit/VOC2007/JPEGImages/smallSet/';
annotation_path = '/Users/ire/Desktop/Code/cascadedDetectors/annotations/2007/smallSet/dpm_acf/cascade_alt_alt/tdef_tdef/';
output_impath = '/Users/ire/Desktop/Code/cascadedDetectors/processed/2007/smallSet/dpm_acf/cascade_alt_alt/tdef_tdef/';
cascade_dpm_acf_alt_alt(inpath, image_path, annotation_path, output_impath)