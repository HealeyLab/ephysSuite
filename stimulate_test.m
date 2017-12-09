function stimulate_test
%% Stimulate the bird acoustically, send data via arduino to the thing.
if ~exist('a', 'var') % if no a variable, instantiate it
    a = arduino;
end
%% 
% connected to analog input 7, indicates start of recording, triggers it.
txtfile = 'C:\Users\Dell\Documents\MATLAB\Healey\test.txt';
fid = fopen(txtfile, 'wt');
a.writeDigitalPin('D5', 1);
while 1
    in_arg = input('which song? ', 's');
    switch in_arg
        case 'b' % run bos
            file = dir('C:\Users\Dell\Documents\MATLAB\ephysSuite\zf son\*_BOS*');
            dowrite
            playprot
        case 'rb' % reverse bos
            file = dir('C:\Users\Dell\Documents\MATLAB\ephysSuite\zf son\*REV-BOS*');
            dowrite
            playprot
        case 't' % tutor song
            file = dir('C:\Users\Dell\Documents\MATLAB\ephysSuite\zf son\* TUT*.wav');
            dowrite
            playprot
        case 'rt' % reverse tutor song
            file = dir('C:\Users\Dell\Documents\MATLAB\ephysSuite\zf son\*REV-TUT*.wav');
            dowrite
            playprot
        case 'q'
            a.writeDigitalPin('D5', 0); % stops recording
            fclose(fid);
            break;
        otherwise
            disp huh?
            continue; % bring back to top of loop
    end
end
    function dowrite
        fprintf(fid, '%s\n', in_arg);
    end
    function playprot
        %load file
        [Y, Fs]=audioread(fullfile(file.folder, file.name));
        player = audioplayer(Y, Fs);
        %play
        a.writeDigitalPin('D6', 1) % Arduino on for duration of playback
        playblocking(player) % so that it doesn't all play at once
        a.writeDigitalPin('D6', 0) % Once playback done, Arduino off
        %cleanup
        clear Y Fs player
    end

disp done

end