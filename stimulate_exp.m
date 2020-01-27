function [ success ] = stimulate_exp(isi, random, trials, isInRandMode, songbird_directory, GuiHandle, a)
    %%
    if ~exist('path_to_intan_data_folder', 'var')
        path_to_intan_data_folder = uigetdir('..', 'path to intan data folder'); % one level up
    end

    % we are going to make the name match the automatic timestamp as intan
    textfile = fullfile(path_to_intan_data_folder,...
        strcat(datestr(now, 'yymmdd_HHMMSS'), 'markers.txt'));
    stimtime = fullfile(path_to_intan_data_folder,...
        strcat(datestr(now, 'yymmdd_HHMMSS'), 'stimtime.txt'));


    ps = findobj(GuiHandle, 'Tag', 'pS'); % progress string
    ets = findobj(GuiHandle, 'Tag', 'elapsedTimeString');
    textfile_fid = fopen(textfile, 'wt'); % for dowrite    
    stimtime_fid = fopen(stimtime, 'wt');
    
    % Stimulate acoustically, send data via arduino to the intan board for duration of song.
    songs = dir(fullfile(songbird_directory, '*.wav')); % should already be sorted by insertion
    a.writeDigitalPin('D5', 1);% Intan analog input 7, digital 5, triggers.
    pause(1); % because intan likes to wait for one second latency.
    
    try
        tic
        xi = randperm(numel(songs));
        songs = songs(xi); %.name; % alternatuvely had it as shuffled
        % Random trials
        if isInRandMode
            for elem = 1:str2num(trials)
                for song = 1:numel(songs)
                    updatecount(elem, trials, ets, ps)
                    playprot(songs, song, a, textfile_fid, stimtime_fid)
                end
            end
            
        % Habituation
        else
            for song = 1:numel(songs) % Habituation protocol
                for elem = 1:str2num(trials)
                    updatecount(elem, trials, ets, ps)
                    playprot(songs, song, a, textfile_fid, stimtime_fid)
                end
            end
        end
    catch ME
        disp(ME)
        clean_up(0);
        return;
    end
    
    %% now get STRF!
    % copying methods from Bottjer et al.
    NUM_FREQ = 39;
    NUM_AMP = 7;
    
    order = randperm(NUM_FREQ*NUM_AMP);
    
    for i = 1:NUM_FREQ*NUM_AMP
        metaind = find(order==i);
        
        f_i = ceil(metaind/NUM_AMP);
        modulus = mod(metaind, NUM_AMP) + 1;
        if modulus > 0
            a_i = modulus;
        else
            a_i = NUM_AMP;
        end
        
        frequency = 200*2^(.1*f_i);
        amp = a_i * 10;
        % update gui
        updatecount(amp, 70, ets, ps)
        
        % send aux data and send tone
        a.writeDigitalPin('D6', 1) % Start playback
        sr = 44.1e3;
        [y] = tones(frequency, amp, 44.1e3);
        
        player = audioplayer(y, sr);
        playblocking(player) % so that it doesn't all play at once
        
        a.writeDigitalPin('D6', 0) % Once playback done, Arduino off
        fprintf(textfile_fid, '%s\n', [num2str(frequency) ' ' num2str(amp)]); % write to file
        
        pause(0.01);
        disp(num2str(i))
    end
        
    %% cleaning up
    clean_up(1);
    return;

    %% helper functions
    % note: elem is a number
    function updatecount(elem, trials, ets, ps)
        % progress string
        set(ps, 'String', strcat(num2str(elem), ' of ', num2str(trials)));
        % elapsed time string
        set(ets, 'String', strcat('elapsed time: ', num2str(toc)));
    end
    function playprot(songs, song, a, textfile_fid, stimtime_fid)
        % load file, set filename
        songfile=strcat(songs(song).folder, '\', songs(song).name);
        [Y, Fs]=audioread(songfile);
        % in case is stereo, convert to single channel
        Y = Y(:,1);
        % fade the Y variable in and out
        fade_win = ceil(Fs * 0.400);
        beginning = Y(1:fade_win);
        beginning = beginning .* [0:1/(length(beginning)-1):1]';
        middle = Y(fade_win+1:end-fade_win);
        last = Y(end-(fade_win+1):end);
        last = last .* [1:-1/(length(last)-1):0]';
        Y_fade = [beginning; middle; last];
        
        % make player
        player = audioplayer(Y_fade, Fs);
        
        % play
        a.writeDigitalPin('D6', 1) % Arduino on for duration of playback
        
        % start counting
        tic 
        playblocking(player) % so that it doesn't all play at once
        a.writeDigitalPin('D6', 0) % Once playback done, Arduino off
        fprintf(textfile_fid, '%s\n', songfile); % write to file
        fprintf(stimtime_fid, '%s\n',...
            datestr(now, 'yymmdd_HHMMSS')); % can comepare to name of file
        
        % cleanup
        clear Y Fs player
        
        % pause
        pausetime = str2double(isi)+rand*str2double(random) - toc; % This fixes a bug where I didn't account for length of song
        
        % inter stim interval can't be less than 3
        if pausetime < 3
            pausetime = 3; 
        end
        
        % isi plus or minus rand [0,1] times random
        pause(pausetime) 
    end

    function clean_up(succeeded)
        fclose(textfile_fid);
        fclose(stimtime_fid);
        a.writeDigitalPin('D5', 0);% Intan analog input 7, digital 5, triggers.
        fprintf('\ndone\n')
        success = succeeded;
        clear all
    end
end