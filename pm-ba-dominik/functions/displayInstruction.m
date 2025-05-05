function [last_response] = displayInstruction(expinfo, folder_path, file_pattern, allow_repeat)
    % displayInstruction: Displays files matching the regex pattern in the
    % folder_path in order of the number at the end. If no number is found, there
    % should only be one matching file.
    %
    % Parameters:
    %   expinfo: Struct containing experiment info (e.g., PTB window, keys).
    %   folder_path: Path to the folder containing instruction files.
    %   file_pattern: Regular expression pattern to match file names.

    if ~exist('allow_repeat', 'var')
        allow_repeat = 0;
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
        sorted_files = matched_files; % Single file without a number
    else
        % Sort files based on the extracted numbers (ignoring NaN)
        [~, sort_idx] = sort(file_numbers, 'ascend', 'ComparisonMethod', 'real');
        sorted_files = matched_files(sort_idx);
    end

    % Display matched files in order
    current_index = 1;
    num_files = length(sorted_files);

    while current_index <= num_files
        % Read and display the current file
        ima = imread(sorted_files{current_index});
        InstScreen = Screen('MakeTexture', expinfo.window, ima);
        Screen('DrawTexture', expinfo.window, InstScreen);
        Screen('Flip', expinfo.window);

        WaitSecs(0.2);

        % Determine navigation options based on position
        if allow_repeat
            response = BackOrNext(expinfo, 9); % Allow repeat key
        else
            if current_index == 1
                response = BackOrNext(expinfo, 1); % Only allow forward
            else
                response = BackOrNext(expinfo, 0); % Allow both forward and backward
            end
        end

        % Update current index based on response
        current_index = current_index + response;

    end
    last_response = response;

    % Clear screen at the end
    clearScreen(expinfo);
    
    WaitSecs(0.1);
    
    Screen('TextSize', expinfo.window, 30);
end
