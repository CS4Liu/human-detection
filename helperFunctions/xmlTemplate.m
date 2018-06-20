%pat = '/Users/ire/Desktop/FYP Code/VOCdevkit/VOC2009/JPEGImages';
%fil=fullfile(pat,'*.jpg');
img_pat='/Users/ire/Desktop/FYP Code/VOCdevkit/VOC2009/JPEGImages';
img_fil=fullfile(img_pat,'*jpg');
img_d=dir(img_fil);

xml_pat='/Users/ire/Desktop/FYP Code/VOCdevkit/VOC2009/Annotations';
xml_fil=fullfile(xml_pat,'*xml');
xml_d=dir(xml_fil);


filetext = fileread('/Users/ire/Desktop/FYP Code/template.xml');
for i=1:numel(img_d)
    image=img_d(i).name;
    image=strtok(image,'.jpg');
    
    for k=1:numel(xml_d)
        xml=xml_d(k).name;
        xml=strtok(xml,'.xml');
        if (strcmp(image,xml))
            break
        end
        if k==numel(xml_d)
            fileID=fopen(strcat('/Users/ire/Desktop/FYP Code/VOCdevkit/VOC2009/Annotations/',image,'.xml'), 'w');
            fprintf(fileID, filetext);
            fclose(fileID);
        end
    end
end