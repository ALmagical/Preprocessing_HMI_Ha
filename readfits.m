clear all; 
close all;

datapath_m='C:\Users\11054\Desktop\hmi_20190704\mdi\';  %��ȡfits�ļ���·��
magneticjpg='C:\Users\11054\Desktop\hmi_20190704\mdi\';%����fitsͼ��·��
extname_m='*.fits';
Direc_m=dir(strcat(datapath_m,extname_m));  %��strcat�������ַ�����������ʾ��ǰ·��Ŀ¼�µ��ļ����ļ���
%dir�������ָ���ļ����µ��������ļ��к��ļ�,���������һ��Ϊ�ļ��ṹ��������.
filetot=length(Direc_m);
for Num=1:1
    file_m=strcat(datapath_m,Direc_m(Num).name);
    im_fits_m=fitsread(file_m,'image'); 
    im_fits_m = uint8((double(im_fits_m)+500)/(500+500)*255);
    im_fits_m=fliplr(im_fits_m);     % fliplr( )�������ҷ�ת����
    figure,imshow(im_fits_m,[]);%title('��ͼԭͼ');      
    print(gcf,'-dpng',strcat(magneticjpg,Direc_m(Num).name,'.jpg'));        % �����ͼͼƬ
   
    close all;
end 
