clear variables;
close all;
path_ha='C:\Users\11054\Desktop\smart201110\jpg\';%保存ha图的路径
path_save='C:\Users\11054\Desktop\smart201110\circle\';%存储结果
extname_m='*.jpg';
%读取文件列表
%（strcat：连接字符串函数）显示当前路径目录下的文件和文件夹
Direc_ha=dir(strcat(path_ha,extname_m));
filenum_ha=length(Direc_ha);

%unit_y=fspecial('gaussian',[5,5],1)*255;
%unit_n=fspecial('gaussian',[5,5],1);
unitsize=9;
unit=zeros(unitsize);
unit_zero=unitsize;
unit_center=(unitsize-1)/2;
for j=1:unitsize
    unit_zero=unit_zero-1;
    control_zero=abs(unit_zero-unit_center);
    for k=1:unitsize-control_zero
        if (k-control_zero)>0            
            unit(j,k)=1;
        end
    end
end

for i=1:filenum_ha     
    ha=imread(strcat(path_ha,Direc_ha(i).name));
    %获取图像中日面的半径
    [h_ha,w_ha]=size(ha);
    %
    gaus_kernel = fspecial('gaussian',[10,10],1);
    ha_filter = imfilter(ha,gaus_kernel,'replicate');
    %
    ha_ulc=Luminance_Correction(ha_filter);
    %下采样
    downsample_ratio=h_ha/256; %将图像缩小为256×256
    ha_low=imresize(ha_ulc,[int16(h_ha/downsample_ratio),int16(w_ha/downsample_ratio)]);
    %二值化
    ha_edge=imbinarize(ha_low);
    [h_haedge,w_haedge]=size(ha_edge);
    r_range=min(h_haedge,w_haedge);
    %圆拟合，将ha图像中的日面与hmi图像中的日面缩放到相同大小
    [center,radius]=imfindcircles(ha_edge,[int16(r_range*0.2),r_range],'Method','TwoStage','Sensitivity',0.9);%TwoStage指定拟合方法为霍夫变换
    if size(center)~=0
        center=center*downsample_ratio;
        radius=radius*downsample_ratio;

        R=ha_ulc;
        G=ha_ulc;
        B=ha_ulc;
        theta=0:0.001:2*pi+0.1;
        Circle1=center(1)+radius*cos(theta);
        Circle2=center(2)+radius*sin(theta);
        y_int=int16(Circle1);
        x_int=int16(Circle2);
        for j=1:length(x_int)
            for m=-(unit_center-1):unit_center+1
                for n=-(unit_center-1):unit_center+1
                    if unit(m+unit_center,n+unit_center)==1
                        if 0<(x_int(j)+m) && (x_int(j)+m)<=h_ha && 0<(y_int(j)+n) && (y_int(j)+n)<=w_ha
                          R(x_int(j)+m,y_int(j)+n)=255;
                          G(x_int(j)+m,y_int(j)+n)=0;
                          B(x_int(j)+m,y_int(j)+n)=0;
                        end
                    end
                end
            end
        end
        result=zeros(h_ha,w_ha,3);
        result(:,:,1)=R;
        result(:,:,2)=G;
        result(:,:,3)=B;
        %figure();
        %imshow(uint8(result));
        imwrite(uint8(result),strcat(path_save,Direc_ha(i).name(1:length(Direc_ha(i).name)-4),'.jpg'),'jpg','Quality',100);
        %plot(Circle1,Circle2,'r');
        %axis equal
        %viscircles(center,radius,'EdgeColor','r');
        %set(gcf, 'PaperPositionMode', 'manual');
        %set(gcf, 'PaperUnits', 'points');
        %set(gcf, 'PaperPosition', [0 0 h_ha w_ha]);
        %print(gcf,'-dpng',strcat(path_save,Direc_ha(i).name));
    end
end