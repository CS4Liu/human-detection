% transform output of Matlab vision toolbox to PASCAL bbox format
% [xmin ymin width height]->[xmin ymin xmax ymax]
function pascalBboxes = bboxesToPascal( bboxes )
    s=size(bboxes);
    for i=1:s(1)
        bboxes(i,3)=bboxes(i,1)+bboxes(i,3)-1;
        bboxes(i,4)=bboxes(i,2)+bboxes(i,4)-1;
    end
    pascalBboxes=bboxes;
end

