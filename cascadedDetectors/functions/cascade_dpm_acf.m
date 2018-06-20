% cascade dpm_acf
function [] = cascade_dpm_acf(inpath, image_path, annotation_path, output_impath)
    %inpath - location of scores associated to DPM
    %personDetector - adjusted parameters
    %apath - location to store annotations
    %outpath - location to store images
    
    % load detections recovered with DPM detector
    load(inpath);
    dpm_results_struct = table2struct(results);
    
    for i=1:length(dpm_results_struct)
        imid = dpm_results_struct(i).File_ID;
        imid = strsplit(imid,'.csv');
        imid = imid{1};
        disp(imid);
        dpm_boxes = dpm_results_struct(i).Boxes;
        dpm_scores = dpm_results_struct(i).Scores;
        I = imread(strcat(image_path,imid,'.jpg'));
        if ~isempty(dpm_boxes)
            out_acf = auxiliary_acf(I, dpm_boxes, dpm_scores, annotation_path, output_impath);
        else
            out_acf = [];
        end
        if ~isempty(out_acf)
            scores_dpm_acf = [out_acf(:,1),out_acf(:,2)];
            bboxes_dpm_acf = [out_acf(:,3),out_acf(:,4),out_acf(:,5),out_acf(:,6)];
            IFaces=insertObjectAnnotation(I, 'rectangle', bboxes_dpm_acf, scores_dpm_acf(1)); 
            output = strcat(output_impath,imid, '.jpg');
            imwrite(IFaces, output);
            clear IFaces;
        end
        csvwrite(strcat(annotation_path,imid,'.csv'), out_acf);
    end
end