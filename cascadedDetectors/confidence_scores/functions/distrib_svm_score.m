% distrib_svm_scores
% call to get values: [predicted_label, score, cost]
% theclass : contains real labels
svm_scores;

correct = [];
wrong = [];

for i=1:length(theclass)
    
    if isequal(predicted_label(i), theclass(i))
        correct = [correct, abs(score(i,1))];
    else
        wrong = [wrong, abs(score(i,1))];
    end
end



figure;
subplot(2,1,1)
hfp = histogram(correct,200,'FaceAlpha',0.5);
hfp.FaceColor = 'm'; hold on;
htp = histogram(wrong,200,'FaceAlpha',0.5);
htp.FaceColor = 'b';
hold off;
legend('Correct Prediction', 'Wrong Prediction');
title_str = sprintf("Total correct predictions: %d, Total wrong predictions: %d", length(correct), length(wrong));
title({'Distribution of SVM prediction scores, (DPM T=Default)';title_str});
xlabel('Detection Confidence Score');
ylabel('Frequency (No.)');
subplot(2,1,2)
hfp = histogram(correct,200,'FaceAlpha',0.5);
hfp.FaceColor = 'm'; hold on;
htp = histogram(wrong,200,'FaceAlpha',0.5);
htp.FaceColor = 'b';
hold off;
title('Close View');
xlabel('Detection Confidence Score');
ylabel('Frequency (No.)');