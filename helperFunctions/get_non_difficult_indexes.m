function ids = get_non_difficult_indexes(gt_bboxes_dummy)
    ids = [];
    for i=1:length(gt_bboxes_dummy)
        I = find(gt_bboxes_dummy(i).Difficult==1);
        if isempty(I)
            ids = [ids, i];
        end
        clear I;
    end
    clear i;
end

