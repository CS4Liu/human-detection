% store detection results in table structure
function results = get_detection_results(det_path)
        d = get_all_files(det_path, '*.csv');
        results(numel(d)) = struct('Boxes',[],'Scores',[], 'File_ID', []); % person detections
        for i=1:numel(d)
            filename=fullfile(det_path,d(i).name);
            try
                M = csvread(filename);
                scores = M(:,1);
                bboxes = [M(:,2),M(:,3),M(:,4),M(:,5)];
            catch
               bboxes = [];
               scores = [];
            end
            results(i).Boxes = bboxes;
            results(i).Scores = scores;
            filename = strsplit(filename,det_path);
            filename = filename(2);
            results(i).File_ID = filename;
            clear filename;
            clear bboxes;
            clear scores;
        end
        results = struct2table(results);
end
