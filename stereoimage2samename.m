
DataBaseDir = ['F:/data/test/'];
%DataBaseDir = ['./'];

%leftDir = [DataBaseDir 'left/'];
%rightDir = [DataBaseDir 'right/'];
leftDir = [DataBaseDir];
rightDir = [DataBaseDir];
leftDest = [DataBaseDir 'left/'];
rightDest = [DataBaseDir 'right/'];

leftImgs = dir([leftDir 'L_*.bmp']);
rightImgs = dir([rightDir 'R_*.bmp']);
mkdir(leftDest);
mkdir(rightDest);

%check
for i = 1:length(leftImgs)
    i
    mask_l = isstrprop(leftImgs(i).name, 'digit');
    num_l = leftImgs(i).name(mask_l);
    mask_r = isstrprop(rightImgs(i).name, 'digit');
    num_r = rightImgs(i).name(mask_r);
    if ~strcmp(num_l, num_r)
        disp(num_l);
        disp(num_r);
        assert(false);
    end
end
assert(length(leftImgs) == length(rightImgs));
for i = 1:length(leftImgs)
    mask_l = isstrprop(leftImgs(i).name, 'digit');
    num_l = leftImgs(i).name(mask_l);
    mask_r = isstrprop(rightImgs(i).name, 'digit');
    num_r = rightImgs(i).name(mask_r);
    if num_l == num_r
        name = sprintf('%s.bmp', num_l);
        I = (imread([leftDir leftImgs(i).name]));
        imwrite(I,[leftDest '' name]);
        I = (imread([rightDir rightImgs(i).name]));
        imwrite(I,[rightDest '' name]);
    else
        assert(false);
    end
end