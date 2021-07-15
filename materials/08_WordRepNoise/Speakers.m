%% Play Background (switch statement) (SetUpTDT)

STIM = '2-talker';


speakerID = audiodevinfo(0,'Speakers (Realtek High Definition Audio) (Windows DirectSound)');

switch STIM
    case 'token SSN'                                                                        %%Experiment 1 and 2
        [y1, Fs1] = audioread('JackAndTheBeanStalk_Male1_SSN.wav');
        yarray1 = zeros(length(y1),2);
        yarray1(:,1) = y1;
        player = audioplayer(yarray1,Fs1,16,speakerID);
        
        [y2, Fs2] = audioread('JackAndTheBeanStalk_Male2_SSN.wav');
        yarray2 = zeros(length(y2),2);
        yarray2(:,2) = y2;
        player = audioplayer(yarray2,Fs2,16,speakerID);
        
        play(player);
        ti1 = tic;
        
        play(player);
        ti2 = tic;
        
    case '2-talker'                                                                         %%Experiment 3
        [y3, Fs3] = audioread('JackAndTheBeanStalk_Male1.wav');
        yarray3 = zeros(length(y3),2);
        yarray3(:,1) = y3;
        player3 = audioplayer(yarray3,Fs3,16,speakerID);
                           
        [y4, Fs4] = audioread('JackAndTheBeanStalk_Male2.wav');
        yarray4 = zeros(length(y4),2);
        yarray4(:,2) = y4;
        player4 = audioplayer(yarray4,Fs4,16,speakerID);
        
        play(player3);
        ti1 = tic;
        
        play(player4);
        ti2 = tic;
        
    otherwise
        error('Unknown STIM.MaskerCond');
end

while speakerID ~=3;
   pause(10);
   yarray3 = yarray3*1.5;
   player3 = audioplayer(yarray3,Fs3,16,speakerID);
   yarray4 = yarray4*1.5;
   player4 = audioplayer(yarray4,Fs4,16,speakerID);
   dt1 = toc(ti1);
   dt2 = toc(ti2);
   play(player3,round(Fs3*dt1));
   play(player4,round(Fs4*dt2));
   
end
%% Play Stimulus (LoadAndPlay)


tic
%Initialize 
[IO, STIM] = SetConstantsCommon_Boystown_Draft;
STIM.Word(1).str='act';
STIM.Word(2).str='ache';
STIM.Word(3).str='add';
STIM.Word(4).str='age';
STIM.Word(5).str='air';
STIM.Word(6).str='all';
STIM.Word(7).str='am';
STIM.Word(8).str='an';
STIM.Word(9).str='and';
STIM.Word(10).str='ant';
STIM.Word(11).str='ape';
STIM.WordOrder=randperm(length(STIM.Word));
TRACK.trialnum = 1;

% identify and load word
WordIndex=STIM.WordOrder(TRACK.trialnum);
WordPlayed=STIM.Word(WordIndex).str;
FileName=[IO.Root,IO.StimFolder,WordPlayed, '.wav'];
[y, Fs]=audioread(FileName);
y=y';
padpts=STIM.WordNumPts-length(y);
FullArray=[y,zeros(1,padpts)];

figure(5);
plot(FullArray); 
drawnow;
pause(1);

% start play-back of stimulus
speakerID = audiodevinfo(0,'Line 7/8 (M-Audio M-Track Eight) (Windows DirectSound)');  %%Find ID for speaker directly in front of the patient (Exp 1)

pause (0.5);

yarray1 = zeros(2,length(y));
yarray1(1,:) = y;
player = audioplayer(yarray1,Fs,16,speakerID);

play(player)



%% Play stimulus for experiment 2
clear
clc

speakerID = audiodevinfo(0,'Line 1/2 (M-Audio M-Track Eight) (Windows DirectSound)');
[y1, Fs1] = audioread('JackAndTheBeanStalk_Male1_SSN.wav');
yarray = zeros(length(y1),2);
yarray(:,1) = y1;
player = audioplayer(yarray,Fs1,16,speakerID);

play(player)

%% Calculate volume from booth 


speakerOD = audiodevinfo(0,'Line 5/6 (M-Audio M-Track Eight) (Windows DirectSound)');
speakerID = audiodevinfo(1,'Yeti (Yeti Stereo Microphone) (Windows DirectSound)');

[y1, Fs1] = audioread('JackAndTheBeanStalk_Male1_SSN.wav');
yarray1 = zeros(length(y1),2);
yarray1(:,1) = y1;
player = audioplayer(yarray1,Fs1,16,speakerOD);

recorder1 = audiorecorder(Fs1,16,2,speakerID);

record(recorder1)
play(player)
pause(30)
stop(recorder1)
stop(player)
r1 = getaudiodata(recorder1);

%% New Volume

TRACK.MaskerLev = input('Enter masker level between 10dB - 80dB: ');
LevScalar = (10^(TRACK.MaskerLev/20))/(10^3);
yarray1 = yarray1*LevScalar;
yarray2 = yarray2*LevScalar;

TRACK.MaskerLev = TRACK.MaskerLev+TRACK.stepsize;

SigScale = (10^(STIM.TargetSigLev/20))/(10^3);
yarray = SigScale*yarray;

%% Play Masking Speakers Continuously using DAQ Toolbox
clear
clc

TRACK.MaskerLev = input('Enter masker level between 10dB - 80dB: ');
LevScalar = (10^(TRACK.MaskerLev/20))/(10^3);

d = daq.getDevices;
s = daq.createSession('directsound');

filename1 = 'JackAndTheBeanStalk_Male1.wav';
[y1, Fs1] = audioread(filename1);
filename2 = 'JackAndTheBeanStalk_Male2.wav';
[y2] = audioread(filename2);

if length(y1)>length(y2);
    y1 = y1(1:length(y2),:);
elseif length(y1)<length(y2);
    y2 = y2(1:length(y1),:);
end

y1 = y1*LevScalar;
y2 = y2*LevScalar;
s.IsContinuous = true;
s.Rate = Fs1;
noutchan = 2;
ID = audiodevinfo(0,'Line 5/6 (M-Audio M-Track Eight) (Windows DirectSound)');
device = d(ID+1);
addAudioOutputChannel(s, device.ID, 1:noutchan);
queueOutputData(s, [y1, y2]);

lh = addlistener(s,'DataRequired', @(src,event)...
     src.queueOutputData([y1, y2]));
startBackground(s)

%% Change Signal Amplitude

correct = 0;
other = 0;

while other ~=1
   TRACK.MaskerLev = TRACK.MaskerLev+4;
   LevScalar = (10^(TRACK.MaskerLev/20))/(10^3); 
   pause(10)
   while correct~=1

filename1 = 'JackAndTheBeanStalk_Male1.wav';
[y1, Fs1] = audioread(filename1);
filename2 = 'JackAndTheBeanStalk_Male2.wav';
[y2, Fs2] = audioread(filename2);

if length(y1)>length(y2);
    y1 = y1(1:length(y2),:);
elseif length(y1)<length(y2);
    y2 = y2(1:length(y1),:);
end

y1 = y1*LevScalar;
y2 = y2*LevScalar;

ID = audiodevinfo(0,'Line 5/6 (M-Audio M-Track Eight) (Windows DirectSound)');
device = d(ID+1);

stop(s)
s = daq.createSession('directsound');
s.IsContinuous = true;
s.Rate = Fs1;
noutchan = 2;
addAudioOutputChannel(s, device.ID, 1:noutchan);

queueOutputData(s, [y1, y2]);

lh = addlistener(s,'DataRequired', @(src,event)...
     src.queueOutputData([y1, y2]));
startBackground(s)
disp(TRACK.MaskerLev);

break
end
if correct==1;
    other=1;
end
if TRACK.MaskerLev>50
    break
end
end
stop(s)
%% Play Stimulus Speaker

d = daq.getDevices;
stim = daq.createSession('directsound');

%switch condition to determine speaker ID

stim.Rate = Fs;
noutchan = 2;
ID = audiodevinfo(0,'Line 7/8 (M-Audio M-Track Eight) (Windows DirectSound)');
device = d(speakerIDStim+1);
addAudioOutputChannel(stim, device.ID, 1:noutchan);
queueOutputData(stim, [y, zeros(length(y),1)]);

%% Calibrate sound level

CL = input('Enter computer level: ');
SLM = input('Enter level displayed by sound level meter: ');

[y1, Fs1] = audioread('JackAndTheBeanStalk_Male1_SSN.wav');
yarray1 = zeros(length(y1),2);
yarray1(:,1) = y1;

N = rms(y1)/(10^(SLM/20));

ddb = input('Enter the desired sound level in dB: ');

delta = (10^(ddb/20))*N/rms(y1);

dSLM = 20*log10((rms(y1)*delta)/N);             %Check new calculated sound level.

%% Scaling information
clc

soundfiles = {'SSN1'; 'SSN2'; 'Male Talking 1';'Male Talking 2'};

[y1, Fs1] = audioread('JackAndTheBeanStalk_Male1_SSN.wav');
[y2, Fs2] = audioread('JackAndTheBeanStalk_Male2_SSN.wav');   
[y3, Fs3] = audioread('JackAndTheBeanStalk_Male1.wav');
[y4, Fs4] = audioread('JackAndTheBeanStalk_Male2.wav');   

matlablevel = [rms(y1);rms(y2);rms(y3);rms(y4)];
minimums = [min(y1);min(y2);min(y3);min(y4)];
minscale = [(-1/min(y1));(-1/min(y2));(-1/min(y3));(-1/min(y4))];
maximums = [max(y1);max(y2);max(y3);max(y4)];
maxscale = [(1/max(y1));(1/max(y2));(1/max(y3));(1/max(y4))];


T = table(matlablevel,minimums,minscale,maximums,maxscale,'RowNames',soundfiles)

scalevalue = [maxscale; minscale];
LevScalar = min(scalevalue);

fprintf('The signal cannot be scaled up by more than a factor of %0.4f .\n',LevScalar);

%% Speaker Sound Volume Calibration
clear
clc

speaker = menu('What would you like to calibrate?' ,'Experiment 1', 'Experiment 3', 'Stimulus Speaker');
speakerIDMask = audiodevinfo(0,'Line 5/6 (M-Audio M-Track Eight) (Windows DirectSound)');

if speaker == 1;
    file = menu('Which audio file would you like to use?', 'SSN', 'Man talking 1');
    
    if file == 1;
        [y1, Fs1] = audioread('JackAndTheBeanStalk_Male1_SSN.wav');                         %%Read in data for background noise file
        yarray1 = zeros(length(y1),2);                                                      
        yarray1(:,1) = y1;                                                                  %%Store background noise info in channel 1 of 2-channel array
        player1 = audioplayer(yarray1,Fs1,16,speakerIDMask);
    
        
        [y2, Fs2] = audioread('JackAndTheBeanStalk_Male2_SSN.wav');                         %%Read in data for background noise file
        yarray2 = zeros(length(y2),2);
        yarray2(:,2) = y2;                                                                  %%Store background noise info in channel 2 of 2-channel array
        player2 = audioplayer(yarray2,Fs2,16,speakerIDMask);       
        
    end
    play(player1);
    play(player2);
    %matlablevel = rms(y1);
    
elseif speaker == 2;
    file = menu('Which audio file would you like to use?', 'SSN', 'Man talking 2');
    
    if file == 1;
        [y1, Fs1] = audioread('JackAndTheBeanStalk_Male1.wav');                             %%Read in data for background noise file
        yarray1 = zeros(length(y1),2);
        yarray1(:,1) = y1;                                                                  %%Store background noise info in channel 1 of 2-channel array
        player1 = audioplayer(yarray1,Fs1,16,speakerIDMask); 
                                     %%Create audioplayer object to play noise
    
        [y2, Fs2] = audioread('JackAndTheBeanStalk_Male2.wav');                             %%Read in data for background noise file
        yarray2 = zeros(length(y2),2);
        yarray2(:,2) = y2;                                                                  %%Store background noise info in channel 2 of 2-channel array 
        player2 = audioplayer(yarray2,Fs2,16,speakerIDMask);     
    end
    play(player1);
    play(player2);
    %matlablevel = rms(y2);
    
else 
    stim = menu('For which experiment are you calibrating the stimulus?', 'Experiment 1 or 3','Experiment 2');
    STIM.Word(1).str='act';
    WordIndex = 1;
    WordPlayed=STIM.Word(WordIndex).str;
    FileName='act.wav';
    [y, Fs]=audioread(FileName);
    yarray = zeros(length(y),2);
    yarray(:,1) = y;
    
    if stim ==1;
        speakerIDStim = audiodevinfo(0,'Line 7/8 (M-Audio M-Track Eight) (Windows DirectSound)');
        
    else 
        speakerIDStim = audiodevinfo(0,'Line 1/2 (M-Audio M-Track Eight) (Windows DirectSound)');
        
    end
    
    player = audioplayer(yarray,Fs,16,speakerIDStim);

    play(player)
    
    while stim~=3;
        pause(0.5)
        play(player);
    end
    
    matlablevel = rms(y);
    
    pause(2);
    replay = 1;
    while replay == 1;
        replay = menu('Play again?','Yes','No');
    
        if replay == 1;
            play(player);
        else 
            break
        end
    
    end
    
end

%matlableveldB = 20*log10(matlablevel);

%fprintf('The matlab sound level is %0.04f as a decimal, or %0.04f dB.',matlablevel, matlableveldB);

%CL = input('Enter the computer level: ');

%LevScalar = (10^(CL/20))/matlablevel;

%test = menu('Test the scaler?', 'Yes', 'No');

%if test == 1;
    
%end
%Z:\CSRC\Dave_Moore-Project_Library-2014\Tasks\BoysTown\matlab_1speaker\',WordPlayed, '
%%
stop(player1);
stop(player2);

%%
close all

x = [30 50 70];
ySSN = [67.8 75.4 80.4];
sdSSN = 0.2*ones(1,3);
yspeech = [69 74 80];
sdspeech = 2*ones(1,3);
ywords0 = [59 67 72];
sdwords0 = 2*ones(1,3);
ywords65 = [54 64 68];
sdwords65 = 2*ones(1,3);

%plot(x,ySSN,x,yspeech,x,ywords0,x,ywords65);
figure

xlabel('Computer Level');
ylabel('Sound Level Meter Reading');
hold on
errorbar(x,ySSN,2*sdSSN);
errorbar(x,yspeech,2*sdspeech);
errorbar(x,ywords0,2*sdwords0);
errorbar(x,ywords65,2*sdwords65);

legend('SSN','Speech Masker','Front Stimulus','Left Stimulus');


%%

function [ti1,ti2] = continuousplay(player1,player2)

    if (isplaying(player1)~=1)||(isplaying(player2)~=1)
        if (isplaying(player1)~=1)
            play(player1)
            ti1 = tic;
        elseif (isplaying(player2)~=1)
            play(player2)
            ti2 = tic;
        elseif (isplaying(player1)~=1) && (isplaying(player2)~=1)
            play(player1)
            ti1 = tic;
            play(player2)
            ti2 = tic;
        end
    end

end

%%
close all
%noise = []; %Noise as an array
[y,fs] = audioread('stim_temp.wav');



%subplot(3,1,1);
freq = meanfreq(y);

%subplot(3,1,2);

fcentre = 10.^(0.1.*[12:43]);
fd = 10^0.05;
fupper = fcentre * fd;
flower = fcentre / fd;



