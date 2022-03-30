import matlab.io.*

path_data='D:\Dataset\Filament_detect\Segmantic1\SegmentationClassPNG\';
path_save='D:\Dataset\Filament_detect\Segmantic1\SegmentationClassJPG\';
ext_name='*.png';
direc=dir(strcat(path_data,ext_name));

filetot=length(direc);

for num=1:filetot
    [img,map,alpha]=imread(strcat(path_data,direc(num).name));
    %figure,imshow(img,map);
    imwrite(img,map,strcat(path_save,direc(num).name(1:length(direc(num).name)-4)),...
        'jpg','Quality',100);
end