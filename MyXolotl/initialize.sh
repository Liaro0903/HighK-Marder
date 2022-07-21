#!/bin/bash

# More initialization will be added. So far it adds the conductances c++ files that have the shifting activation curve property

printf "Enter the path of the xolotl toolbox: "
read xolotl_toolbox_path
# xolotl_toolbox_path='/home/ian/MATLAB Add-Ons/Toolboxes/xolotl'

# Add conductances
conductance_path='/c++/conductances'
conductance_prinzac_path="$xolotl_toolbox_path$conductance_path/prinz-ac"
if [ ! -d "$conductance_prinzac_path" ]; then
  mkdir "$conductance_prinzac_path"
fi
conductance_arr=('ACurrent.hpp' 'CaS.hpp' 'CaT.hpp' 'HCurrent.hpp' 'KCa.hpp' 'Kd.hpp' 'NaV.hpp')
for i in ${conductance_arr[@]}
do
  curr_path=$(pwd)"/"$i
  if [ ! -f "$conductance_prinzac_path$ACurrent" ]; then 
    ln -s $curr_path "$conductance_prinzac_path"
  fi
done
printf "Prinz-ac conductances added to xolotl\n"

printf "Intialization complete\n"