close all
fs = 24414;                         % sampling rate in Hz
SSNpts = 1000000;                     % length of SSN buffer
f_axis = fs*(1:SSNpts)/SSNpts;      % frequency axis in Hz (for plotting)
FileNames = {'2maleTalkerJackandtheBeanstalk_Equalized_Pt065.wav'};
FileLabels = {'MWC 2TM'};                     

% make window
if ~iseven(SSNpts),
    error('SSNpts must be an even number');
else
    rpts = SSNpts/2;
end;
Window = hanning(SSNpts)';          % make a hanning window.. for windowing

% compile windowed noise streams
SpchStream = zeros(length(FileNames),SSNpts);               % initialize a buffer for each stream, each SSNpts
for FileNum = 1:length(FileNames),
    [This_y,This_fs] = wavread(FileNames{FileNum});         % read each wav file
    if This_fs ~= fs,                                       % and make sure FS is the expected value
        error('unexpected sampling rate');
    end;
    ledge = 1;                                              % start at the beginning of the wav file
    while ledge < length(This_y) -rpts,                     % while more than 1/2 a window left...
        hedge = ledge + SSNpts-1;                           % the high edge of the segment is SSNpts away
        if hedge > length(This_y),                          % if there aren't enough points left in the array
            Patched_y = This_y(ledge:end);                  % take the pts you do have...
            Patched_y = [Patched_y; This_y(1:SSNpts-length(Patched_y))];    % and then "wrap", including pts from the beginning
            ThisSeg = Patched_y' .* Window;
        else
            ThisSeg = This_y(ledge:hedge)' .* Window;       % windowed segment
        end;
        plot(ThisSeg);
        drawnow;
        SpchStream(FileNum,:) = SpchStream(FileNum,:) + ThisSeg;    % and add to running total
        ledge = ledge + rpts;                                       % advance 1/2 window (leaving overlapping ramp)
    end;
    SpchStream(FileNum,:) = SpchStream(FileNum,:) * ...
        sqrt(0.5/mean(SpchStream(FileNum,:).^2));           % normalize level of each stream separately
end;

% get Magnitude spectrum of summed noise streams and make SSN
SumStreams = sum(SpchStream,1) * 10^(-3/20);    % sum equal-rms streams and scale back associated 3-dB incrase in level
Mag = abs(fft(SumStreams));                     % magnitude spectrum

nz_f = fft(randn(1,SSNpts));                    % gaussian noise in frequency domain
SSN = real(ifft(Mag.*nz_f));                    % weight by Mag and put in time domain
%SSN = SSN * sqrt(0.5/mean(SSN.^2));             % normalize rms level
SSN_Normalized_By_SBL = SSN * 0.065/std(SSN); % normalize rms level

% show spectra 
figure('position',[916   191   560   420]);  
Hs=spectrum.welch;
psd(Hs,SumStreams','Fs',fs); 
hold on; 
psd(Hs,SSN,'Fs',fs);
psd(Hs,SpchStream(1,:),'Fs',fs);

%{
p=get(gca,'children');
set(p(1),'color',[1,0,0]);
set(p(2),'color',[0,1,0]);
set(p(3),'color',[0,0,1]);
set(p(4),'color',0.4*[1,1,1],'LineWidth',2,'LineStyle',':')
%}
xlim([0,12]);
legend('sum of spch','SSN')
disp(['SSN has ',num2str(SSNpts),' points']);

% Save SSN as wav
wavwrite(SSN_Normalized_By_SBL,fs,'2maleTalkerJackandtheBeanstalk_Equalized_Pt065_SSN.wav');