%%%
%拼接多幅图像
%%
clear variables;
close all;
import matlab.io.*
%计时
tic;
t1=clock;
maindir_ha='D:\Dataset\Result_20210531\final\test';
maindir_hmi='D:\Dataset\Result_20210526\base\test';
maindir_fu='D:\Dataset\Filament_detect\20210528\test';
maindir_save_fusion='D:\Dataset\Result_20210531\CAT\test';
subdir_ha=dir(maindir_ha);
subdir_hmi=dir(maindir_hmi);
subdir_fu=dir(maindir_fu);
numtot=0;  %记录处理的文件数
extname_ha='*.jpg'; 
extname_hmi='*.jpg';
extname_fu='*.jpg';
dirnum_ha=length(subdir_ha);
dirnum_hmi=length(subdir_hmi);
dirnum_fu=length(subdir_fu);
i=0;
j=0;
k=0;
while((0<=i) && (i<dirnum_ha) && (j>=0) && (j<dirnum_hmi) &&...
        (k>=0) && (k<dirnum_hmi))
    i=i+1;
    j=j+1;
    k=k+1;
    num_finish=0;
    if( isequal( subdir_ha( i ).name, '.' )||...
            isequal( subdir_ha( i ).name, '..'))              
        continue;
    end
    
    if( isequal( subdir_hmi( j ).name, '.' )||...
            isequal( subdir_hmi( j ).name, '..'))
%            ~subdir_hmi( j ).isdir)               % 如果不是目录则跳过
        continue;
    end
    if( isequal( subdir_fu( k ).name, '.' )||...
            isequal( subdir_fu( k ).name, '..'))
        continue;
    end
    %判断文件夹名称是否匹配
    %     if ((i<=dirnum_ha) && (j<=dirnum_hmi) && (k<=dirnum_fu))
    %         false=0;
    %         文件夹命名格式示例：2010
    %         while subdir_ha(i).name ~= subdir_hmi(j).name ...
    %                 && subdir_ha(i).name ~= subdir_fu(k).name
    %             name_ha=subdir_ha(i).name;
    %             name_hmi=subdir_hmi(j).name;
    %             name_fu=subdir_fu(k).name;
    %             if str2double(name_ha)<str2double(name_hmi)
    %                 i=i+1;
    %             elseif str2double(name_ha)>str2double(name_hmi)
    %                 j=j+1;
    %             else
    %                 disp(['文件夹名称不匹配',',Ha文件夹名称为:',subdir_ha(i)...
    %                     ,'HMI文件夹名称为:',subdir_hmi(j)],'。请检查文件夹名称！');
    %                 false=1;
    %             end
    %         end
    %         if (false==1)
    %             continue;
    %         end
    datapath_ha=strcat(maindir_ha,subdir_ha(i).name,'\');  %读取Ha文件的路径
    datapath_hmi=strcat(maindir_hmi,subdir_hmi(i).name,'\');%读取hmi文件的路径
    datapath_fu=strcat(maindir_fu,subdir_fu(i).name,'\');%读取fusion文件的路径
    datapath_ha=strcat(maindir_ha,'\');
    datapath_hmi=strcat(maindir_hmi,'\');
    datapath_fu=strcat(maindir_fu,'\');
    %保存文件的路径
    path_save_fusion=strcat(maindir_save_fusion,subdir_ha(i).name,'\');
    
    %dir函数获得指定文件夹下的所有子文件夹和文件,并存放在在一种为文件结构体数组中.
    direc_ha=dir(strcat(datapath_ha,extname_ha));  %显示当前路径目录下的文件和文件夹
    direc_hmi=dir(strcat(datapath_hmi,extname_hmi));
    direc_fu=dir(strcat(datapath_fu,extname_fu));
    filenum_ha=length(direc_ha);
    filenum_hmi=length(direc_hmi);
    filenum_fu=length(direc_fu);
    %文件夹为空则结束
    if filenum_ha==0
        disp(['‘',datapath_ha,'’，为空文件夹。']);
        j=j-1;       %控制mdi文件夹保持不变
        continue;
    end
    if filenum_hmi==0
        disp(['‘',datapath_hmi,'’，为空文件夹。']);
        i=i-1;
        continue;
    end
    if filenum_fu==0
        disp(['‘',datapath_fu,'’，为空文件夹。']);
        i=i-1;
        continue;
    end
    %存储路径下文件夹不存在时创建文件夹
    if ~exist(path_save_fusion,'dir')
        mkdir(path_save_fusion);
    end
    if filenum_ha~=filenum_hmi && filenum_ha~=filenum_fu
        disp('图像数量不匹配');
        disp(['未处理',datapath_ha,';',datapath_hmi,';',datapath_fu]);
    else
        
        parfor m=1:filenum_ha
            tic;
            ha=imread(strcat(datapath_ha,direc_ha(m).name));
            hmi=imread(strcat(datapath_hmi,direc_hmi(m).name));
            [h,w,c]=size(ha);
            if c==1
                Ha=zeros(h,w,3);
                Ha(:,:,1)=ha;
                Ha(:,:,2)=Ha(:,:,1);
                Ha(:,:,3)=Ha(:,:,1);
            else
                Ha=ha;
            end
            [h,w,c]=size(hmi);
            if c==1
                Hmi=zeros(h,w,3);
                Hmi(:,:,1)=hmi;
                Hmi(:,:,2)=Hmi(:,:,1);
                Hmi(:,:,3)=Hmi(:,:,1);
            else
                Hmi=hmi;
            end
            file_save_fusion=strcat(path_save_fusion,direc_ha(m).name(1:length(direc_ha(k).name)-4),'_fusion.jpg');
            fusion=imread(strcat(datapath_fu,direc_fu(m).name));
            [h,w,c]=size(fusion);
            if c==1
                Fusion=zeros(h,w,3);
                Fusion(:,:,1)=fusion;
                Fusion(:,:,2)=fusion(:,:,1);
                Fusion(:,:,3)=fusion(:,:,1);
            else
                Fusion=fusion;
            end
%             a=ones(20,2048,3);
%             a=im2uint8(a);
            result=cat(2,Hmi,Ha,Fusion);
            imwrite(result,file_save_fusion,'jpg','Quality',100);
        end
    end
    disp([datapath_ha,'处理完成，花费时间：',num2str(toc),'s']);
end

time=etime(clock,t1);
secs=mod(time,60);
mins=fix(time/60);
hours=fix(mins/60);
mins=mod(mins,60);
disp(['程序总运行时间：',num2str(hours),' h ',num2str(mins),' m ',num2str(secs),' s']);