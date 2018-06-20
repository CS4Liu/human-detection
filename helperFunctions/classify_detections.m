function [true_positives, false_positives, misdetections] = classify_detections(gt_path, det_path, min_overlap, include_difficult)
    
    load(gt_path);
    results = get_detection_results(det_path);

    gt_bboxes_dummy = table2struct(gt_bboxes);
    results_dummy = table2struct(results);

    true_positives = 0;
    false_positives = 0;
    misdetections = 0;

    image_ids = size(results_dummy);
    image_ids = image_ids(1);
    
    if ~include_difficult
        nd_ids = get_non_difficult_indexes(gt_bboxes_dummy);
        for z=1:length(nd_ids)
            i = nd_ids(z);
            this_result = results_dummy(i);
            this_gt = gt_bboxes_dummy(i);
            gt_match_count = 0;
            used_gt_idx = [];
            s = size(this_gt.Boxes);
            sd = size(this_result.Boxes);
            for j=1:sd(1)
                detected_box = this_result.Boxes(j,:);
                for k=1:s(1)
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
                        gt_match_count = gt_match_count+1;
                        used_gt_idx = [used_gt_idx, k];
                        clear bb;
                        clear bbgt;
                        ov = 0;
                        break;
                    end
                    % assign detection
                    % remove index from possible detections
                    % increase gt_match_count by one

                    clear bb;
                    clear bbgt;
                end 
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
        end
    else
        for i=1:image_ids
            this_result = results_dummy(i);
            this_gt = gt_bboxes_dummy(i);
            
            sd = size(this_result.Boxes);
            s = size(this_gt.Boxes);
            gt_match_count = 0;
            used_gt_idx = [];
            
            for j=1:sd(1)
                detected_box = this_result.Boxes(j,:);
                
                for k=1:s(1)
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
                        gt_match_count = gt_match_count+1;
                        used_gt_idx = [used_gt_idx, k];
                        clear bb;
                        clear bbgt;
                        ov = 0;
                        break;
                    end
                    % assign detection
                    % remove index from possible detections
                    % increase gt_match_count by one

                    clear bb;
                    clear bbgt;
                end 
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
        end 
    end
end

    function gt_bboxes = get_gt_bboxes(gt_path)
            d = get_all_files(gt_path, '*.xml');
            gt_bboxes(numel(d)) = struct('Boxes',[], 'Difficult',[], 'File_ID', []); % gt results
            for i=1:numel(d)
                filename=fullfile(gt_path,d(i).name);
                xml = xml2struct(filename);
                bboxes = [];
                diff = [];
                l = length(xml.annotation.object);
                if l>1
                    for j=1:l
                    obj = xml.annotation.object{1,j};
                        if string(obj.name.Text) == 'person'
                            bndbox = bboxToMatlab(obj);
                            bboxes = [bboxes; bndbox];
                            diffi = str2double(obj.difficult.Text);
                            diff = [diff;diffi];
                        end
                    end
                else
                    obj = xml.annotation.object;
                    if string(obj.name.Text) == 'person'
                            bndbox = bboxToMatlab(obj);
                            bboxes = [bboxes; bndbox];
                            diffi = str2double(obj.difficult.Text);
                            diff = [diff;diffi];
                    end 
                end

                filename = strsplit(filename,gt_path);
                filename = filename(2);
                gt_bboxes(i).Boxes = bboxes;
                gt_bboxes(i).File_ID = filename;
                gt_bboxes(i).Difficult = diff;

                clear diff
                clear bboxes
                clear filename
           end
            gt_bboxes = struct2table(gt_bboxes);


        end

    function results = get_detection_results(det_path)
            d = get_all_files(det_path, '*.csv');
            results(numel(d)) = struct('Boxes',[],'Scores',[], 'File_ID', []); % person detections
            for i=1:numel(d)
                filename=fullfile(det_path,d(i).name);
                try
                    M = csvread(filename);
                    scores = M(:,1);
                    bboxes = [M(:,2),M(:,3),M(:,4),M(:,5)];
        %             % transform PASCAL --> Matlab bbox format
        %             % [xmin ymin xmax ymax]-->[xmin ymin width height]
        %             s=size(bboxes);
        %             for j=1:s(1)
        %                 bboxes(j,3)=bboxes(j,3)-bboxes(j,1);
        %                 bboxes(j,4)=bboxes(j,4)-bboxes(j,2);
        %             end
                catch
                   bboxes = [];
                   scores = [];
                end
                results(i).Boxes = bboxes;
                results(i).Scores = scores;
                filename = strsplit(filename,det_path);
                filename = filename(2);
                results(i).File_ID = filename;
                clear filename;
                clear bboxes;
                clear scores;
            end
            results = struct2table(results);
    end