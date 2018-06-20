% remove false positives below a set threshold (score)
% originally for Standard DPM VOC 2007
det_path = '/Users/ire/Desktop/Code/DPM/annotations/2007/smallSet/inria/default/';
store_path = '/Users/ire/Desktop/Code/edgeDetection/high_scoring_tp/dpm/';
d = get_all_files(det_path, '*.csv');
for n=1:numel(d)
    floc=fullfile(det_path,d(n).name);
    try
        m = csvread(floc);
        m(m(:,1)<= 1.45, :)= [];
    catch
        continue
    end
    if isempty(m)
        continue
    end
    csvwrite(strcat(store_path,d(n).name), m);
end