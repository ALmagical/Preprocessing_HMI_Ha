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
    extname_m='*.fits';  
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
        file_name = strcat(datapath_m,direc_m(Num).name);
        try
           final_img = fitsread(file_name,'image');
        catch
           disp(['��',num2str(Num),'���ļ�����ʧ��']);
           errornum=errornum+1;
           continue;
        end
        final_img = uint8((double(final_img)+500)/(500+500)*255);
        final_img=fliplr(final_img);     % fliplr( )�������ҷ�ת����
        %imwrite(final_img,strcat(Direc_m(Num).name(1:length(Direc_m(Num).name)-5),'.jpg'));      % �����ͼͼƬ
        %imwrite(final_img,strcat(magneticjpg,Direc_m(Num).name(1:length(Direc_m(Num).name)-5),'.jpg'),'jpg','bitdepth',16,'Quality',100);
        imwrite(final_img,strcat(path_save,direc_m(Num).name(1:length(direc_m(Num).name)-5),'.jpg'),'jpg','Quality',100);
        %fits.closeFile(fptr);
        %close all;
    end
    disp([datapath_m,'�µ�',num2str(filetot),'�ļ��Ѵ������']);
    disp(['���гɹ�',num2str(filetot-errornum),'����ʧ��',num2str(errornum),'��']);
    numtot=numtot+filetot;
end
disp(['���ƴ���',num2str(numtot),'���ļ�']);