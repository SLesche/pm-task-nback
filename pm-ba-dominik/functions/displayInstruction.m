function [last_response] = displayInstruction(expinfo, folder_path, file_pattern, allow_repeat, min_display_time)
    % displayInstruction: Displays files matching a regex pattern in order,
    % allowing navigation with optional repeat, and enforcing a global time lock.
    %
    % Parameters:
    %   expinfo: Struct with experiment display info (e.g., PTB window, keys).
    %   folder_path: Folder with instruction image files.
    %   file_pattern: Regex pattern to match relevant files.
    %   allow_repeat: (Optional) Allow backward navigation (default = 0).
    %   min_display_time: (Optional) Total minimum display time before exit (default = 0 sec).

    if ~exist('allow_repeat', 'var')
        allow_repeat = 0;
    end
    if ~exist('min_display_time', 'var')
        min_display_time = 0;
    end

    % List files matching the pattern
    files = dir(fullfile(folder_path, '*'));
    matched_files = {};
    file_numbers = [];

    last_response = 99;

    for i = 1:length(files)
        filename = files(i).name;
        match = regexp(filename, file_pattern, 'tokens');
        if ~isempty(match)
            matched_files{end+1} = fullfile(folder_path, filename); %#ok<AGROW>
            file_numbers(end+1) = str2double(matched_files{end}(end - 4)); %#ok<AGROW>
        end
    end

    if isempty(matched_files)
        warning('No files matched the provided pattern in the folder: %s', folder_path);
        return;
    end

    % Handle cases with or without numbers
    if all(isnan(file_numbers))
        if length(matched_files) > 1
            disp(file_pattern)
            error('Multiple files match the pattern but do not contain numbers. Ensure only one file matches.');
        end
        sorted_files = matched_files;
    else
        [~, sort_idx] = sort(file_numbers, 'ascend', 'ComparisonMethod', 'real');
        sorted_files = matched_files(sort_idx);
    end

    % Begin global timer
    total_start_time = GetSecs();
    current_index = 1;
    num_files = length(sorted_files);

    while current_index <= num_files
        % Display current instruction screen
        ima = imread(sorted_files{current_index});
        InstScreen = Screen('MakeTexture', expinfo.window, ima);
        Screen('DrawTexture', expinfo.window, InstScreen);
        Screen('Flip', expinfo.window);
        WaitSecs(0.2);

        % Determine navigation options
        if allow_repeat
            response = BackOrNext(expinfo, 9);  % Allow repeat key
        else
            if current_index == 1
                response = BackOrNext(expinfo, 1);  % Only forward
            else
                response = BackOrNext(expinfo, 0);  % Forward and backward
            end
        end

        % If at the last instruction and trying to move forward,
        % block until the global min_display_time is reached
        if current_index == num_files && response > 0
            elapsed = GetSecs() - total_start_time;
            remaining_time = min_display_time - elapsed;
            if remaining_time > 0
                WaitSecs(remaining_time);
            end
        end

        % Update index
        current_index = current_index + response;
    end

    last_response = response;

    % Clear screen
    clearScreen(expinfo);
    WaitSecs(0.1);
    Screen('TextSize', expinfo.window, 30);
end
