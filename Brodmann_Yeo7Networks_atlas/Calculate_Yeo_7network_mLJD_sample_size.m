clc;clear;

%{
Created on Sun Aug 2018

@author: Guoyuan Yang

Calculate the deformation_value in Yeo 7 networks areas
%}

deform_path='/guoyuan_data/make_template_hcp/MNI_Brodmann/transform/Jacobian_map/reslice_jacobian';
num_sub_adult=[20 40 60 80 100 150 200 250 300 350 400];

Yeo=fullfile('/guoyuan_data/make_template_hcp/MNI_Brodmann/Yeo_7network/Yeo_7network/Yeo_JNeurophysiol11_MNI152','rYeo2011_7Networks_MNI152_FreeSurferConformed1mm.nii');
data=ones(length(num_sub_adult),7);
for i=1:length(num_sub_adult)
    sub_num=fullfile(deform_path,['sub_ba_log_jacobian_',num2str(num_sub_adult(i)),'_reslice.nii']);
    sub_matrix=MRIread(sub_num);
    for j=1:7
        Yeo_new=fullfile('/guoyuan_data/make_template_hcp/MNI_Brodmann/Yeo_7network/Yeo_7network/Yeo_7network_mask',['Yeo_area',num2str(j,'%03d'),'.nii']);
        Yeo_matrix=MRIread(Yeo);
        Yeo_matrix=Yeo_matrix.vol;
        Yeo_matrix(Yeo_matrix~=j)=0;
        Yeo_matrix(Yeo_matrix==j)=1;
        Yeo_matrix.vol=Yeo_matrix;
        MRIwrite(Yeo_matrix,Yeo_new);
        data(i,j)=sum(sum(sum((sub_matrix.vol).*Yeo_matrix)))/sum(sum(sum(Yeo_matrix)));
    end
end
        
