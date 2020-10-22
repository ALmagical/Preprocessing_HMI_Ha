close all;
import matlab.io.*
maindir='D:\Dataset\Filament\FITS\BBSO\';
subdir=dir(maindir);
maindir_save='D:\Dataset\Filament\JPG2\BBSO\';%����fitsͼ��·��
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
        %if exist(direc_m(Num).name,'file')
            %continue;
        %end
        file_name = strcat(datapath_m,direc_m(Num).name);
        file_save = strcat(path_save,direc_m(Num).name(1:length(direc_m(Num).name)-4),'.jpg');
        fits2jpg_bbso_ha(file_name,file_save);
    end
    disp([datapath_m,'�µ�',num2str(filetot),'�ļ��Ѵ������']);
    disp(['���гɹ�',num2str(filetot-errornum),'����ʧ��',num2str(errornum),'��']);
    numtot=numtot+filetot;
end
disp(['���ƴ���',num2str(numtot),'���ļ�']);