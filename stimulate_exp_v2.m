function [ success ] = stimulate_exp_v2(isi, random, trials, isInRandMode, songbird_directory, GuiHandle, my_s)

%% Arduino Constants
CHAN_8_HIGH = 8;
% CHAN_7_HIGH = 7;
CHAN_8_LOW = 6;
% CHAN_7_LOW = 5;
send_to_sketch = @(matlabval) fwrite(my_s, matlabval, 'uint8');
%%
counter = 0;

if ~exist('path_to_intan_data_folder', 'var')
    path_to_intan_data_folder = uigetdir('..', 'path to intan data folder'); % one level up
    
    % we are going to make the name match the automatic timestamp as intan
    textfile = fullfile(path_to_intan_data_folder, strcat(datestr(now, 'yymmdd_HHMMSS'), 'markers.txt'));
end

ps = findobj(GuiHandle, 'Tag', 'pS'); % progress stirng
ets = findobj(GuiHandle, 'Tag', 'elapsedTimeString');
fid = fopen(textfile, 'wt'); % for dowrite    

%% Stimulate the bird acoustically, send data via arduino to the intan board for duration of song.
songs = dir(fullfile(songbird_directory, '*.wav')); % should already be sorted by insertion
% TODO: is this line useful?
% send_to_sketch(CHAN_8_HIGH);
% TODO: verify this line's validity
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

    
    function updatecount
        % elapsed time string
        set(ets, 'String', strcat('elapsed time: ', num2str(toc)));
        counter = counter + 1;
        % progress stirng
        set(ps, 'String', strcat('Of ', num2str(trials*numel(songs)), ' trials, trials done: ', num2str(counter)));
    end

    %%
    function playprot
        % load file, set filename
        songfile=strcat(songs(song).folder, '\', songs(song).name);
        [Y, Fs]=audioread(songfile);
        player = audioplayer(Y, Fs);
        
        % play
        send_to_sketch(CHAN_8_HIGH); % Arduino on for duration of playback
        tic % start counting
        playblocking(player) % so that it doesn't all play at once
        send_to_sketch(CHAN_8_LOW); % Once playback done, Arduino off
        dowrite % note down in our textfile what stim that was
        % cleanup
        clear Y Fs player
        
        % pause
        pausetime = str2double(isi)+rand*str2double(random) - toc; % This fixes a bug where I didn't account for length of song
        pause(pausetime) % isi plus or minus rand [0,1] times random
    end

    %%
    function dowrite
        fprintf(fid, '%s\n', 'L');
    end
%%
fclose(fid);
fprintf('\ndone')
fclose(my_s); % end communication with arduino

success = 1;
return;

end