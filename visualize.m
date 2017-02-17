function[] = visualize()
path_to_intan_data_folder = uigetdir('..'); % one level up
s = dir(strcat(path_to_intan_data_folder, '/*.rhd'));

for index = 1:length(s) % iterates through all *.rhd values in intan data folder
    toread = fullfile(s(index).folder, s(index).name);
    
    % convert each .rhd to a spike2 file
    doscommand = ['convert_to_Spike2', ' ',toread,' ',toread(1:end-4), '.smr'];
    dos(doscommand); % output will be foobar.rhd.smr
    
    % visualizing
%     [amp, aux_input, params, notes, ~, ...
%         adc, ~, ~, ~, status]...
%         =read_intan_data_cli_rhd2000(strcat(toread.folder, '/', toread.name));
%     figure;plot(adc.t(1,:), adc.data(1,:))
end
return