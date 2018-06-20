function [] = cascade_hog_dpm(inpath, annotation_path, output_impath, thresh_hog, thresh_dpm, hog_score)
    %inpath - input dataset
    %personDetector - adjusted parameters
    %apath - location to store annotations
    %outpath - location to store images
    
    hog_time = [];
    dpm_time = [];
    fil=fullfile(inpath,'*.jpg');
    d=dir(fil);
    for k=1:numel(d)
        input=fullfile(inpath,d(k).name);
        I = imread(input);
        sp=strsplit(input,'/');
        imname=sp(length(sp));
        imname=strtok(imname,'.');
        disp(input);
        
        personDetector = vision.PeopleDetector('ClassificationModel','UprightPeople_96x48', 'ClassificationThreshold', thresh_hog); 
        tic;
        [bboxes, scores] = step(personDetector, I);
        t_hog = toc;
        % measure time to execute HOG stage
        hog_time = [hog_time, t_hog];
        % bboxes: ROI for auxiliary DPM
        % t_dpm is sum of time taken for all image bboxes
        if ~isempty(bboxes)
            [t_dpm, out_dpm] = auxiliary_dpm(I, bboxes, scores, annotation_path, output_impath, thresh_dpm, hog_score);
        else
            t_dpm = 0;
            out_dpm = [];
        end
        dpm_time = [dpm_time, t_dpm];
        if ~isempty(out_dpm)
            scores_dpm = out_dpm(:,1);
            bboxes_dpm = [out_dpm(:,2),out_dpm(:,3),out_dpm(:,4),out_dpm(:,5)];
            IFaces=insertObjectAnnotation(I, 'rectangle', bboxes_dpm, scores_dpm); 
            output = strcat(output_impath,char(imname), '.jpg');
            imwrite(IFaces, output);
            clear IFaces;
        end
        % store bbox, scores output from 2nd stage
        csvwrite(strcat(annotation_path,char(imname),'.csv'), out_dpm);
    end
    % save(strcat('/Users/ire/Desktop/Code/timeMeasurements/cascade_hog_dpm/','hog_time_thresh0.mat'),'hog_time')
    % save(strcat('/Users/ire/Desktop/Code/timeMeasurements/cascade_hog_dpm/','dpm_time_thresh_1.mat'),'dpm_time')
end