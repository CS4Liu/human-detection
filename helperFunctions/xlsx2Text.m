function [] = xlsx2Text(annoDir, outFile)
% transform csv file into txt file for PASCAL evaluation ONLY for annotated

annoDir='/Users/ire/Desktop/Code/ACF/annotations/2007/wholeSet/Dollar/Face/';
outFile = strcat(annoDir, 'fast-face-annotations-default.txt');

f=fopen(outFile,'w');
filAnno=fullfile('/Users/ire/Desktop/Code/VOCdevkit/VOC2007/Annotations/','*.xml');

d=dir(filAnno);
for k=1:numel(d);
  filename=fullfile(strcat(annoDir,d(k).name));
  filename=strtok(filename,'.');
  filename=strcat(filename,'.csv');
  sp=strsplit(filename,'/');
  imname=sp(length(sp));
  imname=strtok(imname,'.');
  try
      res=csvread(filename);
  catch
      res=[];
  end
  if isempty(res)==false
    [m,n]=size(res);
    for i=1:m
      fprintf(f,'%s ',char(imname));
      fprintf(f,'%f %f %f %f %f\n',res(i,:));
    end
  end
end
end