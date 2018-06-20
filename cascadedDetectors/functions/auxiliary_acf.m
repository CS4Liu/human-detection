% auxiliary acf
function [out_acf] = auxiliary_acf(I, bboxes, scores)
    load('models/AcfInriaDetector.mat','detector');
    out_acf = [];
    nms = struct('type', 'ms', 'overlap', 0.5);
    pModify=struct('pNms', [nms]);
    detector=acfModify(detector,pModify);
    
    for k2=1:size(bboxes,1)
        disp(k2);
        % test 1 : keep dpm score
        r = bboxes(k2,:); % detected box : roi
        imbox = imcrop(I,r);
        % original top-left coordinates of roi bbox
        % xmin, ymin of original box
        x_ref = r(1);
        y_ref = r(2);
        
        % attention : offset in xmin ymin dpm coordinates
        % bbs [x1, y1, w, h, score]
        try
            bbs = acfDetect(imbox, detector);
        catch
            bbs = [];
        end
        % get final detections
        if ~isempty(bbs)
            bboxes_acf = [bbs(:,1), bbs(:,2), bbs(:,3), bbs(:,4)];
            scores_acf = bbs(:,5);
            scores_defpm = ones(size(scores_acf,1),1)*scores(k2);
            bboxes_acf(:,1) = bboxes_acf(:,1) + x_ref;
            bboxes_acf(:,2) = bboxes_acf(:,2) + y_ref;
        else
            bboxes_acf = [];
            scores_acf = [];
            scores_defpm = [];
        end
        % draw bounding boxes onto image
        m=[scores_defpm,scores_acf,bboxes_acf];
        out_acf = vertcat(out_acf,m);
    end
end
