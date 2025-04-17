function expinfo = WriteDataFile(expinfo, expBlock)
expinfo.DataFolder      = 'DataFiles/';

%% datafiles and messages
pracFile = 'prac.txt'; % extension for the practice trial data
expFile  = 'exp.txt';  % extension fot the expreimental trial data

% Adjusting the file-names to a different name for each subject

expinfo.pracFile = [expinfo.DataFolder,expinfo.taskName,'N-Back-Task_S',num2str(expinfo.subject),'_Ses',num2str(expinfo.session),'_Block_',num2str(expBlock),pracFile];
expinfo.expFile  = [expinfo.DataFolder,expinfo.taskName,'N-Back-Task_S',num2str(expinfo.subject),'_Ses',num2str(expinfo.session),'_Block_',num2str(expBlock),expFile];
end