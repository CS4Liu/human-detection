% get number (percentage) of false alarms detected by 1,2,3 methods
function [total_false_alarms_1, total_false_alarms_2] = false_alarm_pairs(loc1, loc2, gt, store_path)
   % loc1, loc2: locations where false alarms for methods are stored
   min_overlap = 0.4;
   fa_1 = get_detection_results(loc1);
   fa_2 = get_detection_results(loc2);
   
   fa_1.Properties.RowNames = fa_1.File_ID;
   fa_2.Properties.RowNames = fa_2.File_ID;
   
   total_false_alarms_1 = get_false_detection_number(fa_1);
   total_false_alarms_2 = get_false_detection_number(fa_2);
   
   d = get_all_files(gt, '*.xml');
   for n=1:numel(d)
       fileid = strsplit(d(n).name, '.xml');
       fileid = strcat(fileid{1}, '.csv');
       try
           % only calculate if false detections in both cases
           false_alarms_1 = table2struct(fa_1({fileid},:));
           false_alarms_2 = table2struct(fa_2({fileid},:));
           s1 = size(false_alarms_1.Boxes);
           s2 = size(false_alarms_2.Boxes);
           s1 = s1(1);
           s2 = s2(1);
           
           used_gt_idx = [];
           m = [];
           
           for j=1:s1 % loop through det 1
               detected_box = false_alarms_1.Boxes(j,:);
               match = false;
               for i = 1:s2 % loop through det 2
                   ov = 0;
                   match = true;
                   if ~isempty(find(used_gt_idx==i))
                       % cannot have TP when no gt bbox
                       match = false;
                       % cannot have multiple detections assigned to same gt bb 
                   end
                   if match
                       bb2 = false_alarms_2.Boxes(i,:);
                       bb = bboxesToPascal(detected_box);
                       bbgt = bboxesToPascal(bb2);
                       ov = calculate_overlap(bb,bbgt);
                       disp(ov);
                   end
                   % if overlap greater than minimum overlap true positive
                    if ov>=min_overlap
                        used_gt_idx = [used_gt_idx, i];
                        match = true;
                        % stop iterating through gt boxes
                        clear bb;
                        clear bbgt;
                        break;
                    else
                        match = false;
                    end
                    clear bb;
                    clear bbgt;
               end
               % false alarm
                % write location and score of false alarm
                if match
                    m = vertcat(m,[false_alarms_1.Scores(j), false_alarms_1.Boxes(j,:)]);
                end
           end
        clear used_gt_idx;
        if ~isempty(m)
            csvwrite(strcat(store_path,false_alarms_1.File_ID), m);
        end
        clear m;
       catch
           % skip to next image
       end
    
   end
end

function count = get_false_detection_number(fa)
    count = 0;
    bx = fa.Boxes;
    for q = 1:length(bx)
        try
            no_boxes = size(bx{q});
        catch
            no_boxes = size(bx(q));
        end
        no_boxes = no_boxes(1);
        count = count + no_boxes;
    end
end