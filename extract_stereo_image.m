clear

leftDir = ['./task-2/left/'];
rightDir = ['./task-2/right/'];
OutDir = ['./task-2/'];

leftImgs = dir([leftDir '*.bmp']);
rightImgs = dir([rightDir '*.bmp']);
mkdir(OutDir);

isgray = 1;
if(isgray)
for i = 1:length(leftImgs)
    %if(strcmp(leftImgs(i).name, rightImgs(i).name))
    mask_l = isstrprop(leftImgs(i).name, 'digit');
    num_l = uint32(str2num(leftImgs(i).name(mask_l)));
    mask_r = isstrprop(rightImgs(i).name, 'digit');
    num_r = uint32(str2num(rightImgs(i).name(mask_r)));
    if num_l == num_r
        name = sprintf('%d.bmp', i);
        
        I = imread([leftDir leftImgs(i).name]);
        imwrite(I,[OutDir 'left_' name]);
        
        I = imread([rightDir rightImgs(i).name]);
        imwrite(I,[OutDir 'right_' name]);
    end
end
else
   
end