function [] = store_false_alarms_alt(gt_path,det_path,store_path)
% extract false alarms (per method) and store locations and scores in .csv
% for when i am not considering all detections ex. only hard false alarms
% files

    load(gt_path);
    load(det_path);

    results_dummy = table2struct(results);
    gt_bboxes.Properties.RowNames = gt_bboxes.File_ID;

    image_ids = size(results_dummy);
    image_ids = image_ids(1);

    min_overlap = 0.5;


    for i=1:image_ids
        m = [];
        this_result = results_dummy(i);
        fileid_str = this_result.File_ID;
        fileid_str = strsplit(fileid_str,'/');
        fileid_str = fileid_str{2};
        fileid_str = strsplit(fileid_str,'.csv');
        fileid_str = strcat(fileid_str{1}, '.xml');
        
        disp(this_result.File_ID);
        this_gt = gt_bboxes({fileid_str},:);
        this_gt = table2struct(this_gt);
        
        I = find(this_gt.Difficult==1); % skip difficult images
        if ~isempty(I)
            continue
        end
        used_gt_idx = [];
        s = size(this_gt.Boxes);
        sd = size(this_result.Boxes);
        % results in descending confidence order
        if ~isempty(this_result.Boxes)
            tpm = [this_result.Scores, this_result.Boxes];
            tpm = sortrows(tpm, 'descend');
            this_result.Scores = tpm(:,1);
            this_result.Boxes = tpm(:,[2,3,4,5]);
        end
        % loop through detections
        for j=1:sd(1)
            fa_overlap = [];
            detected_box = this_result.Boxes(j,:);
            true_positive = false;
            % loop through ground truth boxes
            for k=1:s(1)
                ov=0;
                true_positive = true;
                found = find(used_gt_idx==k);
                if ~isempty(found)
                    % cannot have TP when no gt bbox
                    true_positive = false;
                    % cannot have multiple detections assigned to same gt bb 
                end
                if true_positive
                    % area of intersection
                    gt_box = this_gt.Boxes(k,:);
                    bb = bboxesToPascal(detected_box);
                    bbgt = bboxesToPascal(gt_box);
                    bi=[max(bb(1),bbgt(1)) ; max(bb(2),bbgt(2)) ; min(bb(3),bbgt(3)) ; min(bb(4),bbgt(4))];
                    iw=bi(3)-bi(1)+1;
                    ih=bi(4)-bi(2)+1;
                    % area union : area a + area b - area int
                    if iw>0 && ih>0
                        % compute overlap as area of intersection / area of union
                        ua=(bb(3)-bb(1)+1)*(bb(4)-bb(2)+1)+...
                           (bbgt(3)-bbgt(1)+1)*(bbgt(4)-bbgt(2)+1)-...
                           iw*ih;
                        % overlap: area of intersection / area of union
                        ov=iw*ih/ua;
                        disp(ov);
                        export_overlap = ov;
                        % if found a match, cannot have match with other
                    end
                end
                % if overlap greater than minimum overlap true positive
                if ov>=min_overlap
                    used_gt_idx = [used_gt_idx, k];
                    true_positive = true;
                    % stop iterating through gt boxes
                    clear bb;
                    clear bbgt;
                    break;
                else
                    true_positive = false;
                    fa_overlap = [fa_overlap, ov];
                end
                clear bb;
                clear bbgt;

            end 
            % false alarm
            % write location and score of false alarm
            if ~true_positive
                % match to gt bb for which largest overlap achieved
                try
                    export_overlap = sort(fa_overlap,'descend');
                    export_overlap = export_overlap(1);
                catch
                    export_overlap = 0;
                end
                m = vertcat(m,[this_result.Scores(j), this_result.Boxes(j,:), export_overlap]);
                clear export_overlap;
            end
        end
        clear used_gt_idx;
        if ~isempty(m)
            csvwrite(strcat(store_path,this_result.File_ID), m);
        end
    end
end