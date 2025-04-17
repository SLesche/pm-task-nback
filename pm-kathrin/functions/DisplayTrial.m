% This function displays one trial of a Simon Task

function Trial = DisplayTrial(expinfo, Trial, expTrial, isPractice)

%% Trial Procedure

% display Probe Stimulus
Trial(expTrial).time_probe = TextCenteredOnPos(expinfo,Trial(expTrial).Stim,expinfo.centerX,expinfo.centerY, expinfo.Colors.black);

% get response
Trial = getresponse(expinfo, Trial, expTrial, Trial(expTrial).time_probe);
next_flip = getAccurateFlip(expinfo.window,Trial(expTrial).time_probe,Trial(expTrial).StimDuration);
clearScreen(expinfo, next_flip);

% give Feedback if is Practice
if isPractice ==1
    if Trial(expTrial).ACC == 1
        TextCenteredOnPos(expinfo,'Richtig',0.5*expinfo.maxX,0.5*expinfo.maxY,expinfo.Colors.green);
    elseif Trial(expTrial).ACC == 0
        TextCenteredOnPos(expinfo,'Falsch',0.5*expinfo.maxX,0.5*expinfo.maxY,expinfo.Colors.red);
    elseif Trial(expTrial).ACC == -2
        TextCenteredOnPos(expinfo,'Zu langsam',0.5*expinfo.maxX,0.5*expinfo.maxY,expinfo.Colors.black);
    elseif Trial(expTrial).ACC == -3
        TextCenteredOnPos(expinfo,'Unerlaubte Taste',0.5*expinfo.maxX,0.5*expinfo.maxY,expinfo.Colors.red);
    end
    WaitSecs(expinfo.FeedbackDuration);
    clearScreen(expinfo);
else
    if Trial(expTrial).ACC == -3
        TextCenteredOnPos(expinfo,'Unerlaubte Taste',0.5*expinfo.maxX,0.5*expinfo.maxY,expinfo.Colors.red);
        WaitSecs(expinfo.FeedbackDuration);
        clearScreen(expinfo);
    end
    clearScreen(expinfo);
end


% start ISI
Trial(expTrial).time_ISI = clearScreen(expinfo,[]);
next_flip = getAccurateFlip(expinfo.window,Trial(expTrial).time_ISI,Trial(expTrial).ISI);
WaitSecs(0.05);

% Start tracking the ISI time
isiStartTime = GetSecs;
Trial(expTrial).ISIpressedKey = []; % Initialize an empty cell array to store keypresses for this trial

% Check for key presses during the ISI period
while GetSecs - isiStartTime < Trial(expTrial).ISI
    [keyIsDown, keyTime, keyCode] = KbCheck;
    if keyIsDown
        % Record the key name and the time it was pressed
        ISIpressedKey = KbName(find(keyCode));
        Trial(expTrial).ISIpressedKey = ISIpressedKey;
        Trial(expTrial).ISIpressedKey_time = keyTime;
        
        % Wait until the key is released to avoid multiple detections
        KbReleaseWait;
    end
end

% %% Recording Data
SaveTable = orderfields(Trial);
Data = struct2table(SaveTable,'AsArray',true);

if isPractice == 1
    writetable(Data,[expinfo.DataFolder,'Subject_',num2str(expinfo.subject),'_Session_',num2str(expinfo.session),'_Prac.csv']);
elseif isPractice == 2
     writetable(Data,[expinfo.DataFolder,'Subject_',num2str(expinfo.subject),'_Session_',num2str(expinfo.session),'_Base.csv']);
else
     writetable(Data,[expinfo.DataFolder,'Subject_',num2str(expinfo.subject),'_Session_',num2str(expinfo.session),'_Exp.csv']);
end


end

%% End of Function
