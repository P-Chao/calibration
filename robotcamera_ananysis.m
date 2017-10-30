clear

DataDir = ['./task-2/'];
load([DataDir 'camera2world.mat']);
diff
figure, plot(1:length(error.err),error.err, 'k'), ylabel('error/mm'), xlabel('sample'), hold on
load([DataDir 'camera2world_rectified.mat']);
plot(1:length(error.err),error.err, 'b');
diff
