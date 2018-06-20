% Transform bounding boxes from PASCAL (GT Annotations) to Matlab Format
function bndbox = get_bndbox(obj)
        xmin = str2double(obj.bndbox.xmin.Text);
        ymin = str2double(obj.bndbox.ymin.Text);
        xmax = str2double(obj.bndbox.xmax.Text);
        ymax = str2double(obj.bndbox.ymax.Text);
        bndbox = [xmin, ymin, (xmax-xmin+1), (ymax-ymin+1)];

    end

