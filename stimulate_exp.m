function [ success ] = stimulate_exp(isi, random, trials, isInRandMode, songbird_directory, GuiHandle, a)

if ~exist('path_to_intan_data_folder', 'var')
    path_to_intan_data_folder = uigetdir('..', 'path to intan data folder'); % one level up
    
    % we are going to make the name match the automatic timestamp as intan
    textfile = fullfile(path_to_intan_data_folder, strcat(datestr(now, 'yymmdd_HHMMSS'), 'markers.txt'));
end

ps = findobj(GuiHandle, 'Tag', 'pS'); % progress string
ets = findobj(GuiHandle, 'Tag', 'elapsedTimeString');
fid = fopen(textfile, 'wt'); % for dowrite    

%% Stimulate acoustically, send data via arduino to the intan board for duration of song.

songs = dir(fullfile(songbird_directory, '*.wav')); % should already be sorted by insertion
a.writeDigitalPin('D5', 1);% Intan analog input 7, digital 5, triggers.
pause(1); % because intan likes to wait for one second latency.
try
    if isInRandMode
        for elem = 1:str2num(trials)
            xi = randperm(numel(songs));
            songs = songs(xi);%.name; % alternatuvely had it as shuffled
            for song = 1:numel(songs)
                updatecount(elem, trials, songs, ets, ps)
                playprot(songs, song, a)
            end
        end
    else
        for song = 1:numel(songs) % Habituation protocol
            for elem = 1:str2num(trials)
                updatecount(elem, trials, songs, ets, ps)
                playprot(songs, song, a)
            end
        end
    end
catch ME
    close('all')
    fprintf('\nterminated\n')
    success = 0;
    clear all
    return;
end

%% helper functions
% note: elem is a number
    function updatecount(elem, trials, songs, ets, ps)
        % elapsed time string
        set(ets, 'String', strcat('elapsed time: ', num2str(toc)));
        % progress string
        set(ps, 'String', strcat(num2str(elem), 'of', num2str(str2double(trials)*numel(songs))));
    end
    function playprot(songs, song, a)
        % load file, set filename
        songfile=strcat(songs(song).folder, '\', songs(song).name);
        [Y, Fs]=audioread(songfile);
        player = audioplayer(Y, Fs);
        
        % play
        a.writeDigitalPin('D6', 1) % Arduino on for duration of playback
        tic % start counting
        playblocking(player) % so that it doesn't all play at once
        a.writeDigitalPin('D6', 0) % Once playback done, Arduino off
        dowrite(fid) % note down in our textfile what stim that was
        % cleanup
        clear Y Fs player
        
        % pause
        pausetime = str2double(isi)+rand*str2double(random) - toc; % This fixes a bug where I didn't account for length of song
        pause(pausetime) % isi plus or minus rand [0,1] times random
    end
    function dowrite(fid)
        fprintf(fid, '%s\n', 'L');
    end

%% cleaning up
fclose(fid);
clear all
fprintf('\ndone')
success = 1;
return;
end