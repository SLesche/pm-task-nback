% This function loads all settings for the experiment

function expinfo = ExpSettings(expinfo)
%% Get Date an time for this session
expinfo.DateTime = datetime('now');

expinfo.DateTime.Format = 'dd-MMM-yyyy';
expinfo.Date = cellstr(expinfo.DateTime);
expinfo.Date = expinfo.Date{1};

expinfo.DateTime.Format = 'hh:mm:ss';
expinfo.Time = cellstr(expinfo.DateTime);
expinfo.Time = expinfo.Time{1};

%% Specify Stimulus and Text properties 
expinfo.stimulussize = 40; % in Pixel 

%% Secify number of general instruction slides
expinfo.InstStop_Nback = 4;
expinfo.InstStop_PM = 2;

%% Timing - fixed in all trials
expinfo.FeedbackDuration = 0.5;
expinfo.MaxRT  = 3;
expinfo.LongRT = 1;

%% Manipulation 

if mod(expinfo.subject, 2)==0
    
    expinfo.matchKey = 'd';
    expinfo.nomatchKey = 'l';
    expinfo.InstFolder_Nback      = 'Instructions_Nback_DMATCH/';
    
    % if expinfo.session ==1
    %     expinfo.cond = 1;
    %     expinfo.condition               = 'focal';
    %     expinfo.InstFolder_PM           = 'Instructions_PM_focal/';
    %     expinfo.word_PM_exp             = {'ORDEN' 'LANZE' 'ORDEN' 'LANZE' 'LANZE' 'LANZE' 'ORDEN' 'ORDEN'};
    % elseif expinfo.session ==2
    %     expinfo.cond = 2;
    %     expinfo.condition                = 'non focal';
    %     expinfo.InstFolder_PM            = 'Instructions_PM_non_focal/';
    %     expinfo.word_PM_exp              = {'KANTE' 'MAUER' 'KOHLE' 'MOTIV' 'MENGE' 'MOTOR' 'KAKTUS' 'KETTE'};
    % end
elseif mod(expinfo.subject, 2)==1
    
    expinfo.matchKey = 'l';
    expinfo.nomatchKey = 'd';
    expinfo.InstFolder_Nback      = 'Instructions_Nback_LMATCH/';
    
    % if expinfo.session ==1
    %     expinfo.cond = 2;
    %     expinfo.condition                = 'non focal';
    %     expinfo.InstFolder_PM            = 'Instructions_PM_non_focal/';
    %     expinfo.word_PM_exp              = {'KANTE' 'MAUER' 'KOHLE' 'MOTIV' 'MENGE' 'MOTOR' 'KAKTUS' 'KETTE'};
    % elseif  expinfo.session == 2
    %     expinfo.cond = 1;
    %     expinfo.condition = 'focal';
    %     expinfo.InstFolder_PM           = 'Instructions_PM_focal/';
    %     expinfo.word_PM_exp             = {'ORDEN' 'LANZE' 'ORDEN' 'LANZE' 'LANZE' 'LANZE' 'ORDEN' 'ORDEN'};
    % end
end


expinfo.word_PM_exp_focal             = {'ORDEN' 'LANZE' 'ORDEN' 'LANZE' 'LANZE' 'LANZE' 'ORDEN' 'ORDEN'};
expinfo.word_PM_exp_nonfocal          = {'KANTE' 'MAUER' 'KOHLE' 'MOTIV' 'MENGE' 'MOTOR' 'KAKTUS' 'KETTE'};

%% Shuffle conditions
possible_conditions = ["baseline", "focal", "nonfocal"];
expinfo.conditions = possible_conditions(randperm(length(possible_conditions)));

%% Specify Response Keys used in the experiment
expinfo.RightKey = 'RightArrow';
expinfo.LeftKey ='LeftArrow';
expinfo.StartKey='space';
expinfo.AbortKey = 'F12';
expinfo.PMKey = 'F1';
expinfo.RespKeys = {'F1' 'l' 'd'};


%% Defining trials to be conducted
% Specify how many trials should be conducted
expinfo.trialsPerBlock = 20;
expinfo.nPracTrials = 5;
expinfo.blocknum = 8;
expinfo.nTrials = expinfo.trialsPerBlock * expinfo.blocknum; % 20*8 = 160
expinfo.prac_blocknum = 1;
expinfo.prac_ntarget = 1;
expinfo.prac_nfeedback = expinfo.nPracTrials;

expinfo.blockend = linspace(expinfo.nTrials/expinfo.blocknum, expinfo.nTrials, expinfo.blocknum); % [20:20:160];
expinfo.PMback = 5; 
expinfo.nback = 2; 
expinfo.match_per_block = 4;

%% Colors HSL Farbraum
expinfo.Colors.green =  [25 255 25];
expinfo.Colors.red = [255 25 25];
expinfo.Colors.gray =  [140 140 140];
expinfo.Colors.blue = [25 50 255];
expinfo.Colors.yellow = [255 255 25];
expinfo.Colors.orange = [255 150 25];
expinfo.Colors.turquois = [0 255 255];
expinfo.Colors.pink = [255  25 255];
expinfo.Colors.bgColor = [255 255 255];
expinfo.Colors.black = [0 0 0]; 
%% Fonts
expinfo.Fonts.textFont  = expinfo.Fonts.sansSerifFont;

%% Specify Instruction folder
expinfo.InstExtension   = '.JPG';
expinfo.InstFolder      = 'Instructions_gen/';
expinfo.DataFolder      = 'DataFiles/';
end 
%% End of Function
