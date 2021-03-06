function make_gui
    % NOTE: to go fast, toggle the fields with the TAB key.
    % add components
    cd 'C:\Users\Healey Lab\Documents\ephysSuite'
    if ~exist('a', 'var') % if no a variable, instantiate it
        a = arduino;
    end
    
    hs = addcomponents;
    function hs = addcomponents
        hs.fig = figure('Visible', 'on', 'Tag', 'fig');
        % same line
        hs.isiStr = uicontrol(hs.fig,...
            'Position',[50 250 70 30],...
            'Style', 'text',...
            'String','ISI');
        hs.isiEdit = uicontrol(hs.fig,...
            'Position',[100 250 70 30],...
            'Style', 'edit',...
            'String', '10',... % default, can change
            'Tag', 'isi');
        
        % randomness
        hs.randStr= uicontrol(hs.fig,...
            'Style', 'text',...
            'Position',[150 250 70 30],...
            'String','plus or minus');
        hs.randEdit = uicontrol(hs.fig,...
            'Style', 'edit',...
            'Position',[225 250 70 30],...
            'String', '2',...
            'Tag', 'random');
        % same line
        % num trials
        hs.trialStr= uicontrol(hs.fig,...
            'Style', 'text',...
            'Position',[50 150 70 30],...
            'String','number of trials');
        hs.trialEdit = uicontrol(hs.fig,...
            'Style', 'edit',...
            'Position',[120 150 70 30],...
            'String', '25',...
            'Tag', 'trials');
        
        % Get song directory
        hs.getSongDirectory = uicontrol(hs.fig,...
            'Style', 'Edit',...
            'Position', [50 75 300 20],...
            'String', 'C:\Users\Healey Lab\Documents\ephysSuite\zf son mda');

        % Habituate?
        hs.randomOrNah = uicontrol(hs.fig,...
            'Style', 'toggle',...
            'Position',[50 50 125 20],...
            'String','Random mode',...
            'Value',1,...
            'Callback', @changeToggleText,...
            'Tag', 'mode');
        
        % GO
        hs.go = uicontrol(hs.fig,...
            'Style', 'pushbutton',...
            'Position',[50 25 125 20],...
            'String','Run',...
            'Callback', @run,...
            'Tag', 'go');
%         [from_left from_bottom width height]
        hs.progressString = uicontrol(hs.fig,...
            'Style', 'text',...
            'Position',[175 25 425 20],...
            'Tag', 'pS',...
            'String','');
        hs.elapsedTimeString = uicontrol(hs.fig,...
            'Style', 'text',...
            'Position',[175 50 425 20],...
            'Tag', 'elapsedTimeString',...
            'String','Elapsed time');
        hs.explanatoryTextBox = uicontrol(hs.fig,...
            'Style','text',...
            'Position', [325 100 225, 300],...
            'Tag', 'explanatoryTextBox',...
            'String','ISI(interval): inter-stimulus interval. plus or minus(var): uniformly distributed values in the range [-val val]. number of trials(N): number of total stimulus playbacks = number of stimuli * N. Depending on the mode (random or habituation), these stimuli will either be presented in chunks of N stimulus x for each stimulus (habituate), or in randomized blocks of all stimuli N times (random). Most importantly, make sure the text field above the bottom two buttons is set to the path of your stimuli. The bottom buttons toggle habituate and random mode (top) and ultimately run the experiment. For Run, you will be prompted to select a folder. Select the same folder you are saving your intan .rhd files.');
    end

    function run(hObject, ~)
        isi = hs.isiEdit.String; % get(hs, 'isiEdit.String'); 
        random = hs.randEdit.String;
        trials = hs.trialEdit.String;
        isInRandMode = hs.randomOrNah.Value; % so default SHOULD BE random
        songbird_directory = hs.getSongDirectory.String;
        GuiHandle = ancestor(hObject, 'figure');
        stimulate_exp(isi, random, trials, isInRandMode, songbird_directory, GuiHandle, a);     
        pushBulletDriver('done with song trial');
    end

    function changeToggleText(hObject, ~)
        if(strcmp(get(hObject, 'String'), 'Habituate mode'))
            set(hObject, 'String', 'Random mode')
        else
            set(hObject, 'String', 'Habituate mode')
        end
    end
end