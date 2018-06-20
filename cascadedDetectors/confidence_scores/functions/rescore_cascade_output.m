% rescore_cascade_output
svm_scores;
path2score_a='/Users/ire/Desktop/Code/cascadedDetectors/results/2007/smallSet/small_hog_dpm/t_1_t_0/score-classif-ids-dpmscore.mat';
path2score_b='/Users/ire/Desktop/Code/cascadedDetectors/results/2007/smallSet/small_hog_dpm/t_1_t_0/score-classif-ids-hogscore.mat';
[predicted_label, score, cost]=train_and_predict_scores(path2score_a, path2score_b);

load('/Users/ire/Desktop/Code/cascadedDetectors/annotations/2007/smallSet/result_tables/dpmt_1-hogt0-dpmscore');

rescore_results = table2struct(results_hogt0_dpmt1_dpmscore);
count_datapoints = 1;
gt_path = '/Users/ire/Desktop/Code/VOCdevkit/VOC2007/Annotations/smallSet/GT_tables/gt_bboxes.mat';
load(gt_path);
gt_bboxes_dummy = table2struct(gt_bboxes);
nd_ids = get_non_difficult_indexes(gt_bboxes_dummy);
for z=1:length(nd_ids)
    i = nd_ids(z);
    disp(rescore_results(i).File_ID);
    for j=1:size(rescore_results(i).Scores,1)
        disp(score(count_datapoints));
        disp(predicted_label(count_datapoints));
        disp(theclass(count_datapoints));
        new_score = predicted_label(count_datapoints)*abs(score(count_datapoints,1));
        disp(new_score);
        count_datapoints = count_datapoints + 1;
        rescore_results(i).Scores(j) = new_score;
    end
end

rescore_results = struct2table(rescore_results);




% count_detections = 0;
% for z2=1:length(nd_ids)
%     j = nd_ids(z2);
%     for j2=1:size(rescore_results(j).Scores,1)
%         count_detections = count_detections + 1;
%     end
% end





