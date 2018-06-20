% normalised edge orientation distribution

% Image edges experiment (2): edge score classification
% edge score : no_pixels/total pixels in patch

detected_patch_path = '/Users/ire/Desktop/Code/falseAlarms/LDCF/inria/ms_nms/';

% canny, zero edjes observed extract most information
canny_patch_edge_scores_ldcf = [];
zero_patch_edge_scores_ldcf = [];
% store score arrays
out_array_path = '/Users/ire/Desktop/Code/edgeDetection/edgeScores/false_positives/ldcf/';
% input image path
input_image_path = '/Users/ire/Desktop/Code/VOCdevkit/VOC2007/JPEGImages/smallSet/';


d = get_all_files(detected_patch_path, '*.csv');
for n=1:numel(d)
    floc=fullfile(detected_patch_path,d(n).name);
    imname = strsplit(d(n).name,'.csv');
    imname = imname{1};
    i = imname;
    imname = strcat(imname,'.jpg');
    imloc = fullfile(input_image_path,imname);
    I = imread(imloc);
    m = csvread(floc);
    % number of false alarm patches in m
    no_fa = size(m);
    no_fa = no_fa(1);
    for j=1:no_fa
        tmpm = m(j,:);
        i = strcat(i,int2str(j));
        % r: rectangle i want to cut [xmin ymin width height]
        r = tmpm(:,[2,3,4,5]);
        clear tmpm;
        % patch 'false positive patch'
        patch = imcrop(I,r);
        h = imshow(patch);
        % Get edge patches
        edgeFp = rgb2gray(patch);
        
        edge_zerocross = edge(edgeFp,'zerocross');
        zero_score = getEdgeScore(edge_zerocross);
        zero_patch_edge_scores_ldcf = [zero_score, zero_patch_edge_scores_ldcf];
        clear zero_score;

        edge_canny = edge(edgeFp,'canny');
        canny_score = getEdgeScore(edge_canny);
        canny_patch_edge_scores_ldcf = [canny_score, canny_patch_edge_scores_ldcf];
        clear canny_score;    
    end
end
save(strcat(out_array_path,'edge_scores.mat'),'zero_patch_edge_scores_ldcf','canny_patch_edge_scores_ldcf')