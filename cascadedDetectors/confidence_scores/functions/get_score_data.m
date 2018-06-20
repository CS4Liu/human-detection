% get scores corresponding to hog, dpm and store in array

% results_hogt0_dpmt1_hogscore
% 
load('/Users/ire/Desktop/Code/cascadedDetectors/results/2007/smallSet/small_hog_dpm/default_t0/score-classif-ids-dpmscore.mat');
load('/Users/ire/Desktop/Code/cascadedDetectors/results/2007/smallSet/small_hog_dpm/default_t0/score-classif-ids-hogscore.mat');
load('/Users/ire/Desktop/Code/cascadedDetectors/results/2007/smallSet/small_hog_dpm/t_1_t_0/score-classif-ids-dpmscore.mat');
load('/Users/ire/Desktop/Code/cascadedDetectors/results/2007/smallSet/small_hog_dpm/t_1_t_0/score-classif-ids-hogscore.mat');

true_positive_scores = ones(true_positives_hogt0_dpmtdef_dpmscore, 2);
for i=1:size(true_positive_scores,1)
    true_positive_scores(i,1) = true_positive_scores_hogt0_dpmtdef_dpmscore(i).Scores;
    true_positive_scores(i,2) = true_positive_scores_hogt0_dpmtdef_hogscore(i).Scores;
end

false_positive_scores = ones(false_positives_hogt0_dpmtdef_dpmscore, 2);
for i=1:size(false_positive_scores,1)
    false_positive_scores(i,1) = false_positive_scores_hogt0_dpmtdef_dpmscore(i).Scores;
    false_positive_scores(i,2) = false_positive_scores_hogt0_dpmtdef_hogscore(i).Scores;
end

set(groot,'defaulttextinterpreter','latex');  
set(groot, 'defaultAxesTickLabelInterpreter','latex');  
set(groot, 'defaultLegendInterpreter','latex');
set(gcf, 'Renderer', 'Painters');

subplot(1,2,1);
plot(false_positive_scores(:,1),false_positive_scores(:,2),'r.','MarkerSize',10);hold on;
plot(true_positive_scores(:,1),true_positive_scores(:,2),'g.','MarkerSize',10);

% xlabel('DPM Confidence Scores');
% ylabel('HOG Confidence Scores');
legend('True Positives', 'False Positives');
grid on;
title('DPM T=Default');
clear true_positive_scores; clear false_positive_scores;

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


subplot(1,2,2);
plot(false_positive_scores(:,1),false_positive_scores(:,2),'r.','MarkerSize',10);hold on;
plot(true_positive_scores(:,1),true_positive_scores(:,2),'g.','MarkerSize',10);

legend('True Positives', 'False Positives');
grid on;
title('DPM T=-1');

suptitle('Visual Representation of HOG+DPM Cascade Scores');
[ax1,h1]=suplabel('DPM Confidence Scores');
[ax2,h2]=suplabel('HOG Confidence Scores','y');