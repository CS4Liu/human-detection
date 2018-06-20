% Put all annotated images into a folder
% Annotations File
annoList='/Users/ire/Desktop/Code/DPM/annotations/2007/wholeSet/VOC2007/nms/';
% text file containing all annotations
listFile='DPM-VOC07-nms-annotations.txt';
% Path to imahes with bounding boxes
imPath='/Users/ire/Desktop/Code/DPM/processed/2007/wholeSet/VOC2007/nms/';
% Path to storage of processed images WITH bounding boxes
% Images WITH detections
outFolder='/Users/ire/Desktop/Code/DPM/processed/2007/wholeSet/VOC2007/nms/falseAlarms/';

f=fopen(strcat(annoList, listFile),'r');
tline = fgetl(f);
while ischar(tline)
    tline=tline(1:6);
    disp(tline);
    I=imread(strcat(imPath,tline,'.jpg'));
    imwrite(I,strcat(outFolder, tline, '.jpg'));
    tline = fgetl(f);
end
fclose(f);

