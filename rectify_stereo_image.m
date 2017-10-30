clear
load Calib_Results_stereo.mat
load Calib_Results_stereo_rectified.mat
[Irec_junk_left,ind_new_left,ind_1_left,ind_2_left,ind_3_left,...
    ind_4_left,a1_left,a2_left,a3_left,a4_left] = ...
rect_index(zeros(ny,nx),R_L,fc_left,cc_left,kc_left,alpha_c_left,KK_left_new);
[Irec_junk_left,ind_new_right,ind_1_right,ind_2_right,ind_3_right,...
    ind_4_right,a1_right,a2_right,a3_right,a4_right] = ...
rect_index(zeros(ny,nx),R_R,fc_right,cc_right,kc_right,alpha_c_right,KK_right_new);
clear Irec_junk_left

leftDir = ['./left/'];
rightDir = ['./right/'];
leftRectify = ['./leftRectify/'];
rightRectify = ['./rightRectify/'];

leftImgs = dir([leftDir '*.bmp']);
rightImgs = dir([rightDir '*.bmp']);
mkdir(leftRectify);
mkdir(rightRectify);

isgray = 1;
if(isgray)
for i = 1:length(leftImgs)
    mask_l = isstrprop(leftImgs(i).name, 'digit');
    num_l = leftImgs(i).name(mask_l);
    mask_r = isstrprop(rightImgs(i).name, 'digit');
    num_r = rightImgs(i).name(mask_r);
    if num_l == num_r
        name = sprintf('%s.bmp', num_l);
        
        I = double((imread([leftDir leftImgs(i).name])));
        I2 = 255 * ones(ny, nx);
        I2(ind_new_left) = uint8(a1_left .* I(ind_1_left) + ...
            a2_left .* I(ind_2_left) + a3_left .* I(ind_3_left) + a4_left .* I(ind_4_left));
        imwrite(uint8(I2),gray(256),[leftRectify '_' name]); 
        imwrite(uint8(I), gray(256),[leftDir '' name]);
        
        I = double((imread([rightDir rightImgs(i).name])));
        I2 = 255 * ones(ny, nx);
        I2(ind_new_right) = uint8(a1_right .* I(ind_1_right) + ...
            a2_right .* I(ind_2_right) + a3_right .* I(ind_3_right) + a4_right .* I(ind_4_right));
        imwrite(uint8(I2),gray(256),[rightRectify '_' name]);
        imwrite(uint8(I), gray(256),[rightDir '' name]);
    else
        assert(false);
    end
end
else
	for i = 1:length(leftImgs)
        mask_l = isstrprop(leftImgs(i).name, 'digit');
        num_l = leftImgs(i).name(mask_l);
        mask_r = isstrprop(rightImgs(i).name, 'digit');
        num_r = rightImgs(i).name(mask_r);
        if num_l ~= num_r
            assert(false);
        end
        name = sprintf('%s.bmp', num_l);
        %I = double(rgb2gray(imread([leftDir leftImgs(i).name])));
        
        Icolor = imread([leftDir leftImgs(i).name]);
        for j = 1:3
            I = double(Icolor(:,:,j));
            I2 = 255 * ones(ny, nx);
            I2(ind_new_left) = uint8(a1_left .* I(ind_1_left) + ...
                a2_left .* I(ind_2_left) + a3_left .* I(ind_3_left) + a4_left .* I(ind_4_left));
            Ir(:,:,j) = uint8(I2);
        end
        imwrite(Ir, [leftRectify '_' name]);
        
        Icolor = imread([rightDir rightImgs(i).name]);
        for j = 1:3
            I = double(Icolor(:,:,j));
            I2 = 255 * ones(ny, nx);
            I2(ind_new_right) = uint8(a1_right .* I(ind_1_right) + ...
            a2_right .* I(ind_2_right) + a3_right .* I(ind_3_right) + a4_right .* I(ind_4_right));
            Ir(:,:,j) = uint8(I2);
        end
        imwrite(Ir, [rightRectify '_' name]);
    end
end
saveRectifyResult;