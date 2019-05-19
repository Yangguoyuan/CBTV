clc;
clear;

%{
Created on Sun Aug 2018

@author: Guoyuan Yang

Calculate brain template mean deformation value (mDV). Under the mask of brain ICV.
%}

pku_path_adult='/guoyuan_data/make_template_hcp/test_template_stability/result_so_1000';
mask_path='/guoyuan_data/make_template_hcp/US_template_new/';
num_sub_adult=[20 40 60 80 100 150 200 250 300 350 400];      % Add all the template number that should be calculate the mDV
mDV=[];
for i=1:length(num_sub_adult)
    sub_path=fullfile(pku_path_adult,['sub_ba',num2str(num_sub_adult(i)),'1Warp.nii.gz']);
    mask_path=fullfile(mask_path,['US200_brain_mask.nii']);
    mri_data=MRIread(sub_path);
    mask_data=MRIread(mask_path);
    data1=mri_data.vol(:,:,:,1);
    data2=mri_data.vol(:,:,:,2);
    data3=mri_data.vol(:,:,:,3);
    mean_data1=sum(sum(sum(abs(data1.*mask_data.vol))));
    mean_data2=sum(sum(sum(abs(data2.*mask_data.vol))));
    mean_data3=sum(sum(sum(abs(data3.*mask_data.vol))));
    mean_data=sum(sum(sum(abs(mask_data.vol))));
    mDV_sub=(mean_data1+mean_data2+mean_data3)/mean_data4;
    mDV(end+1)=mDV_sub;
end
    
