close all;
import matlab.io.*
maindir='D:\Dataset\FITS\HMI\';
subdir=dir(maindir);
maindir_save='D:\Dataset\JPG\HMI\';%����fitsͼ��·��
numtot=0;  %��¼������ļ���
for i=32:length(subdir)
    if( isequal( subdir( i ).name, '.' )||...
        isequal( subdir( i ).name, '..'))
        continue;
    end
    extname_m='*.fits';  
    if subdir(i).isdir
        datapath_m=strcat(maindir,subdir(i).name,'\');  
        path_save=strcat(maindir_save,subdir(i).name,'\');    
        %dir�������ָ���ļ����µ��������ļ��к��ļ�,���������һ��Ϊ�ļ��ṹ��������.
    else
        %��ǰ·�������ļ���
        datapath_m=strcat(maindir);  
        path_save=strcat(maindir_save);
    end
    direc_m=dir(strcat(datapath_m,extname_m));  %��strcat�������ַ�����������ʾ��ǰ·��Ŀ¼�µ��ļ����ļ���
    filetot=length(direc_m);
    %i=i+filetot;
    disp(['���ڴ���',datapath_m,'�µ��ļ����ļ�������',num2str(filetot)]);
    errornum=0;
    %batchsize=10;
    for Num=1:filetot
        file_name = strcat(datapath_m,direc_m(Num).name);
        
        file_name_save = direc_m(Num).name;
        if direc_m(Num).name(1:10)~="hmi.M_720s"
            file_name_save=strcat('hmi.M_720s',direc_m(Num).name);
        end
        %HMI�ļ�����ʾ����:hmi.M_720s.20101014_190000_TAI.1.magnetogram.jpg
        date=file_name_save(12:15);
        path_save=strcat(maindir_save,date,'\');
        if ~exist(path_save,'dir')
            mkdir(path_save);
        end
        file_save = strcat(path_save,file_name_save(1:length(direc_m(Num).name)-5),'.jpg');
        
        isfail=fits2jpg_hmi(file_name,file_save);
        if isfail==1
           disp(['��',num2str(Num),'���ļ�����ʧ��']);
           errornum=errornum+1;
           continue;
        end
    end
    disp([datapath_m,'�µ�',num2str(filetot),'�ļ��Ѵ������']);
    disp(['���гɹ�',num2str(filetot-errornum),'����ʧ��',num2str(errornum),'��']);
    numtot=numtot+filetot;
end
disp(['���ƴ���',num2str(numtot),'���ļ�']);