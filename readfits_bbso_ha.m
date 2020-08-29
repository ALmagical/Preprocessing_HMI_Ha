close all;
import matlab.io.*
maindir='C:\Users\11054\Desktop\BBSO\Fits\';
subdir=dir(maindir);
maindir_save='C:\Users\11054\Desktop\BBSO\Jpg\';%����fitsͼ��·��
numtot=0;  %��¼������ļ���
for i=1:length(subdir)
    if( isequal( subdir( i ).name, '.' )||...
        isequal( subdir( i ).name, '..')||...
        ~subdir( i ).isdir)               % �������Ŀ¼������
        continue;
    end
    datapath_m=strcat(maindir,subdir(i).name,'\');  %��ȡfits�ļ���·��
    path_save=strcat(maindir_save,subdir(i).name,'\');%����fitsͼ��·��    
    extname_m='*.fts';  
    direc_m=dir(strcat(datapath_m,extname_m));  %��strcat�������ַ�����������ʾ��ǰ·��Ŀ¼�µ��ļ����ļ���
    %dir�������ָ���ļ����µ��������ļ��к��ļ�,���������һ��Ϊ�ļ��ṹ��������.
    filetot=length(direc_m);
    if ~exist(path_save,'dir')
        mkdir(path_save);
    end
    disp(['���ڴ���',datapath_m,'�µ��ļ����ļ�������',num2str(filetot)]);
    errornum=0;
    %batchsize=10;
    for Num=1:filetot
        if exist(direc_m(Num).name,'file')
            continue;
        end
        file_name = strcat(datapath_m,direc_m(Num).name);
        fptr = fits.openFile(file_name);
        info = fitsinfo(file_name);
        data = fits.readImg(fptr);
        [high,width]=size(data);
        %data=data+32768;
        %data_log=log(double(data));
        data_log=data;
        data_max=max(max(data_log));
        data_min=min(min(data_log));
        data_gray=double((data_log-data_min))/double((data_max-data_min));
        data_gray=uint8(255*data_gray);
        %data_gray=uint16(data);
        %data_gray=data;
        %����תԭͼ��
        final_img=flipud(data_gray);
        imwrite(final_img,strcat(path_save,direc_m(Num).name(1:length(direc_m(Num).name)-4),'.jpg'),'jpg','Quality',100);
        fits.closeFile(fptr); 
        %close all;
    end
    disp([datapath_m,'�µ�',num2str(filetot),'�ļ��Ѵ������']);
    disp(['���гɹ�',num2str(filetot-errornum),'����ʧ��',num2str(errornum),'��']);
    numtot=numtot+filetot;
end
disp(['���ƴ���',num2str(numtot),'���ļ�']);