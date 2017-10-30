
remap = reshape(1:nx*ny, nx, ny)';
remap = reshape(remap, 1, nx*ny);

fid = fopen('rectify.dat', 'w+');
left_length = length(a1_left);
right_length = length(a1_right);

%head: 
%cols rows
%a1_left_size = a2_left_size = a3_left_size = a4_left_size
%a1_right_size = a2_right_size = a3_right_size = a4_right_size
%ind_1_left = ind_2_left = ind_3_left = ind_4_left
%ind_1_right = ind_2_right = ind_3_right = ind_4_right
fwrite(fid, nx, 'uint32');
fwrite(fid, ny, 'uint32');
fwrite(fid, length(a1_left), 'uint32');
fwrite(fid, length(a1_right), 'uint32');

%save left
fwrite(fid, a1_left, 'single');
fwrite(fid, a2_left, 'single');
fwrite(fid, a3_left, 'single');
fwrite(fid, a4_left, 'single');
% C index start from 0, Matlab index start from 1
fwrite(fid, remap(ind_1_left)-1, 'uint32');
fwrite(fid, remap(ind_2_left)-1, 'uint32');
fwrite(fid, remap(ind_3_left)-1, 'uint32');
fwrite(fid, remap(ind_4_left)-1, 'uint32');
fwrite(fid, remap(ind_new_left)-1, 'uint32');

%save right
fwrite(fid, a1_right, 'single');
fwrite(fid, a2_right, 'single');
fwrite(fid, a3_right, 'single');
fwrite(fid, a4_right, 'single');
%save index
fwrite(fid, remap(ind_1_right)-1, 'uint32');
fwrite(fid, remap(ind_2_right)-1, 'uint32');
fwrite(fid, remap(ind_3_right)-1, 'uint32');
fwrite(fid, remap(ind_4_right)-1, 'uint32');
fwrite(fid, remap(ind_new_right)-1, 'uint32');


%check length
fwrite(fid, 5 + 9*length(a1_left) + 9*length(a1_right), 'uint32');

fclose(fid);
