function [] = aggregate_scores(gt_path, annotation_results1, annotation_results2, outfile_path, outfile_name)
    load(annotation_results1);
    results_dummy1 = table2struct(normalized_out_results);
    load(annotation_results2);
    results_dummy2 = table2struct(normalized_out_results);
    load(gt_path);
    gt_struct = table2struct(gt_bboxes);

    scores1 = [];
    scores2 = [];
    for j=1:size(results_dummy1,1)
        if ~isempty(find(gt_struct(j).Difficult==1))
            continue
        end
        s_vec1 = results_dummy1(j).Scores;
        s_vec2 = results_dummy2(j).Scores;
        for i=1:length(s_vec1)
            s1=s_vec1(i);
            scores1 = [scores1,s1];
            s2=s_vec2(i);
            scores2 = [scores2,s2];
        end
    end
    aggregated_scores = scores1+scores2;
    
    subplot(2,2,1)
    h = histogram(scores1, 80);
    title('Original Score Distribution 1')

    subplot(2,2,2)
    h = histogram(scores2, 80);
    title('Original Score Distribution 2')

    subplot(2,2,[3,4])
    h = histogram(aggregated_scores, 80);
    title('Aggregated Score Distribution')

    aggregate_results_dummy = results_dummy1;
    n_score_count = 1;
    for j=1:size(aggregate_results_dummy,1)
        if ~isempty(find(gt_struct(j).Difficult==1))
            continue
        end
        for i=1:length(results_dummy1(j).Scores)
            aggregate_results_dummy(j).Scores(i) = aggregated_scores(n_score_count);
            n_score_count = n_score_count+1;
        end

    end
    aggregate_out_results = struct2table(aggregate_results_dummy);
    save(strcat(outfile_path,outfile_name),'aggregate_out_results') 
end