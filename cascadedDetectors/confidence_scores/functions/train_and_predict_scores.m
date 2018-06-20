function [predicted_label, score, cost] = train_and_predict_scores(path2score_a, path2score_b)
    % svm and scores
    % gaussian rbf kernel
    load(path2score_a);
    load(path2score_b);
    
    true_positive_scores = ones(true_positives_hogt0_dpmt_1_dpmscore, 2);
    for i=1:size(true_positive_scores,1)
        true_positive_scores(i,1) = true_positive_scores_hogt0_dpmt_1_dpmscore(i).Scores;
        true_positive_scores(i,2) = true_positive_scores_hogt0_dpmt_1_hogscore(i).Scores;
    end

    false_positive_scores = ones(false_positives_hogt0_dpmt_1_dpmscore, 2);
    for i=1:size(false_positive_scores,1)
        false_positive_scores(i,1) = false_positive_scores_hogt0_dpmt_1_dpmscore(i).Scores;
        false_positive_scores(i,2) = false_positive_scores_hogt0_dpmt_1_hogscore(i).Scores;
    end

    data = [true_positive_scores;false_positive_scores];
    theclass = ones((size(true_positive_scores,1)+size(false_positive_scores,1)),1);
    theclass(1:size(true_positive_scores,1)) = -1;

    cl = fitcsvm(data,theclass,'KernelFunction','rbf',...
        'ClassNames',[-1,1]);

    % predicted labels for each score point
    [predicted_label, score, cost] = predict(cl,data);
end

