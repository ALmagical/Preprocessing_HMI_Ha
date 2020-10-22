close all;
import matlab.io.*
maindir='C:\Users\11054\Desktop\';
subdir=dir(maindir);
maindir_save='C:\Users\11054\Desktop\';%����fitsͼ��·��
numtot=0;  %��¼������ļ���
for i=1:length(subdir)
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
    %dir�������ָ���ļ����µ��������ļ��к��ļ�,���������һ��Ϊ�ļ��ṹ��������.
    filetot=length(direc_m);
    i=i+filetot;
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
        %�����Ա任 sigmoid
        final_img=final_img/50;
        final_img=uint8(sigmoid(final_img)*255);
        %end
        %final_img = uint8((double(final_img)+500)/(500+500)*255);
        final_img=fliplr(final_img);     % fliplr( )�������ҷ�ת����
        %imwrite(final_img,strcat(Direc_m(Num).name(1:length(Direc_m(Num).name)-5),'.jpg'));      % �����ͼͼƬ
        %imwrite(final_img,strcat(magneticjpg,Direc_m(Num).name(1:length(Direc_m(Num).name)-5),'.jpg'),'jpg','bitdepth',16,'Quality',100);
        imwrite(final_img,strcat(path_save,direc_m(Num).name(1:length(direc_m(Num).name)-5),'2.jpg'),'jpg','Quality',100);
        %fits.closeFile(fptr);
        %close all;
    end
    disp([datapath_m,'�µ�',num2str(filetot),'�ļ��Ѵ������']);
    disp(['���гɹ�',num2str(filetot-errornum),'����ʧ��',num2str(errornum),'��']);
    numtot=numtot+filetot;
end
disp(['���ƴ���',num2str(numtot),'���ļ�']);