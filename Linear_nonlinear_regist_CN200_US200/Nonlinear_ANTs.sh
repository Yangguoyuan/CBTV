#!/bin/bash

#Created on Sun Aug 2018

#@author: Guoyuan Yang

#Using ANTs SyN algorithm function to nonlinear registrated individual brain into templates.

data_path='/guoyuan_data/make_template_child/for_compare_new/cn_individual';
tem_path='/guoyuan_data/make_template_child/for_compare_new/cn_individual/result_cntocn/nonlinear';
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
     antsRegistrationSyN.sh -d 3 -t s -f ${ref_path}/CN200.nii -m ${sub_path} -o ${sub%%_*}
   }
   fi
}&
done

    
    
