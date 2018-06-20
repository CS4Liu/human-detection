% store ground truth boxes in table structure
function gt_bboxes = get_gt_bboxes(gt_path)
        d = get_all_files(gt_path, '*.xml');
        gt_bboxes(numel(d)) = struct('Boxes',[], 'Difficult',[], 'File_ID', []); % gt results
        for i=1:numel(d)
            filename=fullfile(gt_path,d(i).name);
            xml = xml2struct(filename);
            bboxes = [];
            diff = [];
            l = length(xml.annotation.object);
            if l>1
                for j=1:l
                obj = xml.annotation.object{1,j};
                    if string(obj.name.Text) == 'person'
                        bndbox = bboxToMatlab(obj);
                        bboxes = [bboxes; bndbox];
                        diffi = str2double(obj.difficult.Text);
                        diff = [diff;diffi];
                    end
                end
            else
                obj = xml.annotation.object;
                if string(obj.name.Text) == 'person'
                        bndbox = get_bndbox(obj);
                        bboxes = [bboxes; bndbox];
                        diffi = str2double(obj.difficult.Text);
                        diff = [diff;diffi];
                end 
            end

            filename = strsplit(filename,gt_path);
            filename = filename(2);
            gt_bboxes(i).Boxes = bboxes;
            gt_bboxes(i).File_ID = filename;
            gt_bboxes(i).Difficult = diff;

            clear diff
            clear bboxes
            clear filename
       end
        gt_bboxes = struct2table(gt_bboxes);


    end

