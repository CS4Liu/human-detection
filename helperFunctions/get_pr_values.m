%%%%%%%%%%%%%%%%%%%%%%%%% Plot PR Curve%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%% Add axis labels %%%%%%%%%%%%%%%%%%%%%%%
function [ap, precision, recall, ap_nd, precision_nd, recall_nd] = get_pr_values(det_path, gt_path)
    % det_path - path of .csv detection files
    % gt_path - path of .xml ground truth files

    load(det_path);
    load(gt_path)
    % results = aggregate_out_results;

     results_dummy = table2struct(results);
     gt_bboxes_dummy = table2struct(gt_bboxes);

    ids = get_non_difficult_indexes(gt_bboxes_dummy);
    [non_difficult_results, non_difficult_gt] = get_non_difficult_values(results_dummy, gt_bboxes_dummy, ids);
    clear results_dummy
    clear gt_bboxes_dummy

    % make data suitable for PR plot

    % all detections
    results2plot = struct('Boxes',results.Boxes, 'Scores', results.Scores);
    gt2plot = struct('Boxes',gt_bboxes.Boxes);

    results2plot = struct2table(results2plot);
    gt2plot = struct2table(gt2plot);

    [ap,recall,precision] = evaluateDetectionPrecision(results2plot,gt2plot);

    figure
    plot(recall,precision)
    grid on
    title(sprintf('Average Precision = %.1f',ap))
    xlabel('Recall')
    ylabel('Precision')

    % non-difficult detections

    results2plot_ndiff = struct('Boxes',non_difficult_results.Boxes, 'Scores', non_difficult_results.Scores);
    gt2plot_ndiff = struct('Boxes',non_difficult_gt.Boxes);

    results2plot_ndiff = struct2table(results2plot_ndiff);
    gt2plot_ndiff = struct2table(gt2plot_ndiff);

    [ap_nd,recall_nd,precision_nd] = evaluateDetectionPrecision(results2plot_ndiff,gt2plot_ndiff);

    figure
    plot(recall_nd,precision_nd)
    grid on
    title(sprintf('ND Average Precision = %.1f',ap_nd))
    xlabel('Recall')
    ylabel('Precision')

end

function [non_difficult_results, non_difficult_gt] = get_non_difficult_values(results_dummy, gt_bboxes_dummy, ids)

    non_difficult_results(length(ids)) = struct('Boxes',[],'Scores',[], 'File_ID', []);
    non_difficult_gt(length(ids)) = struct('Boxes',[], 'File_ID', []);
    
    for k=1:length(ids)
        idx = ids(k);
        non_difficult_results(k).Boxes = results_dummy(idx).Boxes;
        non_difficult_results(k).Scores = results_dummy(idx).Scores;
        non_difficult_results(k).File_ID = results_dummy(idx).File_ID;
        non_difficult_gt(k).Boxes = gt_bboxes_dummy(idx).Boxes; 
        non_difficult_gt(k).File_ID = gt_bboxes_dummy(idx).File_ID; 
    end
    non_difficult_results = struct2table(non_difficult_results);
    non_difficult_gt = struct2table(non_difficult_gt);
end
