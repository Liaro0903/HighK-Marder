% Initialize for scripts to work. Some scripts in this repository require scripts
% in MyXolotl to work, so this script will symbolically link these files to where 
% they are supposed to be in the xolotl toolbox

clear; close all;

warning('error', 'MATLAB:DELETE:FileNotFound'); % Turn warning to error to make try catch work

myxolotl_path = 'MyXolotl';
initialize_recursive(myxolotl_path);
disp('All files are symbolic linked. Initialization complete.');

function initialize_recursive(relative_path)
  xolotl_toolbox_path = fileparts(fileparts(which('xolotl')));

  abs_path = [pwd filesep relative_path];
  dir_data = dir(abs_path);
  dir_idx = [dir_data.isdir];  % Find indices for directories
  files = {dir_data(~dir_idx).name};  % List of files
  sub_dirs = {dir_data(dir_idx).name};  % List of subdirectories
  sub_dirs = sub_dirs(~ismember(sub_dirs, {'.', '..'})); % Get rid of . ..

  destination = [xolotl_toolbox_path strrep(relative_path, 'MyXolotl', '')]; % get rid of the 'MyXolotl' part in the relative path first

  if ~isfolder(destination) % if folder does not exist, create one
    mkdir(destination);
  end

  for file = 1:length(files) % go through each file
    if (~isequal(files{file}, '.DS_Store'))
      destination_file = [destination filesep files{file}];
      curr_file = [abs_path filesep files{file}];
      try
        delete(destination_file);
      catch
      end
      command_str = sprintf('ln -s "%s" "%s"', curr_file, destination_file);
      [status, cmdout] = system(command_str);
      if status ~= 0 % if command not successful
        warning('error', 'customwarning:lnerror');
        warning('customwarning:lnerror', cmdout);
      end
    end
  end

  for subdir = 1:length(sub_dirs) % go through each directory
    new_relative_path = [relative_path filesep sub_dirs{subdir}];
    initialize_recursive(new_relative_path);
  end
end