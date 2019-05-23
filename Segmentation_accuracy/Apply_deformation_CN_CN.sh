#!/bin/bash

#Created on Sun Aug 2018

#@author: Guoyuan Yang

#Native space's tissue maps were warped onto brain templates using the corresponding deformation fields obtained through SyN nonlinear registration between individual T1 image and brain template. Then we obtained a template tissue probability map through averaging all subjects' individual registered tissue probability maps.

data_path='/guoyuan_data/make_template/sgementation_test/result_CN/CN_individual';
dest_path='/guoyuan_data/make_template/sgementation_test/result_CN/CN_warp_ch';
ref_path='/guoyuan_data/make_template/sgementation_test/template/CN';
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
     for tissue in csf gm wm; do
     {
      exist=/guoyuan_data/make_template/sgementation_test/result_ch/ch_ch_pro/${tissue}/${tissue}${sub%%_*}.nii
       #exist=${dest_path}/${sub%%_*}1Warp.nii.gz;
     if [ ! -f "${exist}" ]
     then
      {
     dest_path1=/guoyuan_data/make_template/sgementation_test/result_ch/ch_ch_pro/${tissue};
     echo "=================exist=${exist}=============================="
     #echo "---------------data path=${sub_path}-------------------"
     antsApplyTransforms -d 3 -i ${ref_path}/${tissue}_pro_avg.nii -o ${dest_path1}/${tissue}${sub%%_*}.nii -r ${sub_path} -t ${dest_path}/${sub%%_*}1Warp.nii.gz -t ${dest_path}/${sub%%_*}0GenericAffine.mat 
      }
     fi
     }
     done
   }
   fi
} 
done

    
    
