clc;
clear;

%{
Created on Tue May  2019

@author: Guoyuan Yang

Calculate brain template mean deformation value (mDV). Under the mask of brain ICV.
%}

chcp_path_adult='/guoyuan_data/make_template_hcp/test_template_stability/result_so_1000/Jacobian_file/Jacobian_data/chcp';
hcp_path_adult='/guoyuan_data/make_template_hcp/test_template_stability/result_so_1000/Jacobian_file/Jacobian_data/hcp';
num_sub_adult=[20 40 60 80 100 150 200 250 300 350 400];

sub_path_mask_ch=fullfile('/guoyuan_data/make_template/test_template_stability_chinese/template/data/mask_CN200/CN200_mask.nii');
sub_path_mask_us=fullfile('/guoyuan_data/make_template_hcp/US_template_new/US200_brain_mask.nii');
mLJD=[];
for i=1:length(num_sub_adult)
    pku_sub_path=fullfile(chcp_path_adult,['sub_ab_log_jacobian',num2str(num_sub_adult(i)),'.nii.gz']);
    hcp_sub_path=fullfile(hcp_path_adult,['sub_ba_log_jacobian',num2str(num_sub_adult(i)),'.nii.gz']);
    mri_data=MRIread(pku_sub_path);
    mask_data=MRIread(sub_path_mask_ch);
    data=mri_data.vol;
    mean_data=sum(sum(sum(abs(data.*mask_data.vol))));
    mean_mask_data=sum(sum(sum(abs(mask_data.vol))));
    mean_LJD=mean_data/mean_mask_data;
    mLJD(end+1)=mean_LJD;
end
    
