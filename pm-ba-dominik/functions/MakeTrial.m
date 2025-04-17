
% This function generates a trial list from the specified Trial
% configurations in the expinfo. Alternatively, we can specify the Trial
% configurations here if there is more complex things to do...

function [Trial] = MakeTrial(expinfo, isPractice, current_condition)
%% specify Trial configurations

% clear all
% expinfo.subject = 1;
% isPractice = 0;
% 
% if mod(expinfo.subject, 2) == 1
%     expinfo.cond = 1;
%     expinfo.condition = 'focal';
%     expinfo.InstFolder_PM           = 'Instructions_PM_focal/';
%     expinfo.word_PM_exp             = {'KANTE' 'MAUER' 'KANTE' 'MAUER' 'MAUER' 'MAUER' 'KANTE' 'KANTE'};
% else
%     expinfo.cond = 2;
%     expinfo.condition                = 'non focal';
%     expinfo.InstFolder_PM            = 'Instructions_PM_non_focal/';
%     expinfo.word_PM_exp              = {'KANTE' 'MAUER' 'KOHLE' 'MOTIV' 'MENGE' 'MOTOR' 'KAKTUS' 'KETTE'};
% end
% 
% %% Specify Response Keys used in the experiment
% expinfo.RightKey = 'RightArrow';
% expinfo.LeftKey ='LeftArrow';
% expinfo.StartKey='space';
% expinfo.AbortKey = 'ESCAPE';
% expinfo.PMKey = 'F1';
% expinfo.RespKeys = {'F1' 'l' 'd'};
% 
% if mod(expinfo.subject, 4) == 1 || mod(expinfo.subject, 4) == 2
%     expinfo.matchKey = 'd';
%     expinfo.nomatchKey = 'l';
%     expinfo.InstFolder_Nback      = 'Instructions_Nback_DMATCH/';
% elseif mod(expinfo.subject, 4) == 3 || mod(expinfo.subject, 4) == 0
%     expinfo.matchKey = 'l';
%     expinfo.nomatchKey = 'd';
%     expinfo.InstFolder_Nback      = 'Instructions_Nback_LMATCH/';
% end
 
% %% Defining trials to be conducted
% % Specify how many trials should be conducted
% expinfo.nTrials = 168;
% expinfo.nPracTrials = 40;
% expinfo.blocknum = 8;
% expinfo.prac_blocknum = 2;
% expinfo.prac_ntarget = 2;
% expinfo.prac_nfeedback = 10;
 
% expinfo.blockend = [21:21:168];
% expinfo.PMback = 5; 
% expinfo.nback = 2; 
% expinfo.match_per_block = 4;

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

rng(expinfo.subject  + isPractice + expinfo.session);

if isPractice == 1
    Wordlist = readtable('Words_long.xlsx','Format','auto');
    Words = repmat(Wordlist.Words,1,1);
    nTrials = expinfo.nPracTrials;
    nMatches = expinfo.prac_blocknum * expinfo.match_per_block;
else
    Wordlist = readtable('Words_long.xlsx','Format','auto');
    Words = repmat(Wordlist.Words,2,1);
    nTrials = expinfo.nTrials;
    nMatches = expinfo.blocknum * expinfo.match_per_block;
end


% create PM trials
Positions = (expinfo.nback+1):nTrials;

% create settings for PM task
if isPractice ==0
    PM          = expinfo.blockend- randsample(0:expinfo.PMback,length(expinfo.blockend), true);
    PMtask      = zeros(nTrials, 1);
    PMnum       = zeros(nTrials, 1);
    PMtask(PM)  = 1;
    PMnum(PM)   = 1:length(PM);
end

% get positions for matches in Nback task
% nMatches = round(nTrials / 3)-expinfo.nPM;
test = false;

while test ==0
    Match = zeros(nTrials, 1);

    if isPractice==0
        Positions= Positions(~ismember(Positions, [PM PM+expinfo.nback]));
        matchPositions = randsample(Positions, nMatches);  % Randomly pick positions for the ones
    else
        matchPositions = randsample((expinfo.nback+1):expinfo.prac_nfeedback, expinfo.prac_ntarget);  % Randomly pick positions for the ones
        
        %matchPositions_2 = randsample(expinfo.prac_nfeedback+1:nTrials, nMatches-expinfo.prac_ntarget);  % Randomly pick positions for the ones
        %matchPositions =[matchPositions_1 matchPositions_2];
    end

    matchPositions_sorted = sort(matchPositions);

    % Calculate differences between consecutive match positions
    diffs_all = abs(matchPositions_sorted' - matchPositions_sorted);

    if ~any(diffs_all==expinfo.nback)
        Match(matchPositions) = 1;
        test = true; % Exit loop
    end
end


% initialize trial strcuture
for trial = 1: nTrials
    Trial(trial).participant = expinfo.subject; % subject id
    Trial(trial).TrialNum = trial; % trial number
    Trial(trial).Match = Match(trial); % is current trial match

    if isPractice == 1 || isPractice == 2
        Trial(trial).PMtask =0;
        Trial(trial).PMnum = 0; % is current trial PM task
    else
        Trial(trial).PMtask = PMtask(trial); % is current trial PM task
        Trial(trial).PMnum = PMnum(trial); % is current trial PM task
    end

    if Trial(trial).Match == 0 && Trial(trial).PMtask == 1 % PM task
        Trial(trial).Stim = expinfo.word_PM_exp{PMnum(trial)};
    elseif Trial(trial).Match == 0 && Trial(trial).PMtask == 0 % no PM task and no match
        rowIdx = randsample(height(Words), 1); % Get a random row index
        Trial(trial).Stim = Words{rowIdx};
        Words(rowIdx, :) = []; % Remove the row from the table
    elseif Trial(trial).Match == 1 && Trial(trial).PMtask == 0 % no PM task and  match
        Trial(trial).Stim = Trial(trial-expinfo.nback).Stim;
    end


    % add correct response
    if isPractice ==0
        Trial(trial).Prac = 0;

        if Trial(trial).Match == 1 && Trial(trial).PMtask ==0
            Trial(trial).CorResp = expinfo.matchKey;
        elseif Trial(trial).Match == 0 && Trial(trial).PMtask ==0
            Trial(trial).CorResp = expinfo.nomatchKey;
        elseif  Trial(trial).PMtask ==1
            Trial(trial).CorResp = expinfo.PMKey ;
        end
        Trial(trial).PM1 = PM(1); % trial number PM
        Trial(trial).PM2 = PM(2); % trial number PM
        Trial(trial).PM3 = PM(3); % trial number PM
        Trial(trial).PM4 = PM(4); % trial number PM
        Trial(trial).PM5 = PM(5); % trial number PM
        Trial(trial).PM6 = PM(6); % trial number PM
        Trial(trial).PM7 = PM(7); % trial number PM
        Trial(trial).PM8 = PM(8); % trial number PM

    elseif isPractice ==1
        Trial(trial).Prac = 1;

        if Trial(trial).Match == 1
            Trial(trial).CorResp = expinfo.matchKey;
        elseif Trial(trial).Match == 0
            Trial(trial).CorResp = expinfo.nomatchKey;
        end
        Trial(trial).PM1 = 0; % trial number PM
        Trial(trial).PM2 = 0; % trial number PM
        Trial(trial).PM3 = 0; % trial number PM
        Trial(trial).PM4 = 0; % trial number PM
        Trial(trial).PM5 = 0; % trial number PM
        Trial(trial).PM6 = 0; % trial number PM
        Trial(trial).PM7 = 0; % trial number PM
        Trial(trial).PM8 = 0; % trial number PM
    end
end


%Informationen einbauen
for trial = 1: nTrials
    if isPractice == 1
        Trial(trial).TaskDescription = 'PM_Nback_prac';
    else
        Trial(trial).TaskDescription = 'PM_Nback_exp';
    end
    Trial(trial).Subject = expinfo.subject;
    Trial(trial).Session= expinfo.session;
    
    Trial(trial).PMcondition = current_condition;
    Trial(trial).ISI = 0.5;
    Trial(trial).StimDuration =1 ;
end


end
