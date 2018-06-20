% store test person bounding boxes in matrix
function person_bboxes = readAnnotations( annotations_xml )

person_bboxes = [];

s1=xml2struct(annotations_xml);
objects=s1.annotation.object;
for i=1:length(objects)
    s2 = cell2struct(objects(i), 'fields');
    
    if strcmp(s2.fields.name.Text,'person')
        xmin = str2double(s2.fields.bndbox.xmin.Text);
        ymin = str2double(s2.fields.bndbox.ymin.Text);
        xmax = str2double(s2.fields.bndbox.xmax.Text);
        ymax = str2double(s2.fields.bndbox.ymax.Text);
        
        vec = [xmin, ymin, xmax, ymax];
        person_bboxes=[person_bboxes; vec];
    end
end

end

