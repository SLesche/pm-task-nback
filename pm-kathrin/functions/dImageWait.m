% This is a generic functions that shows a predefined image (ima) and waits
% for a key press. As soon as any key on the keyboard is pressed, the
% screen is cleared.

function dImageWait(expinfo, ima)
InstScreen = Screen('MakeTexture',expinfo.window,ima);
Screen('DrawTexture', expinfo.window, InstScreen); % draw the scene
Screen('Flip', expinfo.window);

validKey = 0; % Logical variable indicaating whether a valid key was pressed.
while validKey == 0
    [keyIsDown,~,keyCode] = KbCheck; % Read keyboard

    if keyIsDown % As soon as a key is pressed check whether it is a valid key
        pressedKey = KbName(keyCode); % Get key name for pressed key

        if strcmp(pressedKey,expinfo.StartKey) % start key press
            % Options = 1 only allow to move foraward
            validKey = 1;
        elseif strcmp(pressedKey,expinfo.AbortKey) % Abort experiment
            % Close PTB window and abort the experiment
            closeexp(expinfo.window);
        end
    end
end                %wait for any key
clearScreen(expinfo);
end

%% End of Function
