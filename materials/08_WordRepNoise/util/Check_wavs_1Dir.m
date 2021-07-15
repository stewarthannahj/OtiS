% This script gives info on the wav files in the aud dir i.e. the RMS

clear;
close all;
addpath('C:\projects\Common');

%% PARMS
% Specify input dir
%input_Dir = 'C:\projects\MWC\RajMWC_ALL_Fixed_Equalized\';
input_Dir = 'C:\projects\MWC\';
% Specify desired sampling rate
desired_Fs = 24414;



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
rms_Vals = zeros(1,num_Files);
start_Pos = zeros(1,num_Files);
for k = 1:num_Files
    % Set full paths for input/output
    wav_File_Full_Path_In = strcat(input_Dir,char(wav_File_Name_Trimmed(k)));
    % read wav
    [y_In,Fs] = wavread(wav_File_Full_Path_In);
    max(abs(y_In))
    % If the sample rate is not the same as the prior wav file, resample
    if Fs ~= desired_Fs
        display_String = sprintf('%s %s %s %s %s %s','Resampling',char(wav_File_Name_Trimmed(k)),'from',num2str(Fs),'to',num2str(desired_Fs));
        disp(display_String);
        y_In_Resampled = resample(y_In',desired_Fs,Fs);
    else
        y_In_Resampled = y_In';
    end
    % Report RMS and length
    fringe_Threshold = 0.1*median(abs(y_In_Resampled))
    [sig_Start, sig_End] = mark_Signal(y_In_Resampled, fringe_Threshold);
    std_In = std(y_In_Resampled(sig_Start:sig_End));
    rms_Vals(k) = std_In;
    start_Pos(k) = sig_Start;
    display_String = sprintf('%s\t\t %s %s %s %s\n',char(wav_File_Name_Trimmed(k)), 'RMS = ', num2str(std_In), 'LENGTH =', int2str(length(y_In_Resampled)) );
    disp(display_String);
    % Update max length
    if length(y_In) > max_Length
        max_Length = length(y_In_Resampled);
    end
    %figure; plot(y_In);
end
max_Length
figure; plot(rms_Vals,'bo'); title('RMS Values');
figure; plot(start_Pos,'bo'); title('Starting Positions');





