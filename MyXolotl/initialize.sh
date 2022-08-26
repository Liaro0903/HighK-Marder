#!/bin/bash

# Some scripts in this repository require scripts in MyXoltol to work, so this script will symbolically link these files to where they are supposed to be in the xolotl toolbox

printf "Enter the path of the xolotl toolbox\n(for example /home/ian/MATLAB Add-Ons/Toolboxes/xolotl): "
read xolotl_toolbox_path
last_character=${xolotl_toolbox_path: -1}
if [ "$last_character" = "/" ]; then # if have /, strip it because we will add it later
  xolotl_toolbox_path=${xolotl_toolbox_path%?}
fi

# Add prinz ion channels that can we can shift activation curve  
conductance_path='/c++/conductances'
conductance_prinzac_path="$xolotl_toolbox_path$conductance_path/prinz-ac"
if [ ! -d "$conductance_prinzac_path" ]; then
  mkdir "$conductance_prinzac_path"
fi
conductance_arr=('ACurrent.hpp' 'CaS.hpp' 'CaT.hpp' 'HCurrent.hpp' 'KCa.hpp' 'Kd.hpp' 'NaV.hpp')
for i in ${conductance_arr[@]}
do
  curr_path=$(pwd)"/"$i
  if [ ! -f "$conductance_prinzac_path/$i" ]; then 
    ln -s $curr_path "$conductance_prinzac_path"
  fi
done
printf "Prinz-ac conductances added to xolotl\n"

# Add chol and glut
synapse_path="$xolotl_toolbox_path/c++/synapses/prinz"
synapses_arr=('Cholinergic.hpp' 'Glutamatergic.hpp')
for i in ${synapses_arr[@]}
do
  curr_path=$(pwd)"/"$i
  if [ -f "$synapse_path/$i" ]; then
    rm "$synapse_path/$i"
    ln -s $curr_path "$synapse_path/$i"
  fi
done
printf "Prinz chol and glut synapses with able to change E added to xolotl\n"

# Add plots
xolotl_path="$xolotl_toolbox_path/@xolotl"
plot_arr=('myplot.m' 'myplot2.m')
for i in ${plot_arr[@]}
do
  curr_path=$(pwd)"/"$i
  if [ ! -f "$xolotl_path/$i" ]; then
    ln -s $curr_path "$xolotl_path/$i"
  fi
done
printf "myplot and myplot2 added to xolotl\n"

# Add V2metrics
xtools_path="$xolotl_toolbox_path/+xtools"
filename=V2metrics.m
curr_path=$(pwd)"/"$filename
if [ -f "$xtools_path/$filename" ]; then
  rm "$xtools_path/$filename"
  ln -s $curr_path "$xtools_path/$filename"
fi
printf "V2metrics.m added to xolotl\n"

printf "Intialization complete\n"