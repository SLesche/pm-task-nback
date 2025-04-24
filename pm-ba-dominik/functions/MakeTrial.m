
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
    Words = repmat(Wordlist.Words,3,1);
    nTrials = expinfo.nTrials;
    nMatches = expinfo.blocknum * expinfo.match_per_block;
end


% create PM trials
Positions = (expinfo.nback+1):nTrials;

% create settings for PM task
if isPractice ==0 || strcmp(current_condition, "baseline")  
    PM          = expinfo.blockend- randsample(0:expinfo.PMback,length(expinfo.blockend), true);
    PMtask      = zeros(nTrials, 1);
    PMnum       = zeros(nTrials, 1);
    PMtask(PM)  = 1;
    PMnum(PM)   = 1:length(PM);
end

% get positions for matches in Nback task
% nMatches = round(nTrials / 3)-expinfo.nPM;
% Initialize Match array
Match = zeros(nTrials, 1);

% Define candidate positions (exclude PM and surrounding positions for exp trials)
validPositions = (expinfo.nback + 1):nTrials;

if isPractice == 0
    pmExcluded = [PM, PM + expinfo.nback];  % PM and PM+nback can't be used
    validPositions = setdiff(validPositions, pmExcluded);
end

% Shuffle the valid positions to randomize selection
validPositions = validPositions(randperm(length(validPositions)));

% Greedily add match positions, ensuring no accidental matches
chosenMatches = [];

for idx = 1:length(validPositions)
    candidate = validPositions(idx);
    if ~Match(candidate)
        chosenMatches = [chosenMatches, candidate];

        Match(candidate) = 1;
        if length(chosenMatches) >= nMatches
            break;
        end
    end
end

if length(chosenMatches) < nMatches
    error('Could not generate sufficient match trials without conflict.');
end



% initialize trial strcuture
for trial = 1: nTrials
    Trial(trial).participant = expinfo.subject; % subject id
    Trial(trial).TrialNum = trial; % trial number
    Trial(trial).Match = Match(trial); % is current trial match

    if isPractice == 1 || isPractice == 2 || strcmp(current_condition, "baseline")
        Trial(trial).PMtask =0;
        Trial(trial).PMnum = 0; % is current trial PM task
    else
        Trial(trial).PMtask = PMtask(trial); % is current trial PM task
        Trial(trial).PMnum = PMnum(trial); % is current trial PM task
    end

    if Trial(trial).Match == 0 && Trial(trial).PMtask == 1 % PM task
        if strcmp(current_condition, 'focal')
            Trial(trial).Stim = expinfo.word_PM_exp_focal{PMnum(trial)};
            %disp(["focal PM task: ", Trial(trial).Stim]);
        elseif strcmp(current_condition, 'nonfocal')
            Trial(trial).Stim = expinfo.word_PM_exp_nonfocal{PMnum(trial)};
            %disp(["Non-focal PM task: ", Trial(trial).Stim]);
        elseif strcmp(current_condition, 'baseline')
            found_word = false;
            while found_word == false
                rowIdx = randsample(height(Words), 1); % Get a random row index
                
                word_stim = Words{rowIdx};

                Trial(trial).Stim = word_stim; % Assign the word to the trial

                if trial <= expinfo.nback
                    Words(rowIdx) = []; % Remove the word from the list to avoid repetition
                    found_word = true; % Exit loop if condition is met
                elseif ~strcmp(word_stim, Trial(trial-expinfo.nback).Stim) & ~strcmp(word_stim, Trial(trial-1).Stim)% Check if the word is not the same as the one in nback
                    Words(rowIdx) = []; % Remove the word from the list to avoid repetition
                    found_word = true; % Exit loop if condition is met
                end
            end    
        end
    elseif Trial(trial).Match == 0 && Trial(trial).PMtask == 0 % no PM task and no match
        found_word = false;
        while found_word == false
            rowIdx = randsample(height(Words), 1); % Get a random row index
            
            word_stim = Words{rowIdx};

            Trial(trial).Stim = word_stim; % Assign the word to the trial

            if trial <= expinfo.nback
                Words(rowIdx) = []; % Remove the word from the list to avoid repetition
                found_word = true; % Exit loop if condition is met
            elseif ~strcmp(word_stim, Trial(trial-expinfo.nback).Stim) & ~strcmp(word_stim, Trial(trial-1).Stim)% Check if the word is not the same as the one in nback
                Words(rowIdx) = []; % Remove the word from the list to avoid repetition
                found_word = true; % Exit loop if condition is met
            end
        end          
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

    elseif isPractice ==1 || strcmp(current_condition, "baseline")
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
