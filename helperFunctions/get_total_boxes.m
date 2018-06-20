function count = get_total_boxes(results_struct, gt_struct) % in non - difficult images
    count = 0;
    for q = 1:length(results_struct)
         % skip difficult images
        if ~isempty(find(gt_struct(q).Difficult==1))
            continue
        end
        no_boxes = size(results_struct(q).Boxes,1);
        count = count + no_boxes;
    end
end