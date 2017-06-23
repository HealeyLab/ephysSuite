function [ success ] = stimulate_exp(isi, random, trials, isInRandMode, songbird_directory, GuiHandle, a)
if ~exist('path_to_intan_data_folder', 'var')
    path_to_intan_data_folder = uigetdir('..'); % one level up
    textfile = fullfile(path_to_intan_data_folder, strcat(datestr(now, 'mmddyyyyHHSS'), 'markers.txt'));
end
ps = findobj(GuiHandle, 'Tag', 'pS'); % progress stirng
ets = findobj(GuiHandle, 'Tag', 'elapsedTimeString');
fid = fopen(textfile, 'wt'); % for dowrite    

%% Stimulate the bird acoustically, send data via arduino to the intan board for duration of song.

songs = dir(fullfile(songbird_directory, '*.wav')); % should already be sorted by insertion

a.writeDigitalPin('D5', 1);% Intan analog input 7, digital 5, triggers.
pause(1); % because intan likes to wait for one second latency.

if isInRandMode
    for elem = 1:str2num(trials)
        xi = randperm(numel(songs));
        songs = songs(xi);%.name; % alternatuvely had it as shuffled
        for song = 1:numel(songs)
            playprot
            updatecount
        end
    end
else
    for song = 1:numel(songs) % Habituation protocol
       for elem = 1:str2num(trials)
           playprot
           updatecount
       end
    end
end
    counter = 0;
    function updatecount
        % elapsed time string
        set(ets, 'String', strcat('elapsed time: ', num2str(toc)));
        counter = counter + 1;
        % progress stirng
        set(ps, 'String', strcat('Of ', num2str(trials*numel(songs)), ' trials, trials done: ', num2str(counter)));
    end
    function playprot
        %% load file, set filename
        songfile=strcat(songs(song).folder, '\', songs(song).name);
        [Y, Fs]=audioread(songfile);
        player = audioplayer(Y, Fs);
        
        %% play
        a.writeDigitalPin('D6', 1) % Arduino on for duration of playback
        tic % start counting
        playblocking(player) % so that it doesn't all play at once
        a.writeDigitalPin('D6', 0) % Once playback done, Arduino off
        dowrite % note down in our textfile what stim that was
        %% cleanup
        clear Y Fs player
        
        %% pause
        pausetime = str2double(isi)+rand*str2double(random) - toc; % This fixes a bug where I didn't account for length of song
        pause(pausetime) % isi plus or minus rand [0,1] times random
    end
    function dowrite
        fprintf(fid, '%s\n', 'L');
    end
fclose(fid);
clear all
fprintf('\ndone')

success = 1;
return;
end