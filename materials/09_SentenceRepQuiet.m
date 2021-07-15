% Extracts output measures from Sentences in Quiet task presented by www.sentencerepetition.com
% Input: .xlsx
% Output: .mat
% Project: OtiS 
% HJS 16th July 2018
%
% MATLAB version: R2016a +
% Hannah J Stewart - h.stewart@ucl.ac.uk
% ----------------------------------------

phase = {'phase2'};             
visit = {'visit2'};                     
PIDs = {'ot2_005'}; %{'ot2_001'; 'ot2_007'; 'ot2_009'; 'ot2_010'; 'ot2_012'; 'ot2_014'; 'ot2_019'; 'ot2_021'; 'ot2_030'; 'ot2_037'; 'ot2_040'; 'ot2_041'; 'ot2_043'; 'ot2_044'; 'ot2_046'; 'ot2_047'; 'ot2_052'; 'ot2_056'; 'ot2_067'; 'ot2_068'; 'ot2_069'; 'ot2_070'; 'ot2_072'; 'ot2_081'; 'ot2_082'; 'ot2_085'; 'ot2_092'; 'ot2_093'; 'ot2_094'; 'ot2_095'; 'ot2_096'; 'ot2_097'; 'ot2_098'; 'ot2_101'; 'ot2_105'; 'ot2_106'; 'ot2_107'; 'ot2_108'}
restOfFileName = {'ot2_005_Post_20200707'}; %{'ot2_001_Pre_20200722';  'ot2_007_Pre_20190206'; 'ot2_009_Pre_20190213'; 'ot2_010_Pre_20190226'; 'ot2_012_Pre_20190621'; 'ot2_014_Pre_20190824'; 'ot2_019_Pre_20190203'; 'ot2_021_Pre_20190222'; 'ot2_030_Pre_20190129'; 'ot2_037_Pre_20190330'; 'ot2_040_Pre_20190320'; 'ot2_041_Pre_20190320'; 'ot2_043_Pre_20190419'; 'ot2_044_Pre_20190213'; 'ot2_046_Pre_20190116'; 'ot2_047_Pre_20190223'; 'ot2_052_Pre_20190105'; 'ot2_056_Pre_20190410'; 'ot2_067_Pre_20190311'; 'ot2_068_Pre_20190202'; 'ot2_069_Pre_20190223'; 'ot2_070_Pre_20190427'; 'ot2_072_Pre_20190204'; 'ot2_081_Pre_20190305'; 'ot2_082_Pre_20190126'; 'ot2_085_Pre_20190430'; 'ot2_092_Pre_20190423'; 'ot2_093_Pre_20190319'; 'ot2_094_Pre_20190413'; 'ot2_095_Pre_20190531'; 'ot2_096_Pre_20190423'; 'ot2_097_Pre_20190420'; 'ot2_098_Pre_20190508'; 'ot2_101_Pre_20190518'; 'ot2_105_Pre_20191213'; 'ot2_106_Pre_20191213'; 'ot2_107_Pre_20191213'; 'ot2_108_Pre_20191012'}; 

eventName = {'retest_visit_arm_1'};

OtiS_SentQ = struct;
OtiS_SentQ.Visit1results = {};
OtiS_SentQ.Visit2results = {};
OtiS_SentQ.Visit1results(1,:) = [{'record_id'}, {'redcap_event_name'}, {'cnvm_correcttotal'}, {'cnvm_shortlow'}, {'cnvm_shorthigh'}, {'cnvm_longlow'}, {'cnvm_longhigh'}, {'cnvm_content'}, {'cnvm_function'}, {'cnvm_verb'}];
OtiS_SentQ.Visit2results(1,:) = [{'record_id'}, {'redcap_event_name'}, {'cnvm_correcttotal'}, {'cnvm_shortlow'}, {'cnvm_shorthigh'}, {'cnvm_longlow'}, {'cnvm_longhigh'}, {'cnvm_content'}, {'cnvm_function'}, {'cnvm_verb'}];

if ismac
    dataBase = '#######################'; % enter path to folder of xlsx files
elseif ispc
    dataBase = '#######################'; % enter path to folder of xlsx files
end
for i = 1:length(PIDs)
    
    shortLowSum = 0;
    shortHighSum = 0;
    longLowSum = 0;
    longHighSum = 0;
    shortLowMax = 0;
    shortHighMax = 0;
    longLowMax = 0;
    longHighMax = 0;
    
    if ismac
        dataIndividual = ['/' phase '/' PIDs{i} '/' visit '/SentQ/' restOfFileName{i} '.xlsx'];
    elseif ispc
        dataIndividual = ['\' phase '\' PIDs{i} '\' visit '\SentQ\' restOfFileName{i} '.xlsx'];
    end
    
    dataFile = [dataIndividual{:}];
    fileName = fullfile(dataBase, dataFile);
    rawData = (readtable(fileName));
    
    sentenceID = ((rawData.Var2(18:33)));             % takes variables of interest out of fiddly table format
    totalScore = str2double((rawData.Var17(18:33)));    
    maxScore = str2double((rawData.Var18(18:33)));
    shortLow = str2num(cell2mat((rawData.Var19(18:33)))); 
    shortHigh = str2num(cell2mat((rawData.Var20(18:33)))); 
    longLow = str2num(cell2mat((rawData.Var21(18:33)))); 
    longHigh = str2num(cell2mat((rawData.Var22(18:33)))); 
    contentWords = str2num(cell2mat((rawData.Var9(18:33)))); 
    functionWords = str2num(cell2mat((rawData.Var14(18:33)))); 
    verbWords = str2num(cell2mat((rawData.Var16(18:33)))); 

    analyseData = [totalScore, maxScore, shortLow, shortHigh, longLow, longHigh, contentWords, functionWords, verbWords];       % puts variables of interest into an array for rest of code
    
    grandScore = (sum(analyseData(:, 1))/160)*100;      % was 200
    contentScore = (sum(analyseData(:, 7))/96)*100;    % was 120
    functionScore = (sum(analyseData(:, 8))/64)*100;    % was 78
    verbScore = (sum(analyseData(:, 9))/18)*100;        % was 30 CNvM to confirm new value
    
    shortLow_list = {'Pre 1', 'Pre 2', 'Pre 3', 'Pre 4', 'Pre 5', 'Post 1', 'Post 2', 'Post 3', 'Post 5'};
    shortHigh_list = {'Pre 6', 'Pre 7', 'Pre 8', 'Pre 9', 'Pre 10', 'Post 6', 'Post 7', 'Post 8', 'Post 10'};
    longLow_list = {'Pre 11', 'Pre 12', 'Pre 13', 'Pre 14', 'Pre 15', 'Post 11', 'Post 12', 'Post 13', 'Post 15'};
    longHigh_list = {'Pre 16', 'Pre 17', 'Pre 18', 'Pre 19', 'Pre 20', 'Post 16', 'Post 17', 'Post 18', 'Post 20'};    
    
    for j = 1:16
        % one mark for each word correct, to then work out % correct for that sentence type - confirmed by Moll
        if (sum(strcmp(sentenceID(j),shortLow_list))>=1)
            shortLowSum = shortLowSum + analyseData(j,1);
            shortLowMax = shortLowMax + analyseData(j,2);
        else if (sum(strcmp(sentenceID(j),shortHigh_list))>=1)
                shortHighSum = shortHighSum + analyseData(j,1);
                shortHighMax = shortHighMax + analyseData(j,2);
            else if (sum(strcmp(sentenceID(j),longLow_list))>=1)
                    longLowSum = longLowSum + analyseData(j,1);
                    longLowMax = longLowMax + analyseData(j,2);
                else
                    longHighSum = longHighSum + analyseData(j,1);
                    longHighMax = longHighMax + analyseData(j,2);
                end
            end
        end
        
        %     % one mark for each sentence that is 100% correct - Moll says this is wrong
        %     results{j,1} = isequal(analyseData(j,1),analyseData(j,2)) && (sum(strcmp(sentenceID(j),shortLow_list))>=1);  % correctly ID DSHL sentence = short/low complex
        %     results{j,2} = isequal(analyseData(j,1),analyseData(j,2)) && (sum(strcmp(sentenceID(j),shortHigh_list))>=1);  % correctly ID DSHH sentence = short/high complex
        %     results{j,3} = isequal(analyseData(j,1),analyseData(j,2)) && (sum(strcmp(sentenceID(j),longLow_list))>=1);  % correctly ID DLL sentence = long/low complex
        %     results{j,4} = isequal(analyseData(j,1),analyseData(j,2)) && (sum(strcmp(sentenceID(j),longHigh_list))>=1);  % correctly ID DLH sentence = long/high complex
    end
    
    shortLow_score = (shortLowSum/shortLowMax)*100;
    shortHigh_score = (shortHighSum/shortHighMax)*100;
    longLow_score = (longLowSum/longLowMax)*100;
    longHigh_score = (longHighSum/longHighMax)*100;
    
    %     % one mark for each sentence that is 100% correct - Moll says this is wrong
    %     shortLow_score = sum(cell2mat(results(:,1))/5)*100;
    %     shortHigh_score = sum(cell2mat(results(:,2))/5)*100;
    %     longLow_score = sum(cell2mat(results(:,3))/5)*100;
    %     longHigh_score = sum(cell2mat(results(:,4))/5)*100;
    
    OtiS_SentQ.Visit1results(i+1,:) = [cellstr(restOfFileName{i}), eventName, grandScore, shortLow_score, shortHigh_score, longLow_score, longHigh_score, contentScore, functionScore, verbScore];
    
end

% % no data from ot_030 for post as did pre again by accident
% visit_v2 = {'visit2'};         
% PIDs_v2 = {'ot_001'; 'ot_002'; 'ot_003'; 'ot_005'; 'ot_008'; 'ot_014'; 'ot_018'; 'ot_027'; 'ot_036'; 'ot_039'; 'ot_041'; 'ot_044'};
% restOfFileName_v2 = {'ot_001_Post_20180922_16sent'; 'ot_002_Post_20180717_16sent'; 'ot_003_Post_20180726_16sent'; 'ot_005_Post_20180803_16sent'; 'ot_008_Post_20180824_16sent'; 'ot_014_Post_20180824_16sent'; 'ot_018_Post_20180831_16sent'; 'ot_027_Post_20180825_16sent'; 'ot_036_Post_20180810_16sent'; 'ot_039_Post_20180827_16sent'; 'ot_041_Post_20180823_16sent'; 'ot_044_Post_20180724_16sent'}; 
% 
% eventName_v2 = {'retest_visit_arm_1'};
% 
% for m = 1:length(PIDs_v2)
%     
%     shortLowSum_v2 = 0;
%     shortHighSum_v2 = 0;
%     longLowSum_v2 = 0;
%     longHighSum_v2 = 0;
%     shortLowMax_v2 = 0;
%     shortHighMax_v2 = 0;
%     longLowMax_v2 = 0;
%     longHighMax_v2 = 0;
%     
%     if ismac
%         dataIndividual_v2 = ['/' phase '/' PIDs_v2{m} '/' visit_v2 '/SentQ/' restOfFileName_v2{m} '.xlsx'];
%     elseif ispc
%         dataIndividual_v2 = ['\' phase '\' PID{m} '\' visit_v2 '\SentQ\' restOfFileName_v2{m} '.xlsx'];
%     end
%     
%     dataFile_v2 = [dataIndividual_v2{:}];
%     fileName_v2 = fullfile(dataBase, dataFile_v2);
%     rawData_v2 = readtable(fileName_v2);
%     
%     sentenceID_v2 = ((rawData_v2.Var2(18:33)));             % takes variables of interest out of fiddly table format
%     totalScore_v2 = str2double((rawData_v2.Var17(18:33)));    
%     maxScore_v2 = str2double((rawData_v2.Var18(18:33)));
%     shortLow_v2 = str2num(cell2mat((rawData_v2.Var19(18:33)))); 
%     shortHigh_v2 = str2num(cell2mat((rawData_v2.Var20(18:33)))); 
%     longLow_v2 = str2num(cell2mat((rawData_v2.Var21(18:33)))); 
%     longHigh_v2 = str2num(cell2mat((rawData_v2.Var22(18:33)))); 
%     contentWords_v2 = str2num(cell2mat((rawData_v2.Var9(18:33)))); 
%     functionWords_v2 = str2num(cell2mat((rawData_v2.Var14(18:33)))); 
%     verbWords_v2 = str2num(cell2mat((rawData_v2.Var16(18:33)))); 
% 
%     analyseData_v2 = [totalScore_v2, maxScore_v2, shortLow_v2, shortHigh_v2, longLow_v2, longHigh_v2, contentWords_v2, functionWords_v2, verbWords_v2];       % puts variables of interest into an array for rest of code
%     
%     grandScore_v2 = (sum(analyseData_v2(:, 1))/160)*100;    % was 200
%     contentScore_v2 = (sum(analyseData_v2(:, 7))/96)*100;  % was 120
%     functionScore_v2 = (sum(analyseData_v2(:, 8))/64)*100;  % was 78
%     verbScore_v2 = (sum(analyseData_v2(:, 9))/18)*100;      % was 30 CNvM to confirm new value
%     
%     shortLow_list_v2 = {'Pre 1', 'Pre 2', 'Pre 3', 'Pre 4', 'Pre 5', 'Post 1', 'Post 2', 'Post 3', 'Post 5'};
%     shortHigh_list_v2 = {'Pre 6', 'Pre 7', 'Pre 8', 'Pre 9', 'Pre 10', 'Post 6', 'Post 7', 'Post 8', 'Post 10'};
%     longLow_list_v2 = {'Pre 11', 'Pre 12', 'Pre 13', 'Pre 14', 'Pre 15', 'Post 11', 'Post 12', 'Post 13', 'Post 15'};
%     longHigh_list_v2 = {'Pre 16', 'Pre 17', 'Pre 18', 'Pre 19', 'Pre 20', 'Post 16', 'Post 17', 'Post 18', 'Post 20'};    
%     
%     for k = 1:16
%         % one mark for each word correct, to then work out % correct for that sentence type - confirmed by Moll
%         if (sum(strcmp(sentenceID_v2(k),shortLow_list_v2))>=1)
%             shortLowSum_v2 = shortLowSum_v2 + analyseData_v2(k,1);
%             shortLowMax_v2 = shortLowMax_v2 + analyseData_v2(k,2);
%         else if (sum(strcmp(sentenceID_v2(k),shortHigh_list_v2))>=1)
%                 shortHighSum_v2 = shortHighSum_v2 + analyseData_v2(k,1);
%                 shortHighMax_v2 = shortHighMax_v2 + analyseData_v2(k,2);
%             else if (sum(strcmp(sentenceID_v2(k),longLow_list_v2))>=1)
%                     longLowSum_v2 = longLowSum_v2 + analyseData_v2(k,1);
%                     longLowMax_v2 = longLowMax_v2 + analyseData_v2(k,2);
%                 else
%                     longHighSum_v2 = longHighSum_v2 + analyseData_v2(k,1);
%                     longHighMax_v2 = longHighMax_v2 + analyseData_v2(k,2);
%                 end
%             end
%         end
%         
%         %     % one mark for each sentence that is 100% correct - Moll says this is wrong
%         %     results{j,1} = isequal(analyseData(j,1),analyseData(j,2)) && (sum(strcmp(sentenceID(j),shortLow_list))>=1);  % correctly ID DSHL sentence = short/low complex
%         %     results{j,2} = isequal(analyseData(j,1),analyseData(j,2)) && (sum(strcmp(sentenceID(j),shortHigh_list))>=1);  % correctly ID DSHH sentence = short/high complex
%         %     results{j,3} = isequal(analyseData(j,1),analyseData(j,2)) && (sum(strcmp(sentenceID(j),longLow_list))>=1);  % correctly ID DLL sentence = long/low complex
%         %     results{j,4} = isequal(analyseData(j,1),analyseData(j,2)) && (sum(strcmp(sentenceID(j),longHigh_list))>=1);  % correctly ID DLH sentence = long/high complex
%     end
%     
%     shortLow_score_v2 = (shortLowSum_v2/shortLowMax_v2)*100;
%     shortHigh_score_v2 = (shortHighSum_v2/shortHighMax_v2)*100;
%     longLow_score_v2 = (longLowSum_v2/longLowMax_v2)*100;
%     longHigh_score_v2 = (longHighSum_v2/longHighMax_v2)*100;
%     
%     %     % one mark for each sentence that is 100% correct - Moll says this is wrong
%     %     shortLow_score = sum(cell2mat(results(:,1))/5)*100;
%     %     shortHigh_score = sum(cell2mat(results(:,2))/5)*100;
%     %     longLow_score = sum(cell2mat(results(:,3))/5)*100;
%     %     longHigh_score = sum(cell2mat(results(:,4))/5)*100;
%     
%     OtiS_SentQ.Visit2results(m+1,:) = [cellstr(restOfFileName_v2{m}), eventName_v2, grandScore_v2, shortLow_score_v2, shortHigh_score_v2, longLow_score_v2, longHigh_score_v2, contentScore_v2, functionScore_v2, verbScore_v2];
%     
% end

save(['./OtiS_SentQ.mat'],'OtiS_SentQ');
save(['./OtiS_SentQ.mat'],'OtiS_SentQ');