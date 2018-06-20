% Classify TP vs FP scores for future experiments determining thresholds 
function [true_positives, false_positives, misdetections, true_positive_scores, false_positive_scores] = classify_scores(gt_path, det_path, min_overlap, include_difficult)
    
    load(gt_path);
    load(det_path);
    
    % results = aggregate_out_results;
   

    gt_bboxes_dummy = table2struct(gt_bboxes);
    results_dummy = table2struct(results);

    true_positives = 0;
    false_positives = 0;
    misdetections = 0;

    true_positive_scores = [];
    false_positive_scores = [];

    image_ids = size(results_dummy);
    image_ids = image_ids(1);
    
    if ~include_difficult
        nd_ids = get_non_difficult_indexes(gt_bboxes_dummy);
        for z=1:length(nd_ids)
            i = nd_ids(z);
            this_result = results_dummy(i);
            if ~isempty(this_result.Boxes)
                tpm = [this_result.Scores, this_result.Boxes];
                tpm = sortrows(tpm, 'descend');
                this_result.Scores = tpm(:,1);
                this_result.Boxes = tpm(:,[2,3,4,5]);
            end
            this_result_false_scores = this_result.Scores;
            this_gt = gt_bboxes_dummy(i);
            gt_match_count = 0;
            used_gt_idx = [];
            s = size(this_gt.Boxes);
            sd = size(this_result.Boxes);
            % loop through detections
            for j=1:sd(1)
                detected_box = this_result.Boxes(j,:);
                % loop through ground truth boxes
                for k=1:s(1)
                    ov=0;
                    found = find(used_gt_idx==k);
                    if ~isempty(found)
                        % cannot have TP when no gt bbox
                        % cannot have multiple detections assigned to same gt bb
                        continue 
                    end
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
                        % if found a match, cannot have match with other
                    end
                    % if overlap greater than minimum overlap
                    if ov>=min_overlap
                        % add score to true detection scores
                        true_positive_scores=vertcat(true_positive_scores, this_result.Scores(j));
                        gt_match_count = gt_match_count+1;
                        this_result_false_scores(j) = NaN;
                        used_gt_idx = [used_gt_idx, k];
                        % stop iterating through gt boxes
                        clear bb;
                        clear bbgt;
                        break;
                    end
                    clear bb;
                    clear bbgt;
                    
                end 
                % add remaining scores to false positive scores
            end

            % assign false alarms (remaining from detected)
            this_false_positives = sd(1)-gt_match_count;
            false_positives = false_positives + this_false_positives;
            % assign misdetection (missing from ground truth)
            this_misdetections = s(1)-gt_match_count;
            misdetections = misdetections + this_misdetections;
            % assign true positives
            true_positives = true_positives + gt_match_count;
            clear gt_match_count;
            clear used_gt_idx;
            this_result_false_scores(isnan(this_result_false_scores)) = [];
            false_positive_scores = vertcat(false_positive_scores, this_result_false_scores);
            clear this_result_false_scores
        end
    else
        for i=1:image_ids
            this_result = results_dummy(i);
            this_result_false_scores = this_result.Scores;
            this_gt = gt_bboxes_dummy(i);
            
            sd = size(this_result.Boxes);
            s = size(this_gt.Boxes);
            gt_match_count = 0;
            used_gt_idx = [];
            % loop through detections
            for j=1:sd(1)
                detected_box = this_result.Boxes(j,:);
                % loop through ground truth boxes
                for k=1:s(1)
                    ov=0;
                    found = find(used_gt_idx==k);
                    if ~isempty(found)
                        % cannot have multiple detections assigned to same gt bb
                        continue 
                    end
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
                        % if found a match, cannot have match with other
                    end
                    % if overlap greater than minimum overlap
                    if ov>=min_overlap 
                        true_positive_scores=vertcat(true_positive_scores, this_result.Scores(j));
                        this_result_false_scores(j) = NaN;
                        gt_match_count = gt_match_count+1;
                        used_gt_idx = [used_gt_idx, k];
                        clear bb;
                        clear bbgt;
                        break;
                    end
                    % assign detection
                    % remove index from possible detections
                    % increase gt_match_count by one

                    clear bb;
                    clear bbgt;
                end
                clear detection_matches;
            end

            % assign false alarms (remaining from detected)
            this_false_positives = sd(1)-gt_match_count;
            false_positives = false_positives + this_false_positives;
            % assign misdetection (missing from ground truth)
            this_misdetections = s(1)-gt_match_count;
            misdetections = misdetections + this_misdetections;
            % assign true positives
            true_positives = true_positives + gt_match_count;
            clear gt_match_count;
            clear used_gt_idx;
            this_result_false_scores(isnan(this_result_false_scores)) = [];
            false_positive_scores = vertcat(false_positive_scores, this_result_false_scores);
            clear this_result_false_scores
        end 
    end
end