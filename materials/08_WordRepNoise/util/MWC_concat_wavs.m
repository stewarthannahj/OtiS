% This script gives info on the wav files in the aud dir i.e. the RMS

clear;
close all;

%% PARMS
% Specify desired sampling rate
desired_Fs = 24414;
% Detect real start of signal
fringe_Threshold = 0.002;
% Desired STD
desired_STD = 0.065;


%% GET RMS AND LENGTH PER FILE (AT DESIRED SAMPLE RATE)
max_Length = 0;
rms_Vals = zeros(1,400);
start_Pos = zeros(1,400);
index = 1;
wav_Cat = [];
for list_Num = 1:1
    input_Dir = 'C:\projects\PBK_HI\RajMWC_ALL_Fixed_Equalized\';
    % Get a list of wav files in the input directory
    file_Search_String = strcat(input_Dir,'*.wav');
    dir_List = ls(file_Search_String)
    [rows, cols] = size(dir_List);
    num_Files = rows;
    for k = 1:num_Files
        wav_File_Name = {dir_List(k,:)};
        wav_File_Name_Trimmed(k) = strtrim(wav_File_Name);
    end

    for k = 1:100
        % Set full paths for input/output
        wav_File_Full_Path_In = strcat(input_Dir,char(wav_File_Name_Trimmed(k)));
        % read wav
        [y_In,Fs] = wavread(wav_File_Full_Path_In);
        max(abs(y_In))
        % If the sample rate is not the same as the prior wav file, resample
        if Fs ~= desired_Fs
            display_String = sprintf('%s %s %s %s %s %s','Resampling',char(wav_File_Name_Trimmed(k)),'from',num2str(Fs),'to',num2str(desired_Fs));
            disp(display_String);
            y_In = resample(y_In,desired_Fs,Fs);
        end
        % Plot
        %figure; plot(y_In);
        % Report RMS and length
        [rows,cols] = size(y_In);
        if cols > 1
            [sig_Start, sig_End] = mark_Signal(y_In(:,1), fringe_Threshold);
            std_In = std(y_In(sig_Start:sig_End,1));
            rms_Vals(index) = std_In;
            display_String = sprintf('%s\t\t %s %s %s %s\n',char(wav_File_Name_Trimmed(k)), 'has 2 channels, looking only at ch 1' );
            disp(display_String);
        else
            [sig_Start, sig_End] = mark_Signal(y_In, fringe_Threshold);
            std_In = std(y_In(sig_Start:sig_End));
            rms_Vals(index) = std_In;
        end
        start_Pos(index) = sig_Start;
        display_String = sprintf('%s\t\t %s %s %s %s\n',char(wav_File_Name_Trimmed(k)), 'RMS = ', num2str(std_In), 'LENGTH =', int2str(length(y_In)) );
        disp(display_String);
        % Update max length
        if length(y_In) > max_Length
            max_Length = length(y_In);
        end
        % Equalize
        y_Out = (desired_STD/std_In)*y_In(sig_Start:sig_End,1);
        % Concat
        wav_Cat = [wav_Cat y_In']; 
        % Increment index
        index = index + 1;
    end
end
max_Length
figure; plot(rms_Vals,'bo'); title('RMS Values');
figure; plot(start_Pos,'bo'); title('Starting Positions');

% SCale again
wav_Cat_Scaled = (desired_STD/(std(wav_Cat)))*wav_Cat;
wav_Cat_Full_Path = 'MWC_Concatenated.wav';
wavwrite(wav_Cat_Scaled, desired_Fs, wav_Cat_Full_Path);

figure; plot(wav_Cat_Scaled)





