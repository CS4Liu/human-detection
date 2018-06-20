function [] = dpm_detect_and_store_only_high_score(hard_images, model_loc, apath, outpath)
    %inpath - input dataset
    %personDetector - adjusted parameters
    %apath - location to store annotations
    %outpath - location to store images
    %model - pre trained human detector model location
    
    load(model_loc);
    
    inpath = '/Users/ire/Desktop/Code/VOCdevkit/VOC2007/JPEGImages/smallSet/';
    
    fil=fullfile(hard_images,'*.csv');
    d=dir(fil);

    for k=1:numel(d)
        image_name = strsplit(d(k).name, '.csv');
        image_name = strcat(image_name{1},'.jpg');
        input=fullfile(inpath,image_name);
        I = imread(input);
        disp(input);
        % ds [x1, y1, x2, y2, mod_comp, score]
        [ds, bs] = process(I, model);
        % apply non maximal supression
        top = nms(ds, 0.3);
        ds = ds(top,:);
        % remove all detections scoring below zero
        ds(ds(:,5)<=0,:)=[];
        % attention to width, height calculations
        if ~isempty(ds)
            bboxes = [ds(:,1), ds(:,2), (ds(:,3)-ds(:,1)+1), (ds(:,4)-ds(:,2)+1)];
            scores = ds(:,5);
        else
            bboxes = [];
            scores = [];
        end
        
        try
            IFaces=insertObjectAnnotation(I, 'rectangle', bboxes, scores); 
        catch
        end
        sp=strsplit(input,'/');
        imname=sp(length(sp));
        imname=strtok(imname,'.');
        m=[scores,bboxes];
        csvwrite(strcat(apath,char(imname),'.csv'), m);
        output = strcat(outpath,char(imname), '.jpg');
        try
            imwrite(IFaces, output);
            clear IFaces;
        catch
            imwrite(I,output);
        end
    end
end