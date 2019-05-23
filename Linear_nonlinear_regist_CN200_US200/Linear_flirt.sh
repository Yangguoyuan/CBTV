#!/bin/bash

#Created on Sun Aug 2018

#@author: Guoyuan Yang

#Using FSL flirt function to linear registrated individual brain into templates.

data_path='/guoyuan_data/make_template_child/for_compare_new/cn_individual';
tem_path='/guoyuan_data/make_template_child/for_compare_new/cn_individual/result_cntocn/flirt';
ref_path='/guoyuan_data/make_template_child/for_compare_new';
cd ${tem_path}
filelist=$(ls $data_path)
for sub in ${filelist}
do
{
 sub_name=${sub};
 sub_path=${data_path}/${sub_name}
   if [ -f "${sub_path}" ]
   then
   {
     echo "---------------data path=${sub_path}-------------------"
    flirt -in ${sub_path} -ref ${ref_path}/CN200.nii -out ${sub%%_*} -omat ${sub%%_*}.mat -dof 12
    nohup avscale ${sub%%_*}.mat
   }
   fi
}&
done

    
    
