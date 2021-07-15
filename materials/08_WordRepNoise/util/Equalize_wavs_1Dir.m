% This script equalizes the wav files in the input_Dir, saving to this dir
% (pwd)

clear all;
close all;
addpath('C:\projects\Common');

%% PARMS
% Specify input dir
input_Dir = 'C:\projects\PBK_HI\RajMWC_ALL_Fixed\';
% Specify output dir
output_Dir = 'C:\projects\PBK_HI\RajMWC_ALL_Fixed_Equalized\';
% Specify desired sampling rate
desired_Fs = 24414;
% Equalize to the following RMS
desired_RMS = 0.065;


%% LIST INPUT FILES
% Get a list of wav files in the input directory
file_Search_String = strcat(input_Dir,'*.wav');
dir_List = ls(file_Search_String)
[rows, cols] = size(dir_List);
num_Files = rows;
for k = 1:num_Files
    wav_File_Name = {dir_List(k,:)};
    wav_File_Name_Trimmed(k) = strtrim(wav_File_Name);
end

%% GET RMS AND LENGTH PER FILE (AT DESIRED SAMPLE RATE)
max_Length = 0;
error_Count = 0;
rms_Vals = zeros(1,num_Files);
start_Pos = zeros(1,num_Files);
for k = 1:num_Files
    try
        % Set full paths for input/output
        wav_File_Full_Path_In = strcat(input_Dir,char(wav_File_Name_Trimmed(k)));
        % read wav
        [y_In,Fs] = wavread(wav_File_Full_Path_In);
        % If the sample rate is not the same as the prior wav file, resample
        if Fs ~= desired_Fs
            display_String = sprintf('%s %s %s %s %s %s','Resampling',char(wav_File_Name_Trimmed(k)),'from',num2str(Fs),'to',num2str(desired_Fs));
            %disp(display_String);
            y_In_Resampled = resample((y_In(:,1))',desired_Fs,Fs);
        else
            y_In_Resampled = (y_In(:,1))';
        end
        % Get std
        fringe_Threshold = 0.1*median(abs(y_In_Resampled));
        [sig_Start, sig_End] = mark_Signal(y_In_Resampled, fringe_Threshold);
        std_In = std(y_In_Resampled(sig_Start:sig_End));
        rms_Vals(k) = std_In;
        start_Pos(k) = sig_Start;
        display_String = sprintf('%s\t\t %s %s %s %s\n',char(wav_File_Name_Trimmed(k)), 'RMS = ', num2str(std_In), 'LENGTH =', int2str(length(y_In_Resampled)) );
        %disp(display_String);
        % Update max length
        if length(y_In_Resampled) > max_Length
            max_Length = length(y_In_Resampled);
        end
        % Equalize and Save 
        y_In_Equalized = (desired_RMS/std_In)*y_In_Resampled;
        wav_File_Full_Path_Out = strcat(output_Dir,char(wav_File_Name_Trimmed(k)));
        wavwrite(y_In_Equalized,desired_Fs,wav_File_Full_Path_Out);
    catch err
        error_Count = error_Count + 1;
        display_String = sprintf('%s::%s','ERROR',wav_File_Name_Trimmed{k});
        disp(display_String);
        %throw(err)
    end
end
max_Length
figure; plot(rms_Vals,'bo'); title('RMS Values');
figure; plot(start_Pos,'bo'); title('Starting Positions');

error_Count



