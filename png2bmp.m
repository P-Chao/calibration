images = dir(['L_*.png']);
for i = 1:length(images)
    mask = isstrprop(images(i).name, 'digit');
    num = images(i).name(mask);
    
    f = imread(images(i).name);
    imwrite(f,['L_' num '.bmp']);
end
