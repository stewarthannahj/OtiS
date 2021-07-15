% Extracts output measures from statistical learning Direct RT output (Clooney)
% Input: .csv 
% Output: .mat
% Project: OtiS 
% HJS 12th July 2018
% edited by EKC March 27th 2020
%
% MATLAB version: R2016a +
% Hannah J Stewart - h.stewart@ucl.ac.uk
% ----------------------------------------

phase = {'phase2'};             % output files for ot2_012, ot2_014, ot2_108 are empty; ot2_098 file cut short/test not completed
PIDs = {'ot2_001'; 'ot2_005'; 'ot2_007'; 'ot2_009'; 'ot2_010'; 'ot2_019'; 'ot2_021'; 'ot2_030'; 'ot2_033'; 'ot2_037'; 'ot2_040'; 'ot2_041'; 'ot2_043'; 'ot2_044'; 'ot2_046'; 'ot2_047'; 'ot2_052'; 'ot2_056'; 'ot2_067'; 'ot2_068'; 'ot2_069'; 'ot2_070'; 'ot2_072'; 'ot2_081'; 'ot2_082'; 'ot2_085'; 'ot2_092'; 'ot2_093'; 'ot2_094'; 'ot2_095'; 'ot2_096'; 'ot2_097'; 'ot2_101'; 'ot2_105'; 'ot2_106'; 'ot2_107'};

OtiS_stat = struct;
OtiS_stat.results = {};
OtiS_stat.results(1,:) = [{'PID'}, {'buttonRatio'}, {'realWordButton%'}, {'falseWordButton%'}, {'stat_totalacc'}, {'stat_totalerror'}, {'stat_poe'}, {'stat_poe_error'}, {'stat_koo'},  {'stat_koo_error'}, {'stat_rtall'}, {'stat_rtcorrect'}, {'stat_rtpoe'}, {'stat_rtkoo'}, {'stat_rtcorrectpoe'}, {'stat_rtcorrectkoo'}, {'stat_poerealacc'}, {'stat_poerealerror'}, {'stat_poefalseacc'}, {'stat_poefalseerror'}, {'stat_koorealacc'}, {'stat_koorealerror'}, {'stat_koofalseacc'}, {'stat_koofalseerror'}, {'stat_linearOrderViolationAcc'}, {'stat_linearOrderViolationError'}];

if ismac
    dataBase = '#######################'; % enter path to folder of csvs
elseif ispc
    dataBase = '#######################'; % enter path to folder of csvs 
end
for i = 1:length(PIDs)
    
        dataIndividual = [dataBase '/' phase '/' PIDs{i} '/visit2/StatLearning/' PIDs{i} '.csv'];
   
    fileName = [dataIndividual{:}];
    rawData = readtable(fileName);
    
    type = rawData.Type(6:28);         % takes variables of interest out of fiddly table format
    RT = num2cell(rawData.RT(6:28));
    correct_raw = rawData.Correct(6:28);
    correct1 = string(correct_raw);
    correct2 = upper(correct1);
    correct_final = cellstr(correct2);
    responseButton = num2cell(rawData.Resp(6:28));
    poeTrialsReal = num2cell([1;	0;	1;	0;	0;	1;	0;	0;	0;	0;	0;	0;	0;	0;	0;	1;	0;	0;	0;	1;	0;	1;	0]);     % poeX (aX = real)
    poeTrialsFalse = num2cell([0;	0;	0;	0;	0;	0;	0;	2;	2;	0;	2;	0;	0;	2;	0;	0;	0;	2;	0;	0;	2;	0;	0]); % Xpoe (Xa = false)
    kooTrialsReal = num2cell([0;	0;	0;	1;	1;	0;	1;	0;	0;	0;	0;	0;	0;	0;	0;	0;	0;	0;	1;	0;	0;	0;	1]);    % Ykoo (Yb = real)
    kooTrialsFalse = num2cell([0;	2;	0;	0;	0;	0;	0;	0;	0;	2;	0;	2;	2;	0;	2;	0;	2;	0;	0;	0;	0;	0;	0]); % kooY (bY = false)
    linearOrderViolation = num2cell([0; 1; 0; 0; 0; 0; 0; 1; 1; 1; 1; 1; 1; 1; 1; 0; 1; 1; 0; 0; 1; 0; 0]);
    poeTrial = num2cell([1; 0; 1; 0; 0; 1; 0; 1; 1; 0; 1; 0; 0; 1; 0; 1; 0; 1; 0; 1; 1; 1; 0]); %poeTrial
    kooTrial = num2cell([0; 1; 0; 1; 1; 0; 1; 0; 0; 1; 0; 1; 1; 0; 1; 0; 1; 0; 1; 0; 0; 0; 1]); %kooTrial
    analyseData = [type, poeTrialsReal, poeTrialsFalse, kooTrialsReal, kooTrialsFalse, RT, correct2, responseButton, linearOrderViolation, poeTrial, kooTrial];  % puts variables of interest into an array for rest of code

    
    for j = 1:23
    results{j,1} = (isequal(analyseData(j, 7), 'TRUE'));
    %results{j,2} = isequal(analyseData{j,2},1) && isequal(analyseData{j,7},'TRUE');  % correctly ID poeReal
    results{j,2} = (isequal(analyseData{j,2},'1') && isequal(results{j,1}, 1));
    %results{j,3} = isequal(analyseData{j,3},2) && isequal(analyseData{j,7},'TRUE');  % correctly ID poeFalse
    results{j,3} = (isequal(analyseData{j,3},'2') && isequal(results{j,1},1));
    %results{j,4} = isequal(analyseData{j,4},1) && isequal(analyseData{j,7},'TRUE');  % correctly ID kooReal
    results{j,4} = (isequal(analyseData{j,4},'1') && isequal(results{j,1},1));
    %results{j,5} = isequal(analyseData{j,5},2) && isequal(analyseData{j,7},'TRUE');  % correctly ID kooFalse
    results{j,5} = (isequal(analyseData{j,5},'2') && isequal(results{j,1},1));
    %results{j,6} = isequal(analyseData{j,9},1) && isequal(analyseData{j,7},'TRUE'); %correctly ID linearOrderViolation
    results{j,6} = (isequal(analyseData{j,9},'1') && isequal(results{j,1},1));
    results{j,7} = (analyseData{j,6});
    results{j,8} = isequal(analyseData{j,8},'1'); %realWordButton
    results{j,9} = isequal(analyseData{j,8},'2'); %falseWordButton
    results{j,10} = str2double(analyseData{j,10}); %poeTrial
    results{j,11} = str2double(analyseData{j,11}); %kooTrial
    results{j,12} = (isequal(analyseData{j,10}, '1') && isequal(analyseData(j, 7), 'TRUE')); %correct poe trial
    results{j,13} = (isequal(analyseData{j,11}, '1') && isequal(analyseData(j, 7), 'TRUE')); %correct koo trial
    end
    
    realWordButtonPercentage = (sum(cell2mat(results(:,8)))/length(results(:,1)))*100;
    falseWordButtonPercentage = (sum(cell2mat(results(:,9)))/length(results(:,1)))*100;
    
    buttonRatio = realWordButtonPercentage/falseWordButtonPercentage;
    
    poeAcc = ((sum(cell2mat(results(:,2))) + sum(cell2mat(results(:,3))))/12)*100;
    kooAcc = ((sum(cell2mat(results(:,4))) + sum(cell2mat(results(:,5))))/11)*100;
    correct = sum(cell2mat(results(:,1)))/length(results(:,1))*100;
    
    RTall = mean(str2double(results(:,7)));
    RTcorrect = mean(nonzeros((str2double(results(:,7))).*(cell2mat(results(:,1)))));
    RTpoe = mean(nonzeros((str2double(results(:,7))).*(cell2mat(results(:,10)))));
    RTkoo = mean(nonzeros((str2double(results(:,7))).*(cell2mat(results(:,11)))));
    RTcorrectpoe = mean(nonzeros((str2double(results(:,7))).*(cell2mat(results(:,12)))));
    RTcorrectkoo = mean(nonzeros((str2double(results(:,7))).*(cell2mat(results(:,13)))));
    
    poeRealAcc = (sum(cell2mat(results(:,2)))/6)*100;
    poeFalseAcc = (sum(cell2mat(results(:,3)))/6)*100;
    
    kooRealAcc = (sum(cell2mat(results(:,4)))/5)*100;
    kooFalseAcc = (sum(cell2mat(results(:,5)))/6)*100;
    
    linearOrderViolationAcc = (sum(cell2mat(results(:,6)))/12)*100;
    
    poeError = 100 - (poeAcc);
    kooError = 100 - (kooAcc);
    incorrect = 100 - (correct);
    poeRealError = 100 - (poeRealAcc);
    poeFalseError = 100 - (poeFalseAcc);
    kooRealError = 100 - (kooRealAcc);
    kooFalseError = 100 - (kooFalseAcc);
    linearOrderViolationError = 100 - (linearOrderViolationAcc);

    
    OtiS_stat.results(i+1,:) = [cellstr(PIDs{i}), buttonRatio, realWordButtonPercentage, falseWordButtonPercentage, correct, incorrect, poeAcc, poeError, kooAcc, kooError, RTall, RTcorrect, RTpoe, RTkoo, RTcorrectpoe, RTcorrectkoo, poeRealAcc, poeRealError, poeFalseAcc, poeFalseError, kooRealAcc, kooRealError, kooFalseAcc, kooFalseError, linearOrderViolationAcc, linearOrderViolationError];
    
end

save(['./OtiS_stat.mat'],'OtiS_stat');
save(['./OtiS_stat.mat'],'OtiS_stat');