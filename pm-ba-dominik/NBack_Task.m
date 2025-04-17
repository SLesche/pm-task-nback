%N ame of the experiment %%
% It is good practice to give a short desctiption of your experiment
clear all; % Start the experiment with empty workspace
clc; % Clear command window

% Create Folder for BackUp Files if it does not exist
if ~exist('DataFiles', 'dir')
    mkdir DataFiles
end

% Add folders to MATLAB to access functions, instruction slides, and
% location for data backup
addpath('functions', 'Instructions', 'DataFiles');

%% Enter Subject & Session ID + further Info if needed %%
% Define a task name
TaskName = 'PM_nback';

% Definde variables to be specified when the experiment starts.
vars = {'sub', 'prac', 'ses'};
% The following variables can be specified:
% Subject ID = 'sub'
% Session Number = 'ses'
% Test Run = 'test'
% Instruction Language = 'lang'
% Run practive = 'prac'
% Subject's Age = 'age'
% Subject's Gender = 'gender'
% Subject's Sex = 'sex'

% Run provideInfo function. This opens up a dialoge box asking for the
% specified information. For all other variables default values are used.
expinfo = provideInfo(TaskName,vars);
clearvars TaskName vars % clean up workspace

%% Allgemeine Einstellungen & Start von PTB %%
% Setting a seed for randomization ensures that you can reproduce
% randomized variables for each subject and session id.

% Open PTB windown
expinfo = startPTB(expinfo);

% Read in Exp Settings
expinfo = ExpSettings(expinfo);

% Set priority for PTB processes to ensure best possible timing
topPriorityLevel = MaxPriority(expinfo.window);
Priority(topPriorityLevel);

if expinfo.showPractice ==1
        
    isPractice =1;
    
    %% General Instructions
    % This is a loop running through the general instruction slides allowing to
    % move back and forth within these slides. As soon as the last slide is
    % finished you cannot move back.
    if expinfo.session==1

    InstSlide = 1; % Start with the first slide
    
    while InstSlide <= expinfo.InstStop_Nback % Loop until last slide of general instruction
        % Paste the FileName for the Instrcution Slide depending on the current
        % slide to be displayed
        Instruction=[expinfo.InstFolder_Nback 'Prac_' num2str(InstSlide) expinfo.InstExtension];
        ima=imread(Instruction); % Read in the File
        
        % Put the File on the PTB window
        InstScreen = Screen('MakeTexture',expinfo.window,ima);
        Screen('DrawTexture', expinfo.window, InstScreen); % draw the scene
        Screen('Flip', expinfo.window);
        WaitSecs(0.3);
        
        % Wait for a key press of the right or left key to navigate back an
        % forth within the instructions
        if InstSlide == 1
            [ForwardBackward] = BackOrNext(expinfo,1);
        elseif InstSlide == expinfo.InstStop_Nback
            [ForwardBackward] = BackOrNext(expinfo,2);
        else
            [ForwardBackward] = BackOrNext(expinfo,0);
        end
        InstSlide = InstSlide + ForwardBackward;
    end
    
    
    % % clean up no longer relevant variables after the instrction to keep the
    % % workspace tidy
    clearvars Instruction ima InstSlide
    clearScreen(expinfo);
    WaitSecs(0.1);

    else
        Prac_2_Start=[expinfo.InstFolder_Nback 'Prac_1_2.jpg'];
        ima=imread(Prac_2_Start);
        dImageWait(expinfo,ima);
    end


    TextCenteredOnPos(expinfo,'3',expinfo.centerX,expinfo.centerY,expinfo.Colors.black,[]);
    WaitSecs(1);
    TextCenteredOnPos(expinfo,'2',expinfo.centerX,expinfo.centerY,expinfo.Colors.black,[]);
    WaitSecs(1);
    TextCenteredOnPos(expinfo,'1',expinfo.centerX,expinfo.centerY,expinfo.Colors.black,[]);
    WaitSecs(1);
    TextCenteredOnPos(expinfo,'+',expinfo.centerX,expinfo.centerY,expinfo.Colors.black,[]);
    WaitSecs(1);
    
    PracTrials = MakeTrial(expinfo,  isPractice);
    for practriali = 1: expinfo.prac_nfeedback % Loop through the practice trials
        PracTrials = DisplayTrial(expinfo,  PracTrials, practriali, isPractice);
    end
    
    BackUp_PracTrial = [expinfo.DataFolder,'Backup\',expinfo.taskName,'_Prac_Trials_S_',num2str(expinfo.subject),num2str(expinfo.session)];
    save(BackUp_PracTrial,'PracTrials');
end

for condition = expinfo.conditions
    %% trails without feedback
    isPractice =2;

    Base_Start_1=[expinfo.InstFolder_Nback 'Base_1.jpg'];
    ima=imread(Base_Start_1);
    dImageWait(expinfo,ima);

    TextCenteredOnPos(expinfo,'3',expinfo.centerX,expinfo.centerY,expinfo.Colors.black,[]);
    WaitSecs(1);
    TextCenteredOnPos(expinfo,'2',expinfo.centerX,expinfo.centerY,expinfo.Colors.black,[]);
    WaitSecs(1);
    TextCenteredOnPos(expinfo,'1',expinfo.centerX,expinfo.centerY,expinfo.Colors.black,[]);
    WaitSecs(1);
    TextCenteredOnPos(expinfo,'+',expinfo.centerX,expinfo.centerY,expinfo.Colors.black,[]);
    WaitSecs(1);

    % for practriali = expinfo.prac_nfeedback+1: length(PracTrials) % Loop through the practice trials
    %     PracTrials = DisplayTrial(expinfo,  PracTrials, practriali, isPractice);
    % end

    % BackUp_BaseTrial = [expinfo.DataFolder,'Backup\',expinfo.taskName,'_Base_S_',num2str(expinfo.subject), '_Ses_',num2str(expinfo.session)];
    % save(BackUp_BaseTrial,'BackUp_BaseTrial');

        %% Introduce PM task

        InstSlide = 1; % Start with the first slide
        while InstSlide <= expinfo.InstStop_PM % Loop until last slide of general instruction
            % Paste the FileName for the Instrcution Slide depending on the current
            % slide to be displayed
            Instruction=[expinfo.InstFolder_PM 'PM_' num2str(InstSlide) expinfo.InstExtension];
            ima=imread(Instruction); % Read in the File

            % Put the File on the PTB window
            InstScreen = Screen('MakeTexture',expinfo.window,ima);
            Screen('DrawTexture', expinfo.window, InstScreen); % draw the scene
            Screen('Flip', expinfo.window);
            WaitSecs(0.3);

            % Wait for a key press of the right or left key to navigate back an
            % forth within the instructions
            if InstSlide == 1
                [ForwardBackward] = BackOrNext(expinfo,1);
            else
                [ForwardBackward] = BackOrNext(expinfo,2);
            end
            InstSlide = InstSlide + ForwardBackward;
        end
        WaitSecs(2)
        %
        % Priority(0); % Reset priority to low level
        % closeexp(expinfo.window); % Close the experiment
end

%% End of Script

