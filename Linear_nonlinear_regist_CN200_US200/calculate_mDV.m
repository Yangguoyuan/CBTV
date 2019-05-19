%{
Created on Sun Aug 2018

@author: Guoyuan Yang

Calculate the mean deformation_value in image registrations to the Caucasian and Chinese templates
%}

clc;
clear;
data_num='/guoyuan_data/make_template_child/Richard_template/for_compare_new/data_num';
file_path='/guoyuan_data/make_template_child/Richard_template/for_compare_new/ch_individual/result_chtoch/def';
mask_path='/guoyuan_data/make_template_hcp/US_template_new';
dataname1='chcp_num.txt';
filename=fullfile(data_num,dataname1);
fid = fopen(filename);
C = textscan(fid,repmat('%s',1,1),'Headerlines',0);
fclose(fid);
mDV=[];
mask_us_path1=fullfile(mask_path,'US200_brain_mask.nii');
mask_ch_path1=fullfile('/guoyuan_data/make_template/new_template/adult_t1/CN200_brain_mask.nii')
for i=1:50
    dataname=cell2mat(C{1,1}(i));
    sub_path=fullfile(file_path,[dataname,'1Warp.nii.gz']);
    if exist(sub_path,'file') 
       mri_data=MRIread(sub_path);
       mask_data4=MRIread(mask_ch_path1);
       data1=mri_data.vol(:,:,:,1);
       data2=mri_data.vol(:,:,:,2);
       data3=mri_data.vol(:,:,:,3);
       mean_data1=sum(sum(sum(abs(data1.*mask_data4.vol))));
       mean_data2=sum(sum(sum(abs(data2.*mask_data4.vol))));
       mean_data3=sum(sum(sum(abs(data3.*mask_data4.vol))));
       mean_data4=sum(sum(sum(abs(mask_data4.vol))));
       mean_data=(mean_data1+mean_data2+mean_data3)/mean_data4;
       mDV(end+1)=mean_data;
    end
end
    
