% Image edges experiment (1): directly recording directions in edges

% false alarms common to four models - start with hardest FA
% also serves for highest scoring TP path
false_alarm_patch_path = '/Users/ire/Desktop/Code/edgeDetection/high_scoring_tp/dpm/';

% input image path
input_image_path = '/Users/ire/Desktop/Code/VOCdevkit/VOC2007/JPEGImages/smallSet/';

% output path to save orientation arrays
out_array_path ='/Users/ire/Desktop/Code/edgeDetection/true_positive_patches/orientation_arrays/dpm/test/';
out_image_path = '/Users/ire/Desktop/Code/edgeDetection/true_positive_patches/image_patches/dpm/';

d = get_all_files(false_alarm_patch_path, '*.csv');
for n=1:numel(d)
    floc=fullfile(false_alarm_patch_path,d(n).name);
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
        % Fpp 'false positive patch'
        Fpp = imcrop(I,r);
        h = imshow(Fpp);
        % saveas(h,strcat(out_image_path,'Fpp_',i,'.png'));
        % Get edge patches
        edgeFp = rgb2gray(Fpp);
        edge_sobel = edge(edgeFp,'sobel');
        h=imshow(edge_sobel);
        % saveas(h,strcat(out_image_path,'Fpp_sobel_',i,'.png'));
        getOrientations = skeletonOrientation(edge_sobel,5); %5x5 box by default
        % getOrientations = nonzeros(Orientations); % save getOrientations variable
        save(strcat(out_array_path,'sobel_',i),'getOrientations');

        edge_prewitt = edge(edgeFp,'prewitt');
        h=imshow(edge_prewitt);
        % saveas(h,strcat(out_image_path,'Fpp_prewitt_',i,'.png'));
        getOrientations = skeletonOrientation(edge_prewitt,5); %5x5 box by default
        %getOrientations = nonzeros(Orientations); % save getOrientations variable
        save(strcat(out_array_path,'prewitt_',i),'getOrientations')

        edge_roberts = edge(edgeFp,'roberts');
        h=imshow(edge_roberts);
        % saveas(h,strcat(out_image_path,'Fpp_roberts_',i,'.png'));
        getOrientations = skeletonOrientation(edge_roberts,5); %5x5 box by default
        %getOrientations = nonzeros(Orientations); % save getOrientations variable
        save(strcat(out_array_path,'roberts_',i),'getOrientations')

        edge_log = edge(edgeFp,'log');
        h=imshow(edge_log);
        % saveas(h,strcat(out_image_path,'Fpp_log_',i,'.png'));
        getOrientations = skeletonOrientation(edge_log,5); %5x5 box by default
        %getOrientations = nonzeros(Orientations); % save getOrientations variable
        save(strcat(out_array_path,'log_',i),'getOrientations')

        edge_zerocross = edge(edgeFp,'zerocross');
        h=imshow(edge_zerocross);
        % saveas(h,strcat(out_image_path,'Fpp_zerocross_',i,'.png'));
        getOrientations = skeletonOrientation(edge_zerocross,5); %5x5 box by default
        %getOrientations = nonzeros(Orientations); % save getOrientations variable
        save(strcat(out_array_path,'zerocross_',i),'getOrientations')

        edge_canny = edge(edgeFp,'canny');
        h=imshow(edge_canny);
        % saveas(h,strcat(out_image_path,'Fpp_canny_',i,'.png'));
        getOrientations = skeletonOrientation(edge_canny,5); %5x5 box by default
        %getOrientations = nonzeros(Orientations); % save getOrientations variable
        save(strcat(out_array_path,'canny_',i),'getOrientations')
    end
end