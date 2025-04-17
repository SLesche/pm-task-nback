
function [string] = get_PM_words(expinfo,x,y, color)

Screen(expinfo.window,'TextSize',15)
Screen('DrawText', expinfo.window, 'Wir möchten prüfen, ob Sie die Instruktionen verstanden haben', x, y, color);
Screen('DrawText', expinfo.window, 'Bitte geben Sie im Folgenden ein, bei welchen W�rtern Sie F1 dr�cken sollen.', x, y + 30, color); % Adjust y position for the next line

[string] = GetEchoString(expinfo.window, 'Bitte geben Sie Ihre Antwort �ber die Tastur ein:',x, y+60, color, expinfo.Colors.bgColor);

Screen(expinfo.window,'TextSize',40)

end

