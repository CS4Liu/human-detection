function [] = dpm_detect_and_store(inpath, model_loc, apath, outpath)
    %inpath - input dataset
    %personDetector - adjusted parameters
    %apath - location to store annotations
    %outpath - location to store images
    %model - pre trained human detector model location
    
    load(model_loc);
    model.thresh = -0.3;
    
    fil=fullfile(inpath,'*.jpg');
    d=dir(fil);
    
    % process_times_dpm_inria_default_smallSet = [];
    % image_sizes = [];
    for k=1:numel(d)
        input=fullfile(inpath,d(k).name);
        I = imread(input);
        disp(input);
        % ds [x1, y1, x2, y2, mod_comp, score]
        % tic;
        [ds, bs] = process(I, model);
        % apply non maximal supression
        top = nms(ds, 0.45);
        ds = ds(top,:);
        % t = toc; % measure time including NMS to be fair
        % process_times_dpm_inria_default_smallSet = [process_times_dpm_inria_default_smallSet, t];
        % image_sizes = vertcat(image_sizes, size(I));
        
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
        % output = strcat(outpath,char(imname), '.jpg');
%         try
%             imwrite(IFaces, output);
%             clear IFaces;
%         catch
%             imwrite(I,output);
%         end
    end
    % save(strcat('/Users/ire/Desktop/Code/timeMeasurements/','dpm_inria_default_time_size.mat'),'process_times_dpm_inria_default_smallSet', 'image_sizes')
end