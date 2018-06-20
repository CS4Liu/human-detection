% store detection results in table structure
function results = get_detection_results_cascade(det_path)
        d = get_all_files(det_path, '*.csv');
        results(numel(d)) = struct('Boxes',[],'Scores_A',[],'Scores_B',[], 'File_ID', []); % person detections
        for i=1:numel(d)
            filename=fullfile(det_path,d(i).name);
            try
                M = csvread(filename);
                scores_a = M(:,1);
                scores_b = M(:,2);
                bboxes = [M(:,3),M(:,4),M(:,5),M(:,6)];
            catch
               bboxes = [];
               scores_a = [];
               scores_b = [];
            end
            results(i).Boxes = bboxes;
            results(i).Scores_A = scores_a;
            results(i).Scores_B = scores_b;
            filename = strsplit(filename,det_path);
            filename = filename(2);
            results(i).File_ID = filename;
            clear filename;
            clear bboxes;
            clear scores_a;
            clear scores_b;
        end
        results = struct2table(results);
end