% get true and false overlap values
det_path = '/Users/ire/Desktop/Code/falseAlarms/ACF/inria/ms_nms/hard/';
d = get_all_files(det_path, '*.csv');
overlap_cclassified = [];
correct_classified = [];
incorrect_classified = [];
score=[];
for n=1:numel(d)
    floc=fullfile(det_path,d(n).name);
    m = csvread(floc);
    disp(floc);
    disp(m);
    try
        m_olap_correctflag = m(:,[6,7]); % overlap, correctly_classified   
    catch
        continue
    end
    overlap_cclassified = vertcat(overlap_cclassified,m_olap_correctflag);
end
fa = size(overlap_cclassified);
fa = fa(1);
for i=1:fa
    item = overlap_cclassified(i,:);
    if item(2)==1 % correctly classified flag
        correct_classified = [correct_classified, item(1)];
        
    else
        incorrect_classified = [incorrect_classified, item(1)];
    end
end

n_correct=length(correct_classified);
n_incorrect=length(incorrect_classified);
n_correct=string(n_correct);
n_incorrect=string(n_incorrect);

% latex display
set(groot,'defaulttextinterpreter','latex');  
set(groot, 'defaultAxesTickLabelInterpreter','latex');  
set(groot, 'defaultLegendInterpreter','latex');
set(gcf, 'Renderer', 'Painters');

hfp = histogram(incorrect_classified,10,'FaceAlpha',0.5);
hfp.FaceColor = 'r'; hold on;
htp = histogram(correct_classified, 90, 'FaceAlpha',0.5);
htp.FaceColor = 'g';
hold off;
legend('Incorrect', 'Correct');
xlabel('Detection, Ground Truth Overlap');
title({'False positive and ground truth overlap distribution for ACF INRIA Model';sprintf('Total Correct: %s, Total Incorrect: %s', [n_correct, n_incorrect])})