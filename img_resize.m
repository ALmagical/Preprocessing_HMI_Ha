%%%
%��ʱ���Ϊ60s��HAͼ���MDIͼ�������׼
%��׼������ӦͼƬ��̫��Բ������ĵ���Ϊ�������ģ���ʹͼƬ������İ뾶����ͬ
%����׼���HAͼ���HMIͼ����е���   �������Ժ󽫳���������
%ĿǰĬ�ϱ���Haͼ���MDIͼ����ļ������ļ�˳���ܹ���Ӧ��
%����ͬ(���)���ڵ�Ha��MDIͼƬ���ļ����е�λ������ͬ��
% ver:0.1.0 
% 2020.08.16
%%%
clear variables;
close all;
%��ʱ
tic;
t1=clock;
path_ha='C:\Users\11054\Desktop\hmi_20190704\ha\jpg\';%����haͼ��·��
path_mdi='C:\Users\11054\Desktop\hmi_20190704\hmi\';%HMIͼƬ·��
path_save='C:\Users\11054\Desktop\hmi_20190704\out\';%�洢���
extname_m='*.jpg';
%��ȡ�ļ��б�
%��strcat�������ַ�����������ʾ��ǰ·��Ŀ¼�µ��ļ����ļ���
Direc_ha=dir(strcat(path_ha,extname_m));
Direc_mdi=dir(strcat(path_mdi,extname_m));
filenum_ha=length(Direc_ha);
filenum_hmi=length(Direc_mdi);
if filenum_ha~=filenum_hmi
    disp('Haͼ���MDIͼ��������ƥ��');
else
    %�������˹�ṹԪ�����ں�����ͼ���ϻ��Ʊ߿�
    unitsize=9;  %�ṹԪ�ߴ�
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
        tic;
        t2=clock;
        ha=imread(strcat(path_ha,Direc_ha(i).name));
        mdi=imread(strcat(path_mdi,Direc_mdi(i).name));
        %����ɫ��MDIͼ��תΪ�Ҷ�ͼ
        mdi=rgb2gray(mdi);
        %��ȡͼ��������İ뾶
        [h_ha,w_ha]=size(ha);
        [h_mdi,w_mdi]=size(mdi);
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
        figure('name','Ha');
        imshow(ha);
        figure('name','MDI');
        imshow(mdi);
        %����ͼ��ߴ�
        [h_ha,w_ha]=size(ha);
        [h_mdi,w_mdi]=size(mdi);
        %���Խ��ⲿ�ָ�Ϊfunction
        gaus_kernel = fspecial('gaussian',[10,10],1);
        ha_filter = imfilter(ha,gaus_kernel,'replicate');
        mdi_filter = imfilter(mdi,gaus_kernel,'replicate');
        %�Ƴ�Haͼ����ٱ߻谵
        [ha_ulc,~]=removelimb(ha_filter);
        %figure();
        %imshow(ha_ulc);
        %�²���
        downsample_ha_ratio=h_ha/256; %��ͼ����СΪ256��256
        downsample_mdi_ratio=h_mdi/256;
        ha_low=imresize(ha_ulc,[int16(h_ha/downsample_ha_ratio),int16(w_ha/downsample_ha_ratio)]);
        mdi_low=imresize(mdi_filter,[int16(h_mdi/downsample_mdi_ratio),int16(w_mdi/downsample_mdi_ratio)]);
        %��ֵ��
        ha_edge=imbinarize(ha_low);
        mdi_edge=imbinarize(mdi_low);
        [h_edge_ha,w_edge_ha]=size(ha_edge);
        [h_edge_mdi,w_edge_mdi]=size(ha_edge);
        r_range_ha=min(h_edge_ha,w_edge_ha);
        r_range_mdi=min(h_edge_mdi,w_edge_mdi);
        %Բ��ϣ���haͼ���е�������hmiͼ���е��������ŵ���ͬ��С
        [center_ha,radius_ha]=imfindcircles(ha_edge,[int16(r_range_ha*0.2),r_range_ha],'Method','TwoStage','Sensitivity',0.9);%TwoStageָ����Ϸ���Ϊ����任
        [center_mdi,radius_mdi]=imfindcircles(mdi_edge,[int16(r_range_mdi*0.2),r_range_mdi],'Method','TwoStage','Sensitivity',0.9);
        
        if size(center_ha)~=0
            %���ԭͼ������İ뾶
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
       
            %��Haͼ��������ţ�ʹ������뾶��MDIͼ���е�������ͬ
            %�ĳ�function �Ա�Ӧ��Ҫ����MDIͼ������
            radius_ratio=radius_mdi/radius_ha;
            if radius_ratio~=1  %������Ϊ1ʱ���е�����Ϊ1�Ļ��������κβ���
                ha=imresize(ha,radius_ratio);
                if radius_ratio>1
                    x_min=h_ha*abs(radius_ratio-1)/2;
                    y_min=w_ha*abs(radius_ratio-1)/2;
                    ha=imcrop(ha,[x_min,y_min,w_mdi,h_mdi]); %imcrop�����ĸ�����Ϊx��y����Сֵ�Լ�ͼ��Ŀ�Ⱥ͸߶�
                end
            end
            figure();
            imshow(ha);
            figure();
            imshow(mdi);
            R=ha_ulc;
            G=ha_ulc;
            B=ha_ulc;
            theta=0:0.001:2*pi+0.1;
            Circle1=center_ha(1)+radius_ha*cos(theta);
            Circle2=center_ha(2)+radius_ha*sin(theta);
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
            %imshow(result);
            imwrite(result,strcat(path_save,Direc_ha(i).name(1:length(Direc_ha(i).name)-4),'.jpg'),'jpg','Quality',100);
            %plot(Circle1,Circle2,'r');
            %axis equal
            %viscircles(center,radius,'EdgeColor','r');
            %set(gcf, 'PaperPositionMode', 'manual');
            %set(gcf, 'PaperUnits', 'points');
            %set(gcf, 'PaperPosition', [0 0 h_ha w_ha]);
            %print(gcf,'-dpng',strcat(path_save,Direc_ha(i).name));
            disp(['��',num2str(i),'��ͼƬ������ʱ�䣺',num2str(toc),'s']);
        end
    end
end
disp(['����������ʱ�䣺',num2str(etime(clock,t1)),'s']);