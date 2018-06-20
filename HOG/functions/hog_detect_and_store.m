function [] = hog_detect_and_store(inpath, apath, outpath, thresh)
    %inpath - input dataset
    %personDetector - adjusted parameters
    %apath - location to store annotations
    %outpath - location to store images
    
    fil=fullfile(inpath,'*.jpg');
    d=dir(fil);
    process_times_hog_thresh0_smallSet_small_model = [];
    image_sizes = [];
    
    for k=1:numel(d)
        input=fullfile(inpath,d(k).name);
        I = imread(input);
        disp(input);
        % sf = size(I)/(size(I)-0.5);
        
        personDetector = vision.PeopleDetector('ClassificationModel','UprightPeople_96x48', 'ClassificationThreshold', thresh); 
        
        
        tic;
        [bboxes, scores] = step(personDetector, I);
        t=toc;
        process_times_hog_thresh0_smallSet_small_model = [process_times_hog_thresh0_smallSet_small_model, t];
        image_sizes = vertcat(image_sizes, size(I));

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
    save(strcat('/Users/ire/Desktop/Code/timeMeasurements/','hog_thresh0_time_size.mat'),'process_times_hog_thresh0_smallSet_small_model')
end