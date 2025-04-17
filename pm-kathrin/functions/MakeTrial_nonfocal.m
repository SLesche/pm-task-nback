
% This function generates a trial list from the specified Trial
% configurations in the expinfo. Alternatively, we can specify the Trial
% configurations here if there is more complex things to do...

function [Trial] = MakeTrial_nonfocal(expinfo, blocknumber, isPractice, PMWord)
%% specify Trial configurations
% clear all
% 
% expinfo.nTrials = 21;
% expinfo.nPracTrials_nonfocal = 23;
% blocki = 1;
% isPractice = 0;
% if isPractice == 1
%     PMWord = {'Hecht', 'Dieb', 'Adler'};
% else
%     PMWord = 'Hecht';
% end
% 
% expinfo.PMKey = 'space';
% expinfo.subject = 7;
% expinfo.nPM = 4;
% expinfo.nback = 2;
% 
% if mod(expinfo.subject, 2) == 1
%     expinfo.cond = 1;
%     expinfo.condition = 'focal';
% else
%     expinfo.cond = 2;
%     expinfo.condition = 'non focal';
% end
% 
% expinfo.AbortKey = 'F12';
% if mod(expinfo.subject, 4) == 1 || mod(expinfo.subject, 4) == 2
%     expinfo.matchKey = 'd';
%     expinfo.nomatchKey = 'l';
%     expinfo.InstFolder      = 'Instructions_A/';
% elseif mod(expinfo.subject, 4) == 3 || mod(expinfo.subject, 4) == 0
%     expinfo.matchKey = 'l';
%     expinfo.nomatchKey = 'd';
%     expinfo.InstFolder      = 'Instructions_B/';
% end

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
rng(expinfo.subject + blocknumber + isPractice);

if isPractice == 1
    Wordlist = readtable('Words.xlsx','Format','auto');
else
    Wordlist = readtable('Words.xlsx','Format','auto');
end

% set amount of Trials

if isPractice == 0
    nTrials = expinfo.nTrials;
else
    nTrials = expinfo.nPracTrials_nonfocal;
end

% create PM trials
Match = zeros(nTrials, 1);
Positions = (expinfo.nback+1):nTrials-2;

if isPractice == 1
    PM = randsample(7:17,3);
    PMnum =zeros(nTrials, 1);
    PMnum(sort(PM))= 1:length(PM);
else
    PM  = randsample(7:15,1);
end

PMtask      = zeros(nTrials, 1);
PMtask(PM)  = 1;

% get positions for matches in Nback task
nMatches = 4;
Positions= Positions(~ismember(Positions, [PM PM+2]));
matchPositions = randsample(Positions, nMatches);  % Randomly pick positions for the ones
Match(matchPositions) = 1;
matchPositions_sorted = sort(matchPositions);

% initialize trial strcuture
for trial = 1: nTrials
    Trial(trial).TrialNum = trial; % trial number
    Trial(trial).BlockNum = blocknumber; % block number
    Trial(trial).Match = Match(trial); % is current trial match
    Trial(trial).PMtask = PMtask(trial); % is current trial PM task
    if Trial(trial).Match == 0 && Trial(trial).PMtask == 1 % PM task
        if isPractice== 1
            Trial(trial).Stim = PMWord{PMnum(trial)};
        else
            Trial(trial).Stim = PMWord;
        end
    elseif Trial(trial).Match == 0 && Trial(trial).PMtask == 0 % no PM task and no match
        rowIdx = randsample(height(Wordlist), 1); % Get a random row index
        Trial(trial).Stim = Wordlist.Words{rowIdx};
        Wordlist(rowIdx, :) = []; % Remove the row from the table
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
    else
        Trial(trial).Prac = 1;

        if Trial(trial).Match == 1
            Trial(trial).CorResp = expinfo.matchKey;
        elseif Trial(trial).Match == 0
            Trial(trial).CorResp = expinfo.nomatchKey;
        end
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
    if expinfo.cond == 1
        Trial(trial).PMcondition = 'focal';
    else
        Trial(trial).PMcondition = 'nonfocal';
    end
    Trial(trial).ISI = 0.5;
    Trial(trial).Cue = 0.5;
    Trial(trial).StimDuration =1 ;
    Trial(trial).Fix =1 ;

end


end
