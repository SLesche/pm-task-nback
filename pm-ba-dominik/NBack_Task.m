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
vars = {'all'};
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

% Extrahiere relevante Felder in eine Tabelle
demo_data =  {...
    expinfo.subject, ...
    expinfo.showPractice, ...
    expinfo.subjectAge, ...
    expinfo.subjectGender, ...
    expinfo.isStudent, ...
    expinfo.studiesPsychology, ...
};

% Speicherpfad erstellen
BackUp_InfoTable = fullfile(expinfo.DataFolder, ...
    [expinfo.taskName '_DemoData_S_' num2str(expinfo.subject) '.csv']);

% Tabelle speichern
writetable(cell2table(demo_data, 'VariableNames', {'subject', 'practice', 'age', 'gender', 'is_student', 'is_psychology'}), BackUp_InfoTable);

% Set priority for PTB processes to ensure best possible timing
%topPriorityLevel = MaxPriority(expinfo.window);
%Priority(topPriorityLevel);

if expinfo.showPractice ==1
       
    isPractice =1;
    
    %% General Instructions
    % This is a loop running through the general instruction slides allowing to
    % move back and forth within these slides. As soon as the last slide is
    % finished you cannot move back.
    displayInstruction(expinfo, expinfo.InstFolder_Nback, 'Explanation_Memory_Task', 0); % Display the first slide of the general instructions

    TextCenteredOnPos(expinfo,'3',expinfo.centerX,expinfo.centerY,expinfo.Colors.black,[]);
    WaitSecs(1);
    TextCenteredOnPos(expinfo,'2',expinfo.centerX,expinfo.centerY,expinfo.Colors.black,[]);
    WaitSecs(1);
    TextCenteredOnPos(expinfo,'1',expinfo.centerX,expinfo.centerY,expinfo.Colors.black,[]);
    WaitSecs(1);
    TextCenteredOnPos(expinfo,'+',expinfo.centerX,expinfo.centerY,expinfo.Colors.black,[]);
    WaitSecs(1);
    
    PracTrials = MakeTrial(expinfo,  isPractice, 'practice');
    for practriali = 1: expinfo.prac_nfeedback % Loop through the practice trials
        PracTrials = DisplayTrial(expinfo,  PracTrials, practriali, isPractice);
    end
    
    BackUp_PracTrial = [expinfo.DataFolder,'Backup\',expinfo.taskName,'_Prac_Trials_S_',num2str(expinfo.subject)];
    save(BackUp_PracTrial,'PracTrials');
end

for condition = expinfo.conditions
    disp(["current condition", condition])
    %% trails without feedback
    isPractice =0;

    if condition == "baseline"
       instruction_picture = 'Practice_Finished';
    elseif condition == "focal"
       instruction_picture = 'Explanation_focal';
    elseif condition == "nonfocal"
        instruction_picture = 'Explanation_nonfocal';
    end

    displayInstruction(expinfo, expinfo.InstFolder_Nback, instruction_picture, 0); % Display the first slide of the general instructions

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

    % InstSlide = 1; % Start with the first slide
    % while InstSlide <= expinfo.InstStop_PM % Loop until last slide of general instruction
    %     % Paste the FileName for the Instrcution Slide depending on the current
    %     % slide to be displayed
    %     Instruction=[expinfo.InstFolder_PM 'PM_' num2str(InstSlide) expinfo.InstExtension];
    %     ima=imread(Instruction); % Read in the File

    %     % Put the File on the PTB window
    %     InstScreen = Screen('MakeTexture',expinfo.window,ima);
    %     Screen('DrawTexture', expinfo.window, InstScreen); % draw the scene
    %     Screen('Flip', expinfo.window);
    %     WaitSecs(0.3);

    %     % Wait for a key press of the right or left key to navigate back an
    %     % forth within the instructions
    %     if InstSlide == 1
    %         [ForwardBackward] = BackOrNext(expinfo,1);
    %     else
    %         [ForwardBackward] = BackOrNext(expinfo,2);
    %     end
    %     InstSlide = InstSlide + ForwardBackward;
    % end
    % WaitSecs(2)
        

    ExpTrials = MakeTrial(expinfo, isPractice, condition);

    for expTrial = 1 : length(ExpTrials) % Loop durch alle Experimental-Trials
        ExpTrials = DisplayTrial(expinfo, ExpTrials, expTrial, isPractice, condition);
    end

    %save all information: i.e. the trial objects, and the expinfo structure.
    % This ensures that all information used within the experiment can be
    % accsessed later
    BackUp_Trial     = [expinfo.DataFolder,'Backup\',expinfo.taskName,'_Exp_Trials_S',num2str(expinfo.subject), '_Condition_', convertStringsToChars(condition)];
    save(BackUp_Trial,'ExpTrials');
    BackUp_ExpInfo   = [expinfo.DataFolder,'Backup\',expinfo.taskName,'_Exp_ExpInfo_S',num2str(expinfo.subject), '_Condition_', convertStringsToChars(condition)];
    save(BackUp_ExpInfo,'expinfo');

    if condition == "baseline"
        instruction_picture = 'First_Block_Finished';
    elseif condition == "focal"
        instruction_picture = 'Second_Block_Finished';
    end

    if condition ~= "nonfocal"
        displayInstruction(expinfo, expinfo.InstFolder_Nback, instruction_picture, 0, 60); % Display the first slide of the general instructions
    end
end
%% End Experiment
% Display one final slide telling the participant that the experiment is
% finished.

ExpEnd=[expinfo.InstFolder 'ExpEnd.jpg'];
ima=imread(ExpEnd);
dImageWait(expinfo,ima);

Priority(0); % Reset priority to low level
closeexp(expinfo.window); % Close the experiment

%% End of Script

