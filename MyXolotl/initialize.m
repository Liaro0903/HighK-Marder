clear; close all;

xolotl_toolbox_path = fileparts(fileparts(which('xolotl')));

filename = 'conductance.hpp';
curr_path = pwd;
file_path = strcat(curr_path, filesep, filename);
destination = strcat(xolotl_toolbox_path, filesep, 'c++', filesep, filename);

status = exist(destination, 'file');
if status == 2
  delete(destination);
end

commandStr = sprintf('ln -s "%s" "%s"', file_path, destination);

[status, cmdout] = system(commandStr);

