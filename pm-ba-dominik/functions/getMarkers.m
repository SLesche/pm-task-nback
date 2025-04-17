function [expinfo] = getMarkers(expinfo, isPractice, expBlock)
% This is a function that specifies EEG Markers for the experiment and
% saves them into the expinfo object, so that Markers can be accessed
% during the Experiment without any further computational load.

%% Specify Block Markers for Experiment

    Marker.MatlabStart = 114;
    Marker.PracStart = 211;
    Marker.PracEnd = 212;
    Marker.ExpStart = 8;
    Marker.ExpEnd = 9;

%% Specify Stimulus Markers within each trial
% Markers for different Screens
if isPractice == 1
    Marker.Fixation = 0;
    Marker.ISI = zeros(2,1);
    Marker.Stimulus = zeros(2,1);
    Marker.CorrResp_D = 0;
    Marker.CorrResp_L = 0;
    Marker.IncorrResp = 0;
    Marker.IncorrResp_D = 0;
    Marker.IncorrResp_L = 0;
    Marker.Block = zeros(1,2);
    Marker.Miss = 0;
    Marker.Zero = 0;
else
    Marker.Zero = 0;
    Marker.ISI =  zeros(2,1);
    Marker.Stimulus = zeros(2,1);
    Marker.Fixation = 30; 
    
    if expBlock == 1
        for i = expinfo.Match
            Marker.ISI(i) = 40+(i);
            Marker.Stimulus(i) = 50+(i); % 1 = Match , 2 = NoMatch
        end
    elseif expBlock == 2
        for i = expinfo.Match
            Marker.ISI(i) = 42+(i);
            Marker.Stimulus(i) = 52+(i); % 1 = Match , 2 = NoMatch
        end
    else
        for i = expinfo.Match
            Marker.ISI(i) = 44+(i);
            Marker.Stimulus(i) = 54+(i); % 1 = Match , 2 = NoMatch
        end
    end
    
    Marker.CorrResp_D = 150;
    Marker.CorrResp_L = 160;
    Marker.IncorrResp = 251;
    Marker.IncorrResp_D = 250;
    Marker.IncorrResp_L = 255;
    Marker.Block = zeros(1,2);

    Marker.Block(1,1) = 100 + expBlock;
    Marker.Block(1,2) = 200 + expBlock ;

    Marker.Miss = 222;
end
%% Write Markers into expinfo object
expinfo.Marker = Marker;
end
%% End of Function
% This function was programmed by Christoph Löffler based on a template by Gidon T. Frischkorn, as part of a
% template for MATLAB experiments. If you have any questions please contact
% me via mail: christoph.loeffler@psychologie.uni-heidelberg.de
