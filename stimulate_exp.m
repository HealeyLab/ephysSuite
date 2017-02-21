function [ success ] = stimulate_exp(isi, random, trials, isInRandMode, songbird_directory, GuiHandle, a)
ps = findobj(GuiHandle, 'Tag', 'pS');
ets = findobj(GuiHandle, 'Tag', 'elapsedTimeString');
%% Stimulate the bird acoustically, send data via arduino to the intan board for duration of song.

songs = dir(fullfile(songbird_directory, '*.wav')); % should already be sorted by insertion
% fprintf(strcat('Of ', num2str(trials*numel(songs)))) % from previous
% technique

if isInRandMode
%     fprintf('\nTrials done:  ')
    for elem = 1:str2num(trials)
        xi = randperm(numel(songs));
        shuffledsongs = songs(xi).name; % shuffle songs
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
%         if song*elem > 1
%             for i = 1:log10((elem*song+elem-1)*10) % total number of times
%                 fprintf('\b') % deletes relevant things
%             end
%         end
%         fprintf('%d', elem*song+elem)
    end
    function playprot
        %load file
        file=strcat(songs(song).folder, '/', songs(song).name);
        [Y, Fs]=audioread(file);
        player = audioplayer(Y, Fs);
        %play
        a.writeDigitalPin('D6', 1) % Arduino on for duration of playback
        tic
        playblocking(player) % so that it doesn't all play at once
        a.writeDigitalPin('D6', 0) % Once playback done, Arduino off
        %cleanup
        clear Y Fs player
        %pause
        pausetime = str2double(isi)+rand*str2double(random) - toc; % This fixes a bug where I didn't account for length of song
        pause(pausetime) % isi plus or minus rand [0,1] times random
    end
clear all
fprintf('\ndone')

success = 1;
return;
end








% I have wav files that I want to play- I read them using wavread, and play them using sound or play(audioplayer).
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