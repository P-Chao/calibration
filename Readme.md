Calibration Toolbox
===

工具箱文件说明
---
* Calibration.m，演示抵用工具箱进行三角坐标转换
* png2bmp.m，将png文件转化为bmp文件
* extract_stereo_image.m，将两个文件夹中的双目图像（left\和right\）提取到一个文件夹中，并按照数字顺序标号命名
* move_savename_image.m，将指定前缀的左右图像，从两个文件夹中提取到同一个文件夹中，并将前缀改为left和right
* stereoimage2samename.m，将数据文件夹中的L_*.bmp和R_*.bmp双目图像（可以是在两个文件夹中，要修改代码注释），移动到left\和right\并按照顺序标号，修改名字去掉前缀
* rectify_stereo_image.m，对left\和right\中的双目图像，矫正到leftRectify\和rightRectify\，需要在代码中指定是否转换灰度图像
* robotcamera_ananysis.m，显示机器人标定的数值结果和误差曲线
* robotcamera_gui，机器人标定GUI工具
* saveRectifyResult.m，将矫正需要的数据保存到rectify.dat以方便其它程序读取

相机标定操作流程
---

0.	将相机标定工具箱加入工具路径setpath
1.	如果采集的图像不是bmp格式，请使用png2bmp将其转换为bmp格式，并将左右图像分别存放在不同的文件夹（left/和 right/中），左右对应图像文件名相同
2.	将bmp图像拷贝到工具箱所在目录下，此时的图像带有前缀L_*.bmp和R_*.bmp
3.	新建left\和right\文件夹，运行stereoimage2samename.m，将图像进行移动和改名，并将原先的L_*.bmp和R_*.bmp删除
4.	运行extract_stereo_image.m，将left和right文件夹中的图像移动到当前文件夹中，并按照1234..顺序进行命名
5.	运行calib_gui，输入left图像，对左相机进行标定，对结果mat文件重命名，添加后缀left，然后输入right，对右相机进行标定，对mat进行重命名
6.	运行stereo_gui，进行双目标定，标定好之后需要运行一次矫正（点击矫正按钮），该操作将添加矫正需要的标量到mat文件中，否则无法生成矫正文件，然后如果不需要可以删除矫正后的图像文件
7.	运行saveRectifyResult，生成立体矫正需要的.dat文件

机器人标定操作流程
---

1.	新建并清空/left和/right文件夹，将L_*.bmp与R_*.bmp的机器人图像拷贝到工具目录
2.	运行stereoimage2samename.m，将图像移动到left和right文件夹下
3.	运行rectify_stereo_image.m，矫正的机器人文件放到了leftRectify和rightRectify文件夹，现在可以删除根目录下的L*bmp和R*bmp了
4.	新建pos文件夹，并清空该文件夹
5.	运行机器人标定工具，使用空格键切换，使用鼠标点选，使用asdw和上下左右方向键微调左右位置，注意极线约束
6.	Robot.xls拷贝到工具目录下，第一列为文本格式，或者留空（防止读入无用数据），使得最终读入的数据是表格前三列，分别为x,y,z
7.	点击Generate，生成误差图像，生成rectify.dat软件
