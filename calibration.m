%calib_gui;
%stereo_gui;
load('Calib_Results_stereo.mat');
load('Calib_Results_stereo_rectified.mat');

xL = [  407    412    111     514;
        173    163     86      358];

xR = [  460    450     126    536;
        173    181     115    378];

% for not rectified
[XL, XR] = stereo_triangulation(xL,xR,om,T,...
    fc_left,cc_left,kc_left,alpha_c_left,...
    fc_right,cc_right,kc_right,alpha_c_right);

% for rectified
[YL, YR] = stereo_triangulation(xL,xR,om_new,T_new,...
    fc_left_new,cc_left_new,kc_left_new,alpha_c_left_new,...
    fc_right_new,cc_right_new,kc_right_new,alpha_c_right_new);

%norm(XL(:,3)-XL(:,4))
