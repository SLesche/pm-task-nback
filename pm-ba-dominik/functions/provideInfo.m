function [expinfo] = provideInfo(TaskName,vars)

    expinfo.taskName = TaskName;
    
    %% Eingabeaufforderungen (German prompts)
    prompt_subID         = 'Bitte geben Sie die Versuchspersonennummer ein (ganze Zahl):';
    prompt_practice      = 'Übungsdurchgänge durchführen? (1 = ja, 0 = nein):';
    prompt_age           = 'Bitte geben Sie ihr Alter ein (in Jahren):';
    prompt_gender        = 'Welchem Geschlecht fühlen Sie sich zugehörig (m, w, d, keine Angabe):';
    prompt_student       = 'Sind Sie Student*in? (1 = ja, 0 = nein):';
    prompt_psychology    = 'Studieren Sie Psychologie? (1 = ja, 0 = nein):';
    
    % Definieren der möglichen Variablen
    all_vars = {'sub','prac','age','gender','student','psy'};
    if strcmp(vars,'all')
        use = true(size(all_vars));
    else
        use = ismember(all_vars,vars);
    end
    pos_use = find(use);
    
    % Auswahl der Prompts
    prompt_all = {prompt_subID;prompt_practice;prompt_age;prompt_gender; ...
                  prompt_student;prompt_psychology};
    prompt_select = prompt_all(use);
    prompt_answer = inputdlg(prompt_select,expinfo.taskName);
    
    if isempty(prompt_answer)
        error('Keine Eingabe erhalten. Bitte neu starten und Informationen eingeben.')
    end
    
    %% Speichern der Antworten mit Standardwerten
    if use(1) && ~isempty(prompt_answer{pos_use == 1})
        expinfo.subject = str2double(prompt_answer{pos_use == 1});
    else
        expinfo.subject = 999;
    end
    
    if use(2) && ~isempty(prompt_answer{pos_use == 2})
        expinfo.showPractice = logical(str2double(prompt_answer{pos_use == 2}));
    else
        expinfo.showPractice = true;
    end
    
    if use(3) && ~isempty(prompt_answer{pos_use == 3})
        expinfo.subjectAge = str2double(prompt_answer{pos_use == 3});
    else
        expinfo.subjectAge = NaN;
    end
    
    if use(4) && ~isempty(prompt_answer{pos_use == 4})
        expinfo.subjectGender = prompt_answer{pos_use == 4};
    else
        expinfo.subjectGender = '';
    end
    
    if use(5) && ~isempty(prompt_answer{pos_use == 5})
        expinfo.isStudent = logical(str2double(prompt_answer{pos_use == 5}));
    else
        expinfo.isStudent = false;
    end
    
    if use(6) && ~isempty(prompt_answer{pos_use == 6})
        expinfo.studiesPsychology = logical(str2double(prompt_answer{pos_use == 6}));
    else
        expinfo.studiesPsychology = false;
    end
    
    end
    