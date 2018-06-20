% call dpm detector
inpath = '/Users/ire/Desktop/Code/VOCdevkit/VOC2007/JPEGImages/smallSet/';
model_loc='INRIA/inriaperson_final';
apath='/Users/ire/Desktop/Code/DPM/annotations/2007/smallSet/inria/thresh-03/';
outpath='/Users/ire/Desktop/Code/DPM/processed/2007/smallSet/inria/thresh-03/';
dpm_detect_and_store(inpath, model_loc, apath, outpath);