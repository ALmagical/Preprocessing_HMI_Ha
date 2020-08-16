clear variables;
close all;
path_hmi='C:\Users\11054\Desktop\hmi_20190704\hmi\';  %��ȡhmi�ļ���·��
path_ha='C:\Users\11054\Desktop\hmi_20190704\ha\jpg\';%����haͼ��·��
extname_m='*.jpg';
%��ȡ�ļ��б�
Direc_hmi=dir(strcat(path_hmi,extname_m));  %��strcat�������ַ�����������ʾ��ǰ·��Ŀ¼�µ��ļ����ļ���
Direc_ha=dir(strcat(path_ha,extname_m));
filenum_hmi=length(Direc_hmi);
filenum_ha=length(Direc_ha);
if filenum_hmi ~=filenum_ha
    print("Haͼ��������HMIͼ��������ƥ��");
else
    for i=1:filenum_ha     
        hmi=imread(strcat(path_hmi,Direc_hmi(i).name));
        ha=imread(strcat(path_ha,Direc_ha(i).name));
        figure('name','HMI');
        imshow(hmi(:,:,1));
        f_ha=figure('name','Ha');
        imshow(ha);
        %��ȡͼ��������İ뾶
        [h_hmi,w_hmi]=size(hmi(:,:,1));
        [h_ha,w_ha]=size(ha);
        %
        gaus_kernel = fspecial('gaussian',[10,10],1);
        ha_filter = imfilter(ha,gaus_kernel,'replicate');
        %
        ha_ulc=Luminance_Correction(ha_filter);
        figure('name','���Ȳ����Ƚ���');
        imshow(ha_ulc);
         %�²���
        downsample_ratio=h_ha/512; %��ͼ����СΪ512��512
        ha_low=imresize(ha_ulc,[int16(h_ha/downsample_ratio),int16(w_ha/downsample_ratio)]);
        %��ֵ��
        ha_edge=imbinarize(ha_low);
        %ha_edge=edge(ha_bi,'Canny');
        figure();
        imshow(ha_edge);
        [h_haedge,w_haedge]=size(ha_edge);
        r_range=min(h_haedge,w_haedge);
        %Բ��ϣ���haͼ���е�������hmiͼ���е��������ŵ���ͬ��С
        [center,radius]=imfindcircles(ha_edge,[int16(r_range*0.2),r_range],'Method','TwoStage','Sensitivity',0.9);%TwoStageָ����Ϸ���Ϊ����任
        center=center*downsample_ratio;
        radius=radius*downsample_ratio;
        %����ͼ��ߴ�ʹ����һ��
        if h_hmi>h_ha
            hmi=imresize(hmi,[h_ha,w_hmi]);
        elseif h_hmi<h_ha
                ha=imresize(ha,[h_hmi,w_ha]);
        end
        [h_hmi,w_hmi]=size(hmi(:,:,1));
        [h_ha,w_ha]=size(ha);
        if w_hmi>w_ha
            hmi=imresize(hmi,[h_hmi,w_ha]);
        elseif w_hmi<w_ha
                ha=imresize(ha,[h_ha,w_hmi]);
        end
       
        figure(f_ha);
        viscircles(center,radius,'EdgeColor','r')
    end
end