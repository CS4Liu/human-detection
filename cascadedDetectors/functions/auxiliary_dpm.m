function [out_dpm] = auxiliary_dpm(I, bboxes, scores)
% when other score : true it means keep other model's score instead of HOG
    load('INRIA/inriaperson_final');
    % model.thresh = -1;
    % dpm_t = [];
    out_dpm = [];
    for k2=1:size(bboxes,1)
        % test 1 : keep dpm score
        r = bboxes(k2,:); % detected box : roi
        imbox = imcrop(I,r);
        % original top-left coordinates of roi bbox
        % xmin, ymin of original box
        x_ref = r(1);
        y_ref = r(2);
        % ds [x1, y1, x2, y2, mod_comp, score]
        % attention : offset in xmin ymin dpm coordinates
        % tic;
        [ds, bs] = process(imbox, model);
        top = nms(ds, 0.5);
        ds = ds(top,:);
        % t_dpm = toc; % measure time including NMS to be fair
        % dpm_t = [dpm_t, t_dpm];
        % get final detections
        if ~isempty(ds)
            bboxes_dpm = [ds(:,1), ds(:,2), (ds(:,3)-ds(:,1)+1), (ds(:,4)-ds(:,2)+1)];
            scores_dpm = ds(:,5);
            scores_acf = ones(size(scores_dpm,1),1)*scores(k2);
            bboxes_dpm(:,1) = bboxes_dpm(:,1) + x_ref;
            bboxes_dpm(:,2) = bboxes_dpm(:,2) + y_ref;
            
        else
            bboxes_dpm = [];
            scores_dpm = [];
            scores_acf = [];
        end
        % draw bounding boxes onto image
        m=[scores_dpm,scores_acf,bboxes_dpm];
        out_dpm = vertcat(out_dpm,m);
    end
    % t_dpm = sum(dpm_t);
end

