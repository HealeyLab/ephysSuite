function stimulate_test
clear all
%% Stimulate the bird acoustically, send data via arduino to the thing.
% if ~exist('a', 'var') % if no a variable, instantiate it
%     a = arduino
% end
%% TODOS:  1 specific button stimulus design
while 1
    in = input('which song?', 's');
    switch in
        case 'b'
            %             run bos
            file = dir('C:\Users\Dell\Documents\MATLAB\Healey\zf son\*.wav');
        case 'rb'
            %             reverse bos
            file = dir('C:\Users\Dell\Documents\MATLAB\Healey\zf son\*.wav');
        case 't'
            %             tutor song
            file = dir('C:\Users\Dell\Documents\MATLAB\Healey\zf son\*.wav');
        case 'rt'
            %           reverse tutor song
            file = dir('C:\Users\Dell\Documents\MATLAB\Healey\zf son\*.wav');
        case 'q'
            break;
        otherwise
            disp huh?
            continue; % bring back to top of loop
    end
    [Y, Fs]=audioread(file);
    player = audioplayer(Y, Fs); %#ok<TNMLP> just to suppress warning
    %     a.writeDigitalPin('D6', 1)
    playblocking(player) % so that it doesn't all play at once
    %     a.writeDigitalPin('D6', 0)
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