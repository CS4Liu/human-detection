function [total_boxes1, total_boxes2] = centroid_parallel_detector_alt(gt_path, image_input, inpath_det1, inpath_det2, annotation_path, output_impath, min_overlap)
% FOR PAIRS OF NORMALIZED SCORES
% keep common detections
% common detection bbox is box with centroid between centroids of two boxes
% sizes of box are mean of width and height of other boxes

    load(inpath_det1); % detections from model 1
    % results1_struct = table2struct(aggregate_out_results);
    results1_struct = table2struct(results);
    clear results;
    load(inpath_det2); % detections from model 2
    results2_struct = table2struct(aggregate_out_results);
    % results2_struct = table2struct(results);
    clear results;
    load(gt_path); % ground truth data
    gt_struct = table2struct(gt_bboxes);
    clear gt_bboxes;

    total_boxes1 = get_total_boxes(results1_struct, gt_struct);
    total_boxes2 = get_total_boxes(results2_struct, gt_struct);

    for i=1:length(gt_struct)

        bboxes_1 = results1_struct(i).Boxes;
        bboxes_2 = results2_struct(i).Boxes;
        scores_1 = results1_struct(i).Scores;
        scores_2 = results2_struct(i).Scores;
        filid = strsplit(gt_struct(i).File_ID, '.xml');
        filid = filid{1};
        disp(filid);
        
        matched_idx2 = []; % indeces of matched boxes in det2
        matched_idx1 = [];
        m = [];
        match = false;
        for j1=1:size(bboxes_1,1) % loop through det 1
            bb1 = bboxes_1(j1,:);
            score_1 = scores_1(j1);
            bb2 = [];
            score_2 = 0;
            ov = 0;
            match = false;
            for j2=1:size(bboxes_2,1)
                match = true; % bb1, bb2 might be a match
                if ~isempty(find(matched_idx2==j2))
                    match = false;
                end
                if match
                    bb2 = bboxes_2(j2,:);
                    score_2 = scores_2(j2);
                    bb1_pascal = bboxesToPascal(bb1);
                    bb2_pascal = bboxesToPascal(bb2);
                    ov = calculate_overlap(bb1_pascal, bb2_pascal);
                end
                if ov>=min_overlap
                    % bbox index in det2
                    matched_idx2 = [matched_idx2,j2];
                    matched_idx1 = [matched_idx1, j1];
                    match = true;
                    clear bb1_pascal;
                    clear bb2_pascal;
                    break; % box in det1 has been matched - dont look more
                else
                    match = false;
                end
                clear bb1_pascal;
                clear bb2_pascal;
            end
            % if there is a match, write down
            % [score1, score2, x, y, w, h]
            % store centroid modified box
            % bb1, bb2 are boxes to merge
            % score_1, score_2 hold the scores I have
            if match
                bb = get_common_centroid_box(bb1,bb2);
                s = [score_1 + score_2];
            else
                bb = [];
                s = [];
            end
            m = vertcat(m,[s,bb]);
        end
        % add all boxes that have not been  matched to m
        % unmatched boxes 1:
        for u=1:size(bboxes_1,1)
            if isempty(find(matched_idx1==u))
                m = vertcat(m,[scores_1(u,:),bboxes_1(u,:)]);
            end
        end
        % unmatched boxes 2:
        for u=1:size(bboxes_2,1)
            if isempty(find(matched_idx2==u))
                m = vertcat(m,[scores_2(u,:),bboxes_2(u,:)]);
            end  
        end
        csvwrite(strcat(annotation_path,filid, '.csv'), m);
        % draw the new box on image - visualize detections
        if ~isempty(m)
            I = imread(strcat(image_input,filid,'.jpg'));
            s_print = m(:,1); % print scores associated to mod 1
            bb_print = [m(:,2),m(:,3),m(:,4),m(:,5)];
            IFaces=insertObjectAnnotation(I, 'rectangle', bb_print, s_print); 
            output = strcat(output_impath,filid, '.jpg');
            % imwrite(IFaces, output);
            clear IFaces;
        end
        clear m;
        clear matched_idx1;
        clear matched_idx2;
    end
end

function [xCentroid,yCentroid] = get_centroid(bb)
    xCentroid = bb(1) + (bb(3)/2);
    yCentroid = bb(2) + (bb(4)/2);
end

function [bb] = get_common_centroid_box(bb1,bb2)
    out_w = (bb1(3)+bb2(3))/2;
    out_h = (bb1(4)+bb2(4))/2;
    [xCentroid1,yCentroid1] = get_centroid(bb1);
    [xCentroid2,yCentroid2] = get_centroid(bb2);
    xCentroid_out = (xCentroid1+xCentroid2)/2;
    yCentroid_out = (yCentroid1+yCentroid2)/2;
    xmin_out = xCentroid_out - (out_w/2);
    ymin_out = yCentroid_out - (out_h/2);
    bb = [xmin_out, ymin_out, out_w, out_h];
end