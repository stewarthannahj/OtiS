clear
close all

%{
If you chose to down-sample using demo_AvgSpectrum_AfterResampling.m, this
program allows you to compare the average spectrum of the original waveform
to the average spectrum of the resampled waveform.  

In general, this program will do this comparison for whatever wav files you
specify below.
%}

%% USER PARAMETERS

input1_Wavefilename = '2maleTalkerJackandtheBeanstalk_Equalized_Pt065_SSN.wav';
input2_Wavefilename = '2maleTalkerJackandtheBeanstalk_Equalized_Pt065.wav';
title_String ='SSN vs concat';

% Also, you should edit the legends below as well as the SegmentLengths.


%% PROGRAM

% Read input1 wav file
[input1 input1_Fs] = wavread(input1_Wavefilename);

% Read input2 wav file
[input2 input2_Fs] = wavread(input2_Wavefilename);

% Plot inputs
figure; plot(input1);
figure; plot(input2);

% Get NFFT1, based upon input1
num_Pts_Per_Interval_1 = length(input1);
NFFT1 = 2^nextpow2(num_Pts_Per_Interval_1);
f_Axis_Interval_1 = (input1_Fs/2)*linspace(0,1,NFFT1/2);    % go up to Fs/2

% Get NFFT2, based upon input2
num_Pts_Per_Interval_2 = length(input2);
NFFT2 = 2^nextpow2(num_Pts_Per_Interval_2);
f_Axis_Interval_2 = (input2_Fs/2)*linspace(0,1,NFFT2/2);    % go up to Fs/2

% input1 FFT
input1_FFT = fft(input1, NFFT1);
input1_FFT_Mag_dB = 20*log10(abs(input1_FFT));

% input2 FFT
input2_FFT = fft(input2, NFFT2);
input2_FFT_Mag_dB = 20*log10(abs(input2_FFT));

% Compare sum of squares for fft
m = (sum((abs(input1_FFT(1:NFFT1/2))).^2));
s = (sum((abs(input2_FFT(1:NFFT2/2))).^2));
display_String = sprintf('%s %s','Sum of squares of input1 fft coefficients, one-sided =',num2str(m));
disp(display_String);
display_String = sprintf('%s %s','Sum of squares of input2 fft coefficients, one-sided =',num2str(s));
disp(display_String);

% Plots for fft
figure; semilogx(f_Axis_Interval_1,input1_FFT_Mag_dB(1:NFFT1/2),'b'); ylabel('dB'); hold on;
        semilogx(f_Axis_Interval_2,input2_FFT_Mag_dB(1:NFFT2/2),'r'); hold off;
        legend('SSN','concat'); 
        title('Magnitude of FFT');
        
% Compare to Welch method of spectral (power) estimation
WindowName = 'Hann';
SegmentLength1 = 2048*8;
SegmentLength2 = 2048*8;
Hs1 = spectrum.welch(WindowName,SegmentLength1);
Hmss1 = msspectrum(Hs1,input1,'Fs',input1_Fs);
Hs2 = spectrum.welch(WindowName,SegmentLength2);
Hmss2 = msspectrum(Hs2,input2,'Fs',input2_Fs);

%{
% Scale the power spectrum to 50 dB
max_Index1 = round((22/22)*length(Hmss1.Frequencies));
%scale_Factor1 = (10^5)/sum(Hmss1.Data(1:max_Index));
scale_Factor1 = 1.0;
spectrum1_Scaled = scale_Factor1*Hmss1.Data;
%scale_Factor2 = (10^5)/sum(Hmss2.Data(1:max_Index));
scale_Factor2 = 1.0;
spectrum2_Scaled = scale_Factor2*Hmss2.Data;
%}
spectrum1_Scaled = Hmss1.Data;
spectrum2_Scaled = Hmss2.Data;

% Plots for Welch method
figure; semilogx(Hmss1.Frequencies/1000,10*log10(spectrum1_Scaled),'k-.','LineWidth',2.5); hold on;
        semilogx(Hmss2.Frequencies/1000,10*log10(spectrum2_Scaled),'b-'); hold off;
ylabel('Level (dB SPL)','FontSize',12,'fontweight','b');
xlabel('Frequency (kHz)','FontSize',12,'fontweight','b');
%xlim([0.05 12]);
%ylim([0 50]);
title(title_String,'FontSize',14,'fontweight','b');
legend('SSN','concat','fontweight','b');

m_Welch = sum(Hmss1.Data);
s_Welch = sum(Hmss2.Data);
display_String = sprintf('%s %s','Sum of input1 spectrum coefficients (Welch method) =',num2str(m_Welch));
disp(display_String);
display_String = sprintf('%s %s','Sum of input2 spectrum coefficients (Welch method) =',num2str(s_Welch));
disp(display_String);
