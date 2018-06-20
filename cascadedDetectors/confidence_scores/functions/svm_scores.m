% svm and scores
% gaussian rbf kernel

load('/Users/ire/Desktop/Code/cascadedDetectors/results/2007/smallSet/small_hog_dpm/t_1_t_0/score-classif-ids-dpmscore.mat');
load('/Users/ire/Desktop/Code/cascadedDetectors/results/2007/smallSet/small_hog_dpm/t_1_t_0/score-classif-ids-hogscore.mat');

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

figure;
subplot(1,2,1);
plot(false_positive_scores(:,1),false_positive_scores(:,2),'r.','MarkerSize',10)
hold on
plot(true_positive_scores(:,1),true_positive_scores(:,2),'g.','MarkerSize',10)
hold off
title('Recorded Scores');
legend('False Positives', 'True Positives');

% train SVM with gaussian kernel
% cl = fitcsvm(data,theclass,'KernelFunction','rbf',...
%     'BoxConstraint',Inf,'ClassNames',[-1,1]);

cl = fitcsvm(data,theclass,'KernelFunction','rbf',...
    'ClassNames',[-1,1]);

% predicted labels for each score point
[predicted_label, score, cost] = predict(cl,data);

predicted_results = [data, predicted_label];
ind1 = predicted_results(:,3) == 1;
ind2 = predicted_results(:,3) == -1;
predicted_neg = predicted_results(ind1,:);
predicted_pos = predicted_results(ind2,:);

subplot(1,2,2);
plot(predicted_neg(:,1),predicted_neg(:,2),'m.','MarkerSize',10)
hold on
plot(predicted_pos(:,1),predicted_pos(:,2),'b.','MarkerSize',10)
hold off
legend('Predicted Negatives', 'Predicted Positives');
title('SVM Predicted Scores');
suptitle('Visual Representation of HOG+DPM Cascade Scores (DPM T=Default)');
[ax1,h1]=suplabel('DPM Confidence Scores');
[ax2,h2]=suplabel('HOG Confidence Scores','y');
