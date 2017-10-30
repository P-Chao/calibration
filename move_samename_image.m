% 提取左右图像，I开头的

leftPath = 'left/';
rightPath = 'right/';

left_path_list = dir(strcat(leftPath, '*.bmp'));
right_path_list = dir(strcat(rightPath, '*.bmp'));

leftLength = length(left_path_list);
rightLength = length(right_path_list);

assert(leftLength == rightLength);
img_num = leftLength;

for i = 1:img_num
    leftName = left_path_list(i).name;
    if(leftName(1) ~= 'I')
        leftImage = imread(strcat(leftPath,leftName));
        %mask = isstrprop(leftName, 'digit');
        %num = uint32(str2num(leftName(mask)));
        imwrite(leftImage, strcat('left',leftName));
    end
    rightName = right_path_list(i).name;
    if(rightName(1) ~= 'I')
        rightImage = imread(strcat(rightPath,rightName));
        imwrite(rightImage, strcat('right',rightName));
    end
end
