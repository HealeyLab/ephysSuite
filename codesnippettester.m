%% Arduino multithreading and servo tester
delete(instrfindall);
com = 'COM11';
my_s = serial(com,'BaudRate',9600); % instrfind('Type', 'serial', 'Port', com, 'Tag', '');

fopen(my_s); % initiate arduino communication
matlabval = 5;
pause(2);
fwrite(my_s, matlabval, 'uint8');
fclose(my_s); % end communication with arduino

%% didn't work
% 
% % Create a serial port object.
% com = 'COM11';
% my_s = instrfind('Type', 'serial', 'Port', com, 'Tag', '');
% 
% % Create the serial port object if it does not exist
% % otherwise use the object that was found.
% if isempty(my_s)
%     my_s = serial(com);
% else
%     fclose(my_s);
%     my_s = my_s(1)
% end
% 
% my_s=serial('com11');
% fopen(my_s);
% query(my_s, 'abc');
% fclose(my_s);
% clear my_s;

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
