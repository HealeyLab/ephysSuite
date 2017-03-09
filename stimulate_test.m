function stimulate_test
clear all
%% Stimulate the bird acoustically, send data via arduino to the thing.
if ~exist('a', 'var') % if no a variable, instantiate it
    a = arduino;
end
%% 
% connected to analog input 7, indicates start of recording, triggers it.
a.writeDigitalPin('D5', 1);
while 1
    in = input('which song?', 's');
    switch in
        case 'b' % run bos
            file = dir('C:\Users\Dell\Documents\MATLAB\Healey\zf son\* BOS*.wav');
            dowrite
            playprot
        case 'rb' % reverse bos
            file = dir('C:\Users\Dell\Documents\MATLAB\Healey\zf son\*REV-BOS*.wav');
            dowrite
            playprot
        case 't' % tutor song
            file = dir('C:\Users\Dell\Documents\MATLAB\Healey\zf son\* TUT*.wav');
            dowrite
            playprot
        case 'rt' % reverse tutor song
            file = dir('C:\Users\Dell\Documents\MATLAB\Healey\zf son\*REV-TUT*.wav');
            dowrite
            playprot
        case 'q'
            a.writeDigitalPin('D5', 0); % stops recording
            break;
        otherwise
            disp huh?
            continue; % bring back to top of loop
    end
end
    function dowrite
%         txtfile = maketxt(
        fid = fopen(txtfile, 'wt');
        fprintf(fid, '%s\n', in);
        fclose(fid);
    end
    function playprot
        %load file
        [Y, Fs]=audioread(file);
        player = audioplayer(Y, Fs);
        %play
        a.writeDigitalPin('D6', 1) % Arduino on for duration of playback
        playblocking(player) % so that it doesn't all play at once
        a.writeDigitalPin('D6', 0) % Once playback done, Arduino off
        %cleanup
        clear Y Fs player
    end

disp done































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
end