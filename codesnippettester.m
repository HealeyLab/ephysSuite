% physics hw
K = 8.99e9;
q1 = -6.0e-9; % charge 1 in coulombs
q2 = 3.0e-9; % charge 2 in coulombs

d1 = sqrt(.1 * .1 + .05 * .05);
d2 = .05;

unit1 = [.05, .1] / d1; % [cos(theta), sin(theta)]; % unit vector for charge 1
unit2 = [1, 0]; % unit vector for charge 2

E = K * q1 / (d1 * d1) * unit1 + K * q2 / (d2 * d2) * unit2;
norm(E) % spits out the magnitude of E
atand(E(2)/E(1))

% %% Arduino multithreading and servo tester
% delete(instrfindall);
% com = 'COM19';
% my_s = serial(com,'BaudRate',9600); % instrfind('Type', 'serial', 'Port', com, 'Tag', '');
% 
% fopen(my_s); % initiate arduino communication
% matlabval = 8;
% pause(2);
% fwrite(my_s, matlabval, 'uint8');
% fclose(my_s); % end communication with arduino

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
