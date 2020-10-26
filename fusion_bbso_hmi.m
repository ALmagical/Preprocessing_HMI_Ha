%%%
%��ʱ���Ϊ60s��HAͼ���MDIͼ�������׼
%��׼������ӦͼƬ��̫��Բ������ĵ���Ϊ�������ģ���ʹͼƬ������İ뾶����ͬ
%����׼���HAͼ���HMIͼ����е��� 
%ĿǰĬ�ϱ���Haͼ���MDIͼ����ļ������ļ�˳���ܹ���Ӧ��
%����ͬ(���)���ڵ�Ha��MDIͼƬ���ļ����е�λ������ͬ��
%%%
clear variables;
close all;
import matlab.io.*
%��ʱ
tic;
t1=clock;
maindir_ha='D:\Dataset\Filament_test2\BBSO\';
maindir_hmi='D:\Dataset\Filament_test2\MDI\';
maindir_save_fusion='D:\Dataset\Filament_test2\OUT\FUSION\';
maindir_save_ha='D:\Dataset\Filament_test2\OUT\Ha\';
maindir_save_hmi='D:\Dataset\Filament_test2\OUT\HMI\';
subdir_ha=dir(maindir_ha);
subdir_hmi=dir(maindir_hmi);
numtot=0;  %��¼�������ļ���
extname='*.jpg'; 
dirnum_ha=length(subdir_ha);
dirnum_hmi=length(subdir_hmi);
downsample_size=256;     %��������뾶ʱ�Ľ�ͼ����С���ĸ߶ȴ�С
i=0;
j=0;
while((0<=i) && (i<dirnum_ha) && (j>=0) && (j<dirnum_hmi))
    i=i+1;
    j=j+1;
    num_finish=0;
    if( isequal( subdir_ha( i ).name, '.' )||...
        isequal( subdir_ha( i ).name, '..')||...
        ~subdir_ha( i ).isdir)               % �������Ŀ¼������
        continue;
    end

    if( isequal( subdir_hmi( j ).name, '.' )||...
        isequal( subdir_hmi( j ).name, '..')||...
        ~subdir_hmi( j ).isdir)               % �������Ŀ¼������
        continue;
    end
    %�ж��ļ��������Ƿ�ƥ��
    if ((i<=dirnum_ha) && (j<=dirnum_hmi))
        false=0;
        %�ļ���������ʽʾ����20101014-16
        while subdir_ha(i).name ~= subdir_hmi(j).name
            name_ha=subdir_ha(i).name(1:8);
            name_hmi=subdir_hmi(j).name(1:8);
            if str2double(name_ha)<str2double(name_hmi)
                i=i+1;
            elseif str2double(name_ha)>str2double(name_hmi)
                j=j+1;
            else
                disp(['�ļ������Ʋ�ƥ��',',Ha�ļ�������Ϊ:',subdir_ha(i)...
                    ,'MDI�ļ�������Ϊ:',subdir_hmi(j)],'�������ļ������ƣ�');
                false=1;
            end
        end
        if (false==1)
            continue;
        end
        datapath_ha=strcat(maindir_ha,subdir_ha(i).name,'\');  %��ȡHa�ļ���·��
        datapath_hmi=strcat(maindir_hmi,subdir_hmi(i).name,'\');%��ȡMDI�ļ���·��
        %�����ļ���·��  
        path_save_fusion=strcat(maindir_save_fusion,subdir_ha(i).name,'\');
        path_save_ha=strcat(maindir_save_ha,subdir_ha(i).name,'\');
        path_save_hmi=strcat(maindir_save_hmi,subdir_hmi(i).name,'\');
        
        %dir�������ָ���ļ����µ��������ļ��к��ļ�,���������һ��Ϊ�ļ��ṹ��������.
        direc_ha=dir(strcat(datapath_ha,extname));  %��ʾ��ǰ·��Ŀ¼�µ��ļ����ļ���
        direc_hmi=dir(strcat(datapath_hmi,extname));  
        filenum_ha=length(direc_ha);
        filenum_hmi=length(direc_hmi);
        %�ļ���Ϊ�������
        if filenum_ha==0
            disp(['��',datapath_ha,'����Ϊ���ļ��С�']);
            j=j-1;       %����mdi�ļ��б��ֲ���
            continue;
        end
        if filenum_hmi==0
            disp(['��',datapath_hmi,'����Ϊ���ļ��С�']);
            i=i-1;
            continue;
        end
        %�洢·�����ļ��в�����ʱ�����ļ���
        if ~exist(path_save_fusion,'dir')
            mkdir(path_save_fusion);
        end
        if ~exist(path_save_ha,'dir')
            mkdir(path_save_ha);
        end
        if ~exist(path_save_hmi,'dir')
            mkdir(path_save_hmi);
        end
        if filenum_ha~=filenum_hmi
            disp('Haͼ���MDIͼ��������ƥ��');
            disp(['δ����',datapath_ha]);
        else
        %����
        %�������˹�ṹԪ�����ں�����ͼ���ϻ��Ʊ߿�
        %unit=cross_unit(5);

            for k=1:filenum_ha
                tic;
                t2=clock;
                ha=imread(strcat(datapath_ha,direc_ha(k).name));
                hmi=imread(strcat(datapath_hmi,direc_hmi(k).name));
                file_save_fusion=strcat(path_save_fusion,direc_ha(k).name(1:length(direc_ha(k).name)-4),'_fusion.jpg');
                file_save_ha=strcat(path_save_ha,direc_ha(k).name(1:length(direc_ha(k).name)-4),'.jpg');
                file_save_hmi=strcat(path_save_hmi,direc_hmi(k).name(1:length(direc_ha(k).name)-4),'.jpg');
                if exist(file_save_fusion,'file')
                    continue;
                end
                 %��ȡͼ��������İ뾶
                [h_ha,w_ha]=size(ha);
                [h_hmi,w_hmi,c_hmi]=size(hmi);
                %����ɫ��MDIͼ��תΪ�Ҷ�ͼ
                if c_hmi ~= 1
                    hmi=rgb2gray(hmi);
                end
                %����ͼ��ߴ�ʹ����һ��
                if h_hmi>h_ha
                    hmi=imresize(hmi,[h_ha,w_hmi]);
                elseif h_hmi<h_ha
                    ha=imresize(ha,[h_hmi,w_ha]);
                end
                [h_hmi,w_hmi]=size(hmi);
                [h_ha,w_ha]=size(ha);
                if w_hmi>w_ha
                    hmi=imresize(hmi,[h_hmi,w_ha]);
                elseif w_hmi<w_ha
                    ha=imresize(ha,[h_ha,w_hmi]);
                end
                %figure('name','Ha');
                %imshow(ha);
                %figure('name','MDI');
                %imshow(mdi);
                %����ͼ��ߴ�
                [h_ha,w_ha]=size(ha);
                [h_hmi,w_hmi]=size(hmi);
                [center_ha,radius_ha]=my_circlefit(ha,downsample_size,h_ha,w_ha);
                [center_hmi,radius_hmi]=my_circlefit(hmi,downsample_size,h_hmi,w_hmi);

                if isempty(center_ha)==0 && isempty(center_hmi)==0
                    %���ԭͼ������İ뾶
                    downsample_ha_ratio=h_ha/downsample_size;
                    downsample_mdi_ratio=h_hmi/downsample_size;
                    center_ha=center_ha*downsample_ha_ratio;
                    radius_ha=radius_ha*downsample_ha_ratio;
                    center_hmi=center_hmi*downsample_mdi_ratio;
                    radius_hmi=radius_hmi*downsample_mdi_ratio;
                    disp(['Haͼ����������������Ϊ(',num2str(center_ha(1)),',',num2str(center_ha(2)),'),����뾶Ϊ',num2str(radius_ha)]);
                    disp(['MDIͼ����������������Ϊ(',num2str(center_hmi(1)),',',num2str(center_hmi(2)),'),����뾶Ϊ',num2str(radius_hmi)]);
                    %�����������������������
                    dy_ha=round((h_ha)/2-center_ha(1));
                    dx_ha=round((w_ha)/2-center_ha(2));
                    ha=circshift(ha,[dy_ha,dx_ha]);
                    dy_hmi=round((h_hmi)/2-center_hmi(1));
                    dx_hmi=round((w_hmi)/2-center_hmi(2));
                    hmi=circshift(hmi,[dy_hmi,dx_hmi]);
                    %figure('name','ƽ�ƽ��');
                    %subplot(1,2,1);
                    %imshow(ha);
                    %subplot(1,2,2);
                    %imshow(mdi);
                    %��Haͼ���MDIͼ��������ţ�ʹ����ͼ��������뾶��ͬ������������λ�ڻ�������
                    r=radius_ha;
                    if radius_hmi > radius_ha
                        %����im_adjust�Ĺ��ܺ��÷��μ�������˵��
                        ha=im_adjust(hmi,ha,radius_hmi,radius_ha);
                        r=radius_hmi;
                    elseif radius_hmi < radius_ha
                        hmi=im_adjust(ha,hmi,radius_ha,radius_hmi);
                        r=radius_ha;
                    end
                    %figure('name','�������ͼƬ');
                    %subplot(1,2,1);
                    %imshow(ha);
                    %subplot(1,2,2);
                    %imshow(mdi);
                    [ha_ulc,max_ha]=removelimb2(ha,r);
                    [hmi_ulc,max_hmi]=removelimb2(hmi,r);
                     %��ֵ�����ڻ�ȡ��ͼ�е���������͸�������
                    threshold_neg=0.4;
                    threshold_pos=1.8;
                    ha_ulc=ha_ulc/max_ha;
                    hmi_ulc=hmi_ulc/max_hmi;
                    ha_ulc=im2uint8(ha_ulc);
                    hmi_ulc=im2uint8(hmi_ulc);
                    im_fusion2(ha_ulc,hmi_ulc,file_save_fusion,max_ha,r,threshold_neg,threshold_pos);
                    imwrite(ha_ulc,file_save_ha,'jpg','Quality',100);
                    imwrite(hmi_ulc,file_save_hmi,'jpg','Quality',100);
                    numtot=numtot+1;
                    disp(['��',num2str(numtot),'��ͼƬ��������ʱ�䣺',num2str(toc),'s']);
                end
            end
        end
    end
end
time=etime(clock,t1);
secs=mod(time,60);
mins=fix(time/60);
hours=fix(mins/60);
mins=mod(mins,60);
disp(['����������ʱ�䣺',num2str(hours),' h ',num2str(mins),' m ',num2str(secs),' s']);