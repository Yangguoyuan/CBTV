#!/bin/bash
data_path=/guoyuan_data/make_template_hcp/MNI_Brodmann/DV_between_temp/a_direct_CN_US/template;
result=/guoyuan_data/make_template_hcp/MNI_Brodmann/DV_between_temp/a_direct_CN_US/result
cd ${result}
antsRegistrationSyN.sh -d 3 -t sr -f ${data_path}/rCN200.nii -m ${data_path}/rUS200.nii -o regist_us_cn &
antsRegistrationSyN.sh -d 3 -t sr -f ${data_path}/rUS200.nii -m ${data_path}/rCN200.nii -o regist_cn_us &
