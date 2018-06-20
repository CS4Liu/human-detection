function d = get_all_files (path, file_type)
    fil=fullfile(path,file_type);
    d=dir(fil);
end

