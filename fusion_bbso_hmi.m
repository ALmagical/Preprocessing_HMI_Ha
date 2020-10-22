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
maindir_mdi='D:\Dataset\Filament_test2\MDI\';
maindir_save='D:\Dataset\Filament_test2\OUT\';
subdir_ha=dir(maindir_ha);
subdir_mdi=dir(maindir_mdi);
numtot=0;  %��¼������ļ���
extname='*.jpg'; 
dirnum_ha=length(subdir_ha);
dirnum_mdi=length(subdir_mdi);
downsample_size=256;     %��������뾶ʱ�Ľ�ͼ����С���ĸ߶ȴ�С
i=0;
j=0;
while((0<=i) && (i<dirnum_ha) && (j>=0) && (j<dirnum_mdi))
    i=i+1;
    j=j+1;
    num_finish=0;
    if( isequal( subdir_ha( i ).name, '.' )||...
        isequal( subdir_ha( i ).name, '..')||...
        ~subdir_ha( i ).isdir)               % �������Ŀ¼������
        continue;
    end

    if( isequal( subdir_mdi( j ).name, '.' )||...
        isequal( subdir_mdi( j ).name, '..')||...
        ~subdir_mdi( j ).isdir)               % �������Ŀ¼������
        continue;
    end
    %�ж��ļ��������Ƿ�ƥ��
    if ((i<=dirnum_ha) && (j<=dirnum_mdi))
        false=0;
        %�ļ���������ʽʾ����20101014-16
        while subdir_ha(i).name ~= subdir_mdi(j).name
            name_ha=subdir_ha(i).name(1:8);
            name_mdi=subdir_mdi(j).name(1:8);
            if str2double(name_ha)<str2double(name_mdi)
                i=i+1;
            elseif str2double(name_ha)>str2double(name_mdi)
                j=j+1;
            else
                disp(['�ļ������Ʋ�ƥ��',',Ha�ļ�������Ϊ:',subdir_ha(i)...
                    ,'MDI�ļ�������Ϊ:',subdir_mdi(j)],'�������ļ������ƣ�');
                false=1;
            end
        end
        if (false==1)
            continue;
        end
        datapath_ha=strcat(maindir_ha,subdir_ha(i).name,'\');  %��ȡHa�ļ���·��
        datapath_mdi=strcat(maindir_mdi,subdir_mdi(i).name,'\');%��ȡMDI�ļ���·��
        path_save=strcat(maindir_save,subdir_ha(i).name,'\');    %�����ļ���·��  

        %dir�������ָ���ļ����µ��������ļ��к��ļ�,���������һ��Ϊ�ļ��ṹ��������.
        direc_ha=dir(strcat(datapath_ha,extname));  %��ʾ��ǰ·��Ŀ¼�µ��ļ����ļ���
        direc_mdi=dir(strcat(datapath_mdi,extname));  
        filenum_ha=length(direc_ha);
        filenum_mdi=length(direc_mdi);
        %�ļ���Ϊ�������
        if filenum_ha==0
            disp(['��',datapath_ha,'����Ϊ���ļ��С�']);
            j=j-1;       %����mdi�ļ��б��ֲ���
            continue;
        end
        if filenum_mdi==0
            disp(['��',datapath_mdi,'����Ϊ���ļ��С�']);
            i=i-1;
            continue;
        end
        %�洢·�����ļ��в�����ʱ�����ļ���
        if ~exist(path_save,'dir')
            mkdir(path_save);
        end

        if filenum_ha~=filenum_mdi
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
                mdi=imread(strcat(datapath_mdi,direc_mdi(k).name));
                file_save=strcat(path_save,direc_ha(k).name(1:length(direc_ha(k).name)-4),'_fusion.jpg');
                if exist(file_save,'file')
                    continue;
                end
                 %��ȡͼ��������İ뾶
                [h_ha,w_ha]=size(ha);
                [h_mdi,w_mdi,channal]=size(mdi);
                %����ɫ��MDIͼ��תΪ�Ҷ�ͼ
                if channal ~= 1
                    mdi=rgb2gray(mdi);
                end
                %����ͼ��ߴ�ʹ����һ��
                if h_mdi>h_ha
                    mdi=imresize(mdi,[h_ha,w_mdi]);
                elseif h_mdi<h_ha
                    ha=imresize(ha,[h_mdi,w_ha]);
                end
                [h_mdi,w_mdi]=size(mdi);
                [h_ha,w_ha]=size(ha);
                if w_mdi>w_ha
                    mdi=imresize(mdi,[h_mdi,w_ha]);
                elseif w_mdi<w_ha
                    ha=imresize(ha,[h_ha,w_mdi]);
                end
                %figure('name','Ha');
                %imshow(ha);
                %figure('name','MDI');
                %imshow(mdi);
                %����ͼ��ߴ�
                [h_ha,w_ha]=size(ha);
                [h_mdi,w_mdi]=size(mdi);
                [center_ha,radius_ha]=my_circlefit(ha,downsample_size,h_ha,w_ha);
                [center_mdi,radius_mdi]=my_circlefit(mdi,downsample_size,h_mdi,w_mdi);

                if isempty(center_ha)==0 && isempty(center_mdi)==0
                    %���ԭͼ������İ뾶
                    downsample_ha_ratio=h_ha/downsample_size;
                    downsample_mdi_ratio=h_mdi/downsample_size;
                    center_ha=center_ha*downsample_ha_ratio;
                    radius_ha=radius_ha*downsample_ha_ratio;
                    center_mdi=center_mdi*downsample_mdi_ratio;
                    radius_mdi=radius_mdi*downsample_mdi_ratio;
                    disp(['Haͼ����������������Ϊ(',num2str(center_ha(1)),',',num2str(center_ha(2)),'),����뾶Ϊ',num2str(radius_ha)]);
                    disp(['MDIͼ����������������Ϊ(',num2str(center_mdi(1)),',',num2str(center_mdi(2)),'),����뾶Ϊ',num2str(radius_mdi)]);
                    %�����������������������
                    dy_ha=round((h_ha)/2-center_ha(1));
                    dx_ha=round((w_ha)/2-center_ha(2));
                    ha=circshift(ha,[dy_ha,dx_ha]);
                    dy_mdi=round((h_mdi)/2-center_mdi(1));
                    dx_mdi=round((w_mdi)/2-center_mdi(2));
                    mdi=circshift(mdi,[dy_mdi,dx_mdi]);
                    %figure('name','ƽ�ƽ��');
                    %subplot(1,2,1);
                    %imshow(ha);
                    %subplot(1,2,2);
                    %imshow(mdi);
                    %��Haͼ���MDIͼ��������ţ�ʹ����ͼ��������뾶��ͬ������������λ�ڻ�������
                    r=radius_ha;
                    if radius_mdi > radius_ha
                        %����im_adjust�Ĺ��ܺ��÷��μ�������˵��
                        ha=im_adjust(mdi,ha,radius_mdi,radius_ha);
                        r=radius_mdi;
                    elseif radius_mdi < radius_ha
                        mdi=im_adjust(ha,mdi,radius_ha,radius_mdi);
                        r=radius_ha;
                    end
                    %figure('name','������ͼƬ');
                    %subplot(1,2,1);
                    %imshow(ha);
                    %subplot(1,2,2);
                    %imshow(mdi);
                    [ha_ulc,max_ha]=removelimb2(ha,r);
                    [mdi_ulc,max_mdi]=removelimb2(mdi,r);
                     %��ֵ�����ڻ�ȡ��ͼ�е���������͸�������
                    threshold_neg=0.7;
                    threshold_pos=1.3;
                    im_fusion2(ha_ulc,mdi_ulc,file_save,max_ha,r,threshold_neg,threshold_pos);
                    numtot=numtot+1;
                    disp(['��',num2str(numtot),'��ͼƬ������ʱ�䣺',num2str(toc),'s']);
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