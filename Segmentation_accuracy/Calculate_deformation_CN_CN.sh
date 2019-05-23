#!/bin/bash

#Created on Sun Aug 2018

#@author: Guoyuan Yang

#Calculate deformation fields through SyN nonlinear registration between individual T1 image and brain template.

data_path='/guoyuan_data/make_template/sgementation_test/result_ch/ch_individual';
dest_path='/guoyuan_data/make_template/sgementation_test/result_ch/CN_warp_ch';
ref_path='/guoyuan_data/make_template/sgementation_test/template/cn';
cd ${dest_path}
filelist=$(ls $data_path)
for sub in ${filelist}
do
{
 sub_name=${sub};
 sub_path=${data_path}/${sub_name}
   if [ -f "${sub_path}" ]
   then
   { 
     exist=${dest_path}/${sub%%_*}Warped.nii.gz
     if [ ! -f "${exist}" ]
     then
     {
     echo "---------------data path=${sub_path}-------------------"
     antsRegistrationSyN.sh -d 3 -t s -f ${sub_path} -m ${ref_path}/rCN200.nii -o ${sub%%_*}
     }
     fi
   }
   fi
}&
done

    
    
