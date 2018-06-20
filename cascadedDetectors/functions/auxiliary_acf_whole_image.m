% auxiliary acf whole image
function [out_acf] = auxiliary_acf_whole_image(I)
    load('models/AcfInriaDetector.mat','detector');
    out_acf = [];
    nms = struct('type', 'ms', 'overlap', 0.5);
    pModify=struct('pNms', [nms]);
    detector=acfModify(detector,pModify);

    bbs = acfDetect(I, detector);
    % get final detections
    if ~isempty(bbs)
        bboxes_acf = [bbs(:,1), bbs(:,2), bbs(:,3), bbs(:,4)];
        scores_acf = bbs(:,5);
        % do not have any info. about dpm score - 
        % score info. can only come from acf
        scores_defpm = scores_acf;
    else
        bboxes_acf = [];
        scores_acf = [];
        scores_defpm = [];
    end
    % draw bounding boxes onto image
    m=[scores_defpm,scores_acf,bboxes_acf];
    out_acf = vertcat(out_acf,m);
end