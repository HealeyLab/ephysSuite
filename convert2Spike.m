function[] = convert2Spike()
path_to_intan_data_folder = uigetdir('..'); % one level up
s = dir(strcat(path_to_intan_data_folder, '/*.rhd'));
echo off;
for index = 1:length(s) % iterates through all *.rhd values in intan data folder
    toread = fullfile(s(index).folder, s(index).name);
    
    doscommand = ['convert_to_Spike2', ' ',toread,' ',toread(1:end-4), '.smr'];
    [~, ~] = dos(doscommand); % output will be foobar.rhd.smr

end
echo on;
return