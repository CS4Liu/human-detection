% normalize detection scores to be within fixed range.
function [] = normalize_scores(gt_path, annotation_results, outfile_path, outfile_name)
% gt_path: path tp grpind truth annotations
% annotation_results: path to detection results with single score line
    load(annotation_results);
    results_dummy = table2struct(results);
    load(gt_path);
    gt_struct = table2struct(gt_bboxes);

    scores = [];
    for j=1:size(results_dummy,1)
        if ~isempty(find(gt_struct(j).Difficult==1))
            continue
        end
        s_vec = results_dummy(j).Scores;
        for i=1:length(s_vec)
            s=s_vec(i);
            scores = [scores,s];
        end

    end
    % maxscores = max(scores(:));
    % minscores = min(scores(:));
    % normalized_scores   = (scores - minscores) / (maxscores - minscores);
    normalized_scores = normalised_diff(scores);
    set(groot,'defaulttextinterpreter','latex');  
    set(groot, 'defaultAxesTickLabelInterpreter','latex');  
    set(groot, 'defaultLegendInterpreter','latex');
    set(gcf, 'Renderer', 'Painters');
    % Display score distribution: see difference
    subplot(2,1,1)
    h = histogram(scores, 80);
    title({'Effect of Score Normalization','Original Score Distribution'})
    xlabel('Confidence Score Values');

    subplot(2,1,2)
    h = histogram(normalized_scores, 80);
    title('Normalized Score Distribution')
    xlabel('Confidence Score Values')

    normalized_results_dummy = results_dummy;
    n_score_count = 1;
    for j=1:size(normalized_results_dummy,1)
        if ~isempty(find(gt_struct(j).Difficult==1))
            continue
        end
        for i=1:length(results_dummy(j).Scores)
            normalized_results_dummy(j).Scores(i) = normalized_scores(n_score_count);
            n_score_count = n_score_count+1;
        end

    end
    normalized_out_results = struct2table(normalized_results_dummy);
    save(strcat(outfile_path,outfile_name),'normalized_out_results') 
end

