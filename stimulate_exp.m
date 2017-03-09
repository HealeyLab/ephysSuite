function [ success ] = stimulate_exp(isi, random, trials, isInRandMode, songbird_directory, GuiHandle, a)
if ~exist('path_to_intan_data_folder', 'var')
    path_to_intan_data_folder = uigetdir('..'); % one level up
    textfile = fullfile(path_to_intan_data_folder, strcat(datestr(now, 'mmddyyyyHHSS'), 'markers.txt'));
end
ps = findobj(GuiHandle, 'Tag', 'pS');
ets = findobj(GuiHandle, 'Tag', 'elapsedTimeString');
fid = fopen(textfile, 'wt');%for dowrite    

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
    function updatecount
        set(ets, 'String', strcat('elapsed time: ', num2str(toc)));
        set(ps, 'String', strcat('Of ', num2str(trials*numel(songs)), ' trials, trials done: ', num2str(elem*song+elem-1)));
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
        fprintf(fid, '%s', 'L');
    end
fclose(fid);
clear all
fprintf('\ndone')

success = 1;
return;
end



% have wav files that I want to play- I read them using wavread, and play them using sound or play(audioplayer).
% my problem is that for this assignment precision is important, and some how my files are sound later then they should be-
% all my files work this way- silence for x milliseconds ,and a strong noise for just a couple milliseconds afterwards.
% but in my code, using both functions the sound comes too far behind the x milliseconds..
% what can I do to make it more precise? maybe changing stuff like bits or Fz?
%
% Maybe load them in prior to needing to play them so you
% don't have to waste time reading from disk at the instant
% that they need to be played. You might also try bumping up
% the priority of the MATLAB process (control-shift-Esc, right
% click process and set priority to high, NOT real time). Others
% may have other ideas. When you play your waves, do other players
% have silence, then the sound, then loud noise at the end? You might
% want to open up your sound file in a program like free Audacity to see
% what the waveform looks like. Trim off the noise at the end or silence from
% the beginning if there is any, then resave the cropped waveform.