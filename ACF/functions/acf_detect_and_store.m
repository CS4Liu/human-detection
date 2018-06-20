function [] = acf_detect_and_store(inpath, apath, outpath, detector)
    %inpath - input dataset
    %personDetector - adjusted parameters
    %apath - location to store annotations
    %outpath - location to store images
    %model - pre trained human detector model location
    
    % ACF model trained on caltech dataset
    % load('models/AcfCaltech+Detector.mat','detector');
    % ACF model trained on Inria dataset
    % load('models/AcfInriaDetector.mat','detector');
    
    % LDCF model trained on caltech dataset
    % load('models/LdcfCaltech+Detector.mat','detector');
    % LDCF model trained on Inria dataset
    % load('models/LdcfInriaDetector.mat','detector');
    
    
    fil=fullfile(inpath,'*.jpg');
    d=dir(fil);

    for k=1:numel(d)
        input=fullfile(inpath,d(k).name);
        I = imread(input);
        disp(input);
        % bbs [xmin, ymin, w, h, score]
        bbs = acfDetect(I, detector);
        
        % attention to width, height calculations
        if ~isempty(bbs)
            bboxes = [bbs(:,1), bbs(:,2), bbs(:,3), bbs(:,4)];
            scores = bbs(:,5);
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
        try
            % imwrite(IFaces, output);
            clear IFaces;
        catch
            % imwrite(I,output);
        end
    end
end