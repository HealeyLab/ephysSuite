%% Arduino multithreading and servo tester
delete(instrfindall);
com = 'COM11';
my_s = serial(com,'BaudRate',9600); % instrfind('Type', 'serial', 'Port', com, 'Tag', '');

fopen(my_s); % initiate arduino communication
matlabval = 5;
pause(2);
fwrite(my_s, matlabval, 'uint8');
fclose(my_s); % end communication with arduino

%% File Writer
% regenerates the file every time
% 
% if ~exist('filename', 'var')
%     filename = fullfile(uigetdir('..'), 'markers.txt'); % one level up
%     fid = fopen(filename, 'wt');
% end


%% testing audio capabilities
% [name, path] = uigetfile('*.wav');
% f = fullfile(path, name);
% [Y, Fs]=audioread(f);
% player = audioplayer(Y, Fs);
% playblocking(player) % so that it doesn't all play at once

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
