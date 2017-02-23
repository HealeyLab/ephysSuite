%% File Writer
% regenerates the file every time
if ~exist('filename', 'var')
    filename = fullfile(uigetdir('..'), 'markers.txt'); % one level up
    fid = fopen(filename, 'w');
end

markers = ['M' 'C' 'J'];
for marker = 1 : numel(markers)
    fprintf(fid, '%s', markers(marker));
end
fclose(fid);
%% ARDUINO SIGNALLER FOR PARTICULAR BIRDSONG INPUT
% The idea here is that we will send the arduino a bytearray which can be
% later decoded into the birdsong code (eg, CON for conspecific, BOS,
% BOSREV, etc etc) and this is send to the intan board to be decoded later
% with a rising threshold, lol how about that huh?
% in='b';
% a = arduino
% dig = @(hilo) digitalWrite(a, 'D5', hilo);
% bytes = dec2bin(in);
% for byte = 1:size(bytes, 1)
%     for bit = 1:size(bytes, 2)
%         % bytes(rows, cols)
%         dig(bytes(byte, bit))
%     end
% end


%% PRINTER UPDATER
% fprintf('\ncounts:  ')
% song = 5; elem = 3;
% for j= 1:song*elem
%     for i = 1:log10(j*10) % total number of times
%         fprintf('\b') % deletes relevant things
%     end
%     
%     fprintf('%d', j)
%     pause(.05)
% end
% 
% fprintf('\n')
