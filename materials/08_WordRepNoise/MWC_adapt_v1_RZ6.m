% function MWC_adapt_v7_RZ6
% 
% Based on the STU_adapt_PBKMasker_V2 adaptive file: Temporal uncertainty program, adaptive track.  
% Track follows a 1-down, 1-up. 

%SCRIPT For the harry potter 2-talker masker conditions uses the MWC
%monosyllabic target words; in the carrier-absent condition
%
% Orignal Created by AB&EB 6/10/11
% Modified by AYB 5/31/12; 3/2/13

% 20160527
%{
Created MWC_adapt_v1 from PBKHI_adapt_v7. Then, changed stimuli. 
%}
%LJL changed attenuator setting and recalibrated on 7/25/16


function MWC_adapt_v1_RZ6

clear										% clears all variables

[IO,STIM]=SetConstants;             % sets all constants
addpath('C:\projects\Common');
InitalizeAndInstruct(IO);
[STIM]=PossibleWords(STIM);         % lists each word
STIM.WordOrder=randperm(length(STIM.Word));      %randomized array from 1:max number of words

TRACK=InitializeTrack;

[ObsName,TRACK,STIM,IO]=GetRunInfo(STIM,TRACK,IO);

IO=SetUpTDT(IO,STIM,TRACK);                % set up tdt hardware w/ those variables
PLOT=SetUpTrackPlot;				% make figure for monitoring track
pause(0.5);
while not(TRACK.EndTrack),
    TRACK.trialnum=TRACK.trialnum+1;
    LevScalar=10^((TRACK.MaskerLev-STIM.MaxMaskerLev)/20)	% compute tone amplitude
    TRACK.AllLevel=[TRACK.AllLevel,TRACK.MaskerLev]; 	% keep track of levels
    invoke(IO.r,'SetTagVal','MskAmp',LevScalar);	% set amp in RPvds
    StatusStr=[num2str(TRACK.MaskerLev),'  ',num2str(TRACK.ReversalCount)];
    set(1,'name',StatusStr);
    UpDateTrackPlot(PLOT,TRACK);  % update display of where the track is
   
    disp('ready to start trial');
    pause;                          % hang for carriage return
    %WaitForButton(IO);
    TRACK=LoadAndPlay(STIM,TRACK,IO);
    [Resp,RespRight]=GetResp(TRACK);        % get observer response
    [TRACK,IO]=RespEval(IO,TRACK,Resp,RespRight);	% assess resp. & adjust signal lev
end;

% WRAP UP
ComputeAndReport(ObsName,STIM,TRACK,IO);	% compute and report results
pause(0.5);
invoke(IO.r,'Halt');									% stops the .RCO (compiled rpvds)
close all;												% closes the figure window (housekeeping)

%------------------------------------------------------------------%
% InitalizeAndInstruct: Initalize and reseed the number generator, then
% display instructions regarding setup.
%------------------------------------------------------------------% 
function InitalizeAndInstruct(IO)

close all								% closes all figure windows (if any)
rand('state',sum(100*clock));		% reseeds uniform noise generator
randn('state',sum(100*clock));	% reseeds Gaussian ("normal")

% DISPLAY INFORMATION ABOUT SETTING UP THE EXPERIMENT
disp([' Preparing to run ',IO.Prog,': ']);
disp('		connect CD player to input-1 on RP2; output 1 of RP2 to HB7-left');
disp('      headphone buffer should be set to -3 dB'); 
disp('      use BLACK CD, volume should be full on'); 
disp('		Test RIGHT ear with INSERTS');
disp('  ');

%------------------------------------------------------------------%
% SetConstants: Sets the values of constants that should not be    %
% changed for this experiment.                                     %
%------------------------------------------------------------------%
function [IO,STIM]=SetConstants  %NEED TO UPDATE THIS FXN

[IO,STIM]=SetConstantsCommon; % This is a separate file shared by the fixed and adaptive programs


%------------------------------------------------------------------%
% InitializeTrack: Initialize variables used to track threshold.
%------------------------------------------------------------------%
function TRACK=InitializeTrack

TRACK.numrevs=8; 					% total number of track reversals
TRACK.stepsize=4;				% initial stepsize for adjusting level
TRACK.ResponseRecord='xx';      % record of past response
TRACK.trialnum=0;
TRACK.ReversalCount=0;
TRACK.EndTrack=false;
TRACK.RevLevel=[];
TRACK.AllLevel=[];
TRACK.AllResp={};
TRACK.AllPlayed={};
TRACK.AllPause=[];
TRACK.Ceiling=80;				% max signal level allowed
TRACK.CeilingBumps=0;			% running count of # times that max was imposed

%------------------------------------------------------------------%
% GetRunInfo: Get observer's name and condition information.       %
%------------------------------------------------------------------%
function [ObsName,TRACK,STIM,IO]=GetRunInfo(STIM,TRACK,IO)			

disp(' ');													% blank carriage return
ObsName=input('Enter observer initials: ','s');	% read from keyboard

STIM.MaskerCond=[];
while isempty(STIM.MaskerCond),
    disp(' ');
    disp('Select masker condition: ')
    for i=1:length(STIM.MaskerConditionStr),
        disp(['   ',num2str(i),') ',STIM.MaskerConditionStr{i}]);
    end;
    tmp=input('        : ');
    if (tmp>0) && (tmp<=length(STIM.MaskerConditionStr)),
        STIM.MaskerCond=STIM.MaskerConditionStr{tmp};
    end;
end

TRACK.MaskerLev=99;
while (TRACK.MaskerLev> TRACK.Ceiling) || (TRACK.MaskerLev< 10),
	disp(' ');
	TRACK.MaskerLev=input(['Enter beginning masker level (10-',...
        num2str(TRACK.Ceiling),'): ']);
end

%------------------------------------------------------------------%
% SetUpTDT: Load up and initialize the RPVDs layout.               %
%------------------------------------------------------------------%
function [IO]=SetUpTDT(IO,STIM,TRACK)

% TDT ActiveX calls
IO.r = actxcontrol('RPCO.X');		% look for RP2 & assign shortcut to 'IO.r'
%c=invoke(IO.r, 'ConnectRP2','usb',1);
c=invoke(IO.r, 'ConnectRZ6','GB',1);
l=invoke(IO.r,'LoadCOF',[IO.Root,IO.rcoFile]);	% load .ROC file	
rn=invoke(IO.r,'Run');                  % start that .RCO circuit
if(c+l+rn<3),							% report any errors		
  error('error in initialization RP2');
end;				
set(gcf,'visible','off');		% make figure invisible

% Switch on the selected masker
switch STIM.MaskerCond
    case '2-talker'
        e(1)=invoke(IO.r,'SetTagVal','MskChannel',2);
    case '2-talker SSN'
        e(1)=invoke(IO.r,'SetTagVal','MskChannel',1);        
    case 'token SSN'
        e(1)=invoke(IO.r,'SetTagVal','MskChannel',3);
    otherwise
        error('Unknown STIM.MaskerCond');
end

% set initial signal level to zero to make sure it all works
if strcmp(STIM.MaskerCond,'quiet'),
    e(2)=invoke(IO.r,'SetTagVal','MskAmp',0);	
else
    LevScalar=10^((TRACK.MaskerLev-STIM.MaxMaskerLev)/20);
    e(2)=invoke(IO.r,'SetTagVal','MskAmp',LevScalar);
end;
SigScale=10^((STIM.TargetSigLev-STIM.MaxSigLev)/20);    % set sig to TargetSigLev
e(3)=invoke(IO.r,'SetTagVal','SigAmp',SigScale);	
if sum(e)~=3, 
   disp('ERROR: signal level not set properly'); 
end;

%------------------------------------------------------------------%
% SetUpTrackPlot: Set up display to monitor track in progress.     %
%------------------------------------------------------------------%
function PLOT=SetUpTrackPlot

PLOT.f=figure;
clf;
set(PLOT.f,'position',[32   109   362   387]);
PLOT.p=plot(1,1,1,1,'m.');
ylabel('Masker level (dB)');
xlabel('trial');

%------------------------------------------------------------------%
% UpDateTrackPlot: Add new data to display.                        %
%------------------------------------------------------------------%
function UpDateTrackPlot(PLOT,TRACK)

LevPts=TRACK.AllLevel;
if length(LevPts)>1,
    x=1:length(LevPts);
    set(PLOT.p,'xdata',1:length(LevPts),'ydata',LevPts);
    set(get(PLOT.f,'children'),'xlim',[0 length(x)+1],...
        'ylim',[min(LevPts)-2 max(LevPts)+2]);
end;


%------------------------------------------------------------------%
% LoadAndPlay   
%------------------------------------------------------------------
function TRACK=LoadAndPlay(STIM,TRACK,IO)

tic

% identify and load word
WordIndex=STIM.WordOrder(TRACK.trialnum);
WordPlayed=STIM.Word(WordIndex).str;
FileName=[IO.Root,IO.StimFolder,WordPlayed, '.wav'];
y=wavread(FileName);
y=y';
padpts=STIM.WordNumPts-length(y);
FullArray=[y,zeros(1,padpts)];
e = invoke(IO.r, 'WriteTagV', 'Token_in', 0, FullArray); 
if(~e), error('Error writting to buffer'); 
end
figure(5);
plot(FullArray); 
drawnow;
pause(1);

% start play-back of stimulus
invoke(IO.r,'SoftTrg',1);						

pause (0.5);

TRACK.AllPlayed{end+1}=WordPlayed;
disp(['masker level (dBSPL): ',num2str(TRACK.MaskerLev)]);  
drawnow;

%------------------------------------------------------------------%
% GetResp: Get the observer response.                              %
%------------------------------------------------------------------%
function [Resp,RespRight]=GetResp(TRACK)

disp(' ');
Resp=[];                % collect subj response
while isempty(Resp),
    Resp=input('Enter subj response: ','s');
    tmp=input(['Accept response:     ',Resp,' ? (y/n) '],'s');
    if strcmp(lower(tmp),'n'), Resp=[]; 
    end;
    Resp=lower(Resp);
end;

RespRight=[];
while isempty(RespRight),
    disp(['Correct response:    ',TRACK.AllPlayed{end}]);
    if strcmp(Resp,TRACK.AllPlayed{end}),
        RespRight='y';
        disp('Subj response is correct!');
    else
        tmp=input('Is subj response correct? (y/n) ','s');
        if strcmp(lower(tmp),'y') || strcmp(lower(tmp),'n'),
            RespRight=lower(tmp);
        else
            disp('    Response must be "y" or "n".  Please try again.');
        end;
    end;
end;


disp('- - - - - - - - - - - - - - -')

%------------------------------------------------------------------%
% RespEval: Assess the response and adjusts the track variables &  %
% signal when appropriate.                                         %
%------------------------------------------------------------------%
function [TRACK,IO]=RespEval(IO,TRACK,Resp,RespRight)

TRACK.AllResp{end+1}=Resp;

if RespRight=='y', 
    TRACK.ResponseRecord=['r',TRACK.ResponseRecord(1)];
     TRACK.MaskerLev=TRACK.MaskerLev+TRACK.stepsize; 
     if TRACK.MaskerLev>TRACK.Ceiling,   
        TRACK.MaskerLev=TRACK.Ceiling;
        TRACK.CeilingBumps=TRACK.CeilingBumps+1;
     end;
else
    TRACK.ResponseRecord=['w',TRACK.ResponseRecord(1)];
    TRACK.MaskerLev=TRACK.MaskerLev-TRACK.stepsize;
    %end;
end;

RevNow=CheckRev(TRACK);
if RevNow,
    TRACK.ReversalCount=TRACK.ReversalCount+1;
    TRACK.RevLevel=[TRACK.RevLevel,TRACK.MaskerLev];
    if (TRACK.ReversalCount==2),
        TRACK.stepsize=TRACK.stepsize/2;
    end;
end;
if TRACK.ReversalCount==TRACK.numrevs,
    TRACK.EndTrack=true;
end;

%------------------------------------------------------------------%
% CheckRev: Uses 1-down, 1-up tracking rules to determine if a     %
% track reversal has occurred and returns a boolean.               %
%------------------------------------------------------------------%
function RevNow=CheckRev(TRACK)

if strcmp(TRACK.ResponseRecord,'rw'),
	RevNow=true;
elseif strcmp(TRACK.ResponseRecord,'wr'), 
	RevNow=true;
else
	RevNow=false;
end;

%------------------------------------------------------------------%
% ComputeAndReport: Compute the results and report them by gener-  %
% ating array 'exdetails' and by printing the results to a file.   %
%------------------------------------------------------------------%
function thresh=ComputeAndReport(ObsName,STIM,TRACK,IO)

IO.TimeStamp=datestr(now);
thresh=mean(TRACK.RevLevel(3:TRACK.numrevs));
stdev=std(TRACK.RevLevel(3:TRACK.numrevs)); 

a=[IO.Prog,', ',IO.TimeStamp,', ',ObsName];
b=['Masker=',num2str(STIM.MaskerCond)];
c=['Thresh= ', num2str(thresh),...
	'  (ceiling hits= ',num2str(TRACK.CeilingBumps),...
    ' SD= ', num2str(stdev),')'];

tmp=char(a,b,c);
disp(tmp);

exdetails=[IO.Prog,', ',IO.TimeStamp,...		
      		', ',ObsName,...
            ', Masker=',STIM.MaskerCond,...
         	', thresh= ',num2str(thresh),...
            ', SD= ',num2str(stdev),...
            ', bumps= ',num2str(TRACK.CeilingBumps)];

fid=fopen([IO.Root,IO.LogFile],'a');		% get file ID ('a' means append)
LineIn='  '; 									% define blank line
	fprintf(fid,[LineIn,'\n']);				% write to file with '\n' (carriage return)
LineIn=exdetails;								% define summary results string
	fprintf(fid,[LineIn,'\n']);				% write to file 
fclose(fid);										% close file at the end

tmp=IO.TimeStamp;
TimeStamp=[tmp(4:6),'_',tmp(1:2),'_',tmp(10:11),'_',tmp(13:14),'_',tmp(16:17),'_',tmp(19:20)];

eval([TimeStamp,'.Prog=',IO.apos,IO.Prog,IO.apos,';']);
eval([TimeStamp,'.ObsName=ObsName;']);
eval([TimeStamp,'.MaskerCond=STIM.MaskerCond;']);
eval([TimeStamp,'.ThisMean=thresh;']);
eval([TimeStamp,'.RevVals=TRACK.RevLevel;']);
eval([TimeStamp,'.AllLev=TRACK.AllLevel;']);
eval([TimeStamp,'.AllResp=TRACK.AllResp;']);
eval([TimeStamp,'.AllPause=TRACK.AllPause;']);
eval([TimeStamp,'.AllPlayed=TRACK.AllPlayed;']);

cd([IO.Root,'data']);
eval(['save ',TimeStamp,' ',TimeStamp,'']);

%------------------------------------------------------------------%
% PossibleWords: All possible words from corpus
%------------------------------------------------------------------%
function [STIM]=PossibleWords(STIM)

disp('loading word strings');

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
STIM.Word(12).str='are';
STIM.Word(13).str='arm';
STIM.Word(14).str='art';
STIM.Word(15).str='as';
STIM.Word(16).str='ask';
STIM.Word(17).str='at';
STIM.Word(18).str='ax';
STIM.Word(19).str='back';
STIM.Word(20).str='bad';
STIM.Word(21).str='bag';
STIM.Word(22).str='bake';
STIM.Word(23).str='ball';
STIM.Word(24).str='band';
STIM.Word(25).str='bank';
STIM.Word(26).str='barn';
STIM.Word(27).str='base';   
STIM.Word(28).str='bat';
STIM.Word(29).str='bath';
STIM.Word(30).str='beach';
STIM.Word(31).str='bead';
STIM.Word(32).str='bean';
STIM.Word(33).str='bear';
STIM.Word(34).str='beat';
STIM.Word(35).str='bed';
STIM.Word(36).str='bee';
STIM.Word(37).str='beef';
STIM.Word(38).str='beep';
STIM.Word(39).str='beg';
STIM.Word(40).str='bell';
STIM.Word(41).str='bend';
STIM.Word(42).str='best';
STIM.Word(43).str='bet';
STIM.Word(44).str='big';
STIM.Word(45).str='bike';
STIM.Word(46).str='bill';
STIM.Word(47).str='bin';
STIM.Word(48).str='bird';
STIM.Word(49).str='bit';
STIM.Word(50).str='bite';
STIM.Word(51).str='black';
STIM.Word(52).str='blaze';
STIM.Word(53).str='bless';
STIM.Word(54).str='blind';
STIM.Word(55).str='block';
STIM.Word(56).str='blow';
STIM.Word(57).str='blue';
STIM.Word(58).str='board';
STIM.Word(59).str='boat';
STIM.Word(60).str='bone';
STIM.Word(61).str='book';
STIM.Word(62).str='boot';
STIM.Word(63).str='born';
STIM.Word(64).str='boss';
STIM.Word(65).str='both';
STIM.Word(66).str='bounce';
STIM.Word(67).str='box';
STIM.Word(68).str='boy';
STIM.Word(69).str='brave';
STIM.Word(70).str='bridge';
STIM.Word(71).str='bright';
STIM.Word(72).str='bring';
STIM.Word(73).str='brown';
STIM.Word(74).str='bud';
STIM.Word(75).str='bug';
STIM.Word(76).str='build';
STIM.Word(77).str='bull';
STIM.Word(78).str='bus';
STIM.Word(79).str='bush';
STIM.Word(80).str='but';
STIM.Word(81).str='buy';
STIM.Word(82).str='cab';
STIM.Word(83).str='cage';
STIM.Word(84).str='cake';
STIM.Word(85).str='calf';
STIM.Word(86).str='call';
STIM.Word(87).str='came';
STIM.Word(88).str='camp';
STIM.Word(89).str='can';
STIM.Word(90).str='cap';
STIM.Word(91).str='car';
STIM.Word(92).str='card';
STIM.Word(93).str='care';
STIM.Word(94).str='cart';
STIM.Word(95).str='case';
STIM.Word(96).str='cat';
STIM.Word(97).str='catch';
STIM.Word(98).str='cave';
STIM.Word(99).str='chair';
STIM.Word(100).str='chart';
STIM.Word(101).str='chase';
STIM.Word(102).str='check';
STIM.Word(103).str='chew';
STIM.Word(104).str='chin';
STIM.Word(105).str='choke';
STIM.Word(106).str='choose';
STIM.Word(107).str='class';
STIM.Word(108).str='claw';
STIM.Word(109).str='clay';
STIM.Word(110).str='clean';
STIM.Word(111).str='climb';
STIM.Word(112).str='clock';
STIM.Word(113).str='close';
STIM.Word(114).str='cloth';
STIM.Word(115).str='cloud';
STIM.Word(116).str='clown';
STIM.Word(117).str='club';
STIM.Word(118).str='coat';
STIM.Word(119).str='cold';
STIM.Word(120).str='come';
STIM.Word(121).str='cook';
STIM.Word(122).str='cool';
STIM.Word(123).str='cop';
STIM.Word(124).str='cost';
STIM.Word(125).str='could';
STIM.Word(126).str='count';
STIM.Word(127).str='cow';
STIM.Word(128).str='crab';
STIM.Word(129).str='crawl';
STIM.Word(130).str='cream';
STIM.Word(131).str='cross';
STIM.Word(132).str='cry';
STIM.Word(133).str='cub';
STIM.Word(134).str='cup';
STIM.Word(135).str='cut';
STIM.Word(136).str='cute';
STIM.Word(137).str='dad';
STIM.Word(138).str='dance';
STIM.Word(139).str='dark';
STIM.Word(140).str='date';
STIM.Word(141).str='day';
STIM.Word(142).str='deck';
STIM.Word(143).str='deep';
STIM.Word(144).str='deer';
STIM.Word(145).str='den';
STIM.Word(146).str='dent';
STIM.Word(147).str='did';
STIM.Word(148).str='dig';
STIM.Word(149).str='dime';
STIM.Word(150).str='dip';
STIM.Word(151).str='dirt';
STIM.Word(152).str='dish';
STIM.Word(153).str='dive';
STIM.Word(154).str='do';
STIM.Word(155).str='dock';
STIM.Word(156).str='does';
STIM.Word(157).str='dog';
STIM.Word(158).str='doll';
STIM.Word(159).str='done';
STIM.Word(160).str='door';
STIM.Word(161).str='dot';
STIM.Word(162).str='doubt';
STIM.Word(163).str='down';
STIM.Word(164).str='draw';
STIM.Word(165).str='dream';
STIM.Word(166).str='dress';
STIM.Word(167).str='drink';
STIM.Word(168).str='drive';
STIM.Word(169).str='drop';
STIM.Word(170).str='dry';
STIM.Word(171).str='duck';
STIM.Word(172).str='ear';
STIM.Word(173).str='earth';
STIM.Word(174).str='east';
STIM.Word(175).str='eat';
STIM.Word(176).str='edge';
STIM.Word(177).str='egg';
STIM.Word(178).str='eight';
STIM.Word(179).str='elf';
STIM.Word(180).str='else';
STIM.Word(181).str='end';
STIM.Word(182).str='eye';
STIM.Word(183).str='face';
STIM.Word(184).str='fact';
STIM.Word(185).str='fade';
STIM.Word(186).str='fair';
STIM.Word(187).str='fake';
STIM.Word(188).str='falls';
STIM.Word(189).str='fan';
STIM.Word(190).str='far';
STIM.Word(191).str='farm';
STIM.Word(192).str='fast';
STIM.Word(193).str='fat';
STIM.Word(194).str='fear';
STIM.Word(195).str='fed';
STIM.Word(196).str='feel';
STIM.Word(197).str='fell';
STIM.Word(198).str='fence';
STIM.Word(199).str='few';
STIM.Word(200).str='fifth';
STIM.Word(201).str='fight';
STIM.Word(202).str='fill';
STIM.Word(203).str='fin';
STIM.Word(204).str='find';
STIM.Word(205).str='fine';
STIM.Word(206).str='fire';
STIM.Word(207).str='first';
STIM.Word(208).str='fish';
STIM.Word(209).str='fit';
STIM.Word(210).str='five';
STIM.Word(211).str='fix';
STIM.Word(212).str='flake';
STIM.Word(213).str='flew';
STIM.Word(214).str='float';
STIM.Word(215).str='floor';
STIM.Word(216).str='flow';
STIM.Word(217).str='fly';
STIM.Word(218).str='fog';
STIM.Word(219).str='fold';
STIM.Word(220).str='food';
STIM.Word(221).str='foot';
STIM.Word(222).str='for';
STIM.Word(223).str='fork';
STIM.Word(224).str='found';
STIM.Word(225).str='fourth';
STIM.Word(226).str='fox';
STIM.Word(227).str='free';
STIM.Word(228).str='freeze';
STIM.Word(229).str='fresh';
STIM.Word(230).str='friend';
STIM.Word(231).str='frog';
STIM.Word(232).str='from';
STIM.Word(233).str='front';
STIM.Word(234).str='fry';
STIM.Word(235).str='full';
STIM.Word(236).str='fun';
STIM.Word(237).str='fur';
STIM.Word(238).str='fuss';
STIM.Word(239).str='game';
STIM.Word(240).str='gap';
STIM.Word(241).str='gas';
STIM.Word(242).str='gate';
STIM.Word(243).str='gave';
STIM.Word(244).str='gear';
STIM.Word(245).str='get';
STIM.Word(246).str='ghost';
STIM.Word(247).str='gift';
STIM.Word(248).str='girl';
STIM.Word(249).str='give';
STIM.Word(250).str='glad';
STIM.Word(251).str='glass';
STIM.Word(252).str='glow';
STIM.Word(253).str='glue';
STIM.Word(254).str='go';
STIM.Word(255).str='goat';
STIM.Word(256).str='goes';
STIM.Word(257).str='gold';
STIM.Word(258).str='gone';
STIM.Word(259).str='good';
STIM.Word(260).str='got';
STIM.Word(261).str='grab';
STIM.Word(262).str='grade';
STIM.Word(263).str='grass'; 
STIM.Word(264).str='gray';
STIM.Word(265).str='great';
STIM.Word(266).str='green';
STIM.Word(267).str='grew';
STIM.Word(268).str='grin';
STIM.Word(269).str='ground';
STIM.Word(270).str='group';
STIM.Word(271).str='grow';
STIM.Word(272).str='guard';
STIM.Word(273).str='guess';
STIM.Word(274).str='guide';
STIM.Word(275).str='gum';
STIM.Word(276).str='guy';
STIM.Word(277).str='gym';
STIM.Word(278).str='had';
STIM.Word(279).str='hair';
STIM.Word(280).str='half';
STIM.Word(281).str='hall';
STIM.Word(282).str='ham';
STIM.Word(283).str='hand';
STIM.Word(284).str='hard';
STIM.Word(285).str='has';
STIM.Word(286).str='hat';
STIM.Word(287).str='have';
STIM.Word(288).str='hay';
STIM.Word(289).str='he';
STIM.Word(290).str='head';
STIM.Word(291).str='hear';
STIM.Word(292).str='heart';
STIM.Word(293).str='heat';
STIM.Word(294).str='help';
STIM.Word(295).str='her';
STIM.Word(296).str='hi';
STIM.Word(297).str='hide';
STIM.Word(298).str='hill';
STIM.Word(299).str='him';
STIM.Word(300).str='hint';
STIM.Word(301).str='hip';
STIM.Word(302).str='his';
STIM.Word(303).str='hit';
STIM.Word(304).str='hog';
STIM.Word(305).str='hold';
STIM.Word(306).str='hole';
STIM.Word(307).str='home';
STIM.Word(308).str='honk';
STIM.Word(309).str='hop';
STIM.Word(310).str='hope';
STIM.Word(311).str='horse';
STIM.Word(312).str='hot';
STIM.Word(313).str='hour';
STIM.Word(314).str='house';
STIM.Word(315).str='how';
STIM.Word(316).str='hug';
STIM.Word(317).str='huge';
STIM.Word(318).str='hunt';
STIM.Word(319).str='hurt';
STIM.Word(320).str='ice';
STIM.Word(321).str='if';
STIM.Word(322).str='ill';
STIM.Word(323).str='in';
STIM.Word(324).str='inch';
STIM.Word(325).str='is';
STIM.Word(326).str='it';
STIM.Word(327).str='its';
STIM.Word(328).str='jack';
STIM.Word(329).str='jam';
STIM.Word(330).str='jar';
STIM.Word(331).str='jay';
STIM.Word(332).str='jeans';
STIM.Word(333).str='jet';
STIM.Word(334).str='job';
STIM.Word(335).str='joke';
STIM.Word(336).str='joy';
STIM.Word(337).str='jug';
STIM.Word(338).str='juice';
STIM.Word(339).str='jump';
STIM.Word(340).str='June';
STIM.Word(341).str='just';
STIM.Word(342).str='keep';
STIM.Word(343).str='key';
STIM.Word(344).str='kick';
STIM.Word(345).str='kid';
STIM.Word(346).str='kind';
STIM.Word(347).str='king';
STIM.Word(348).str='kiss';
STIM.Word(349).str='kit';
STIM.Word(350).str='kite';
STIM.Word(351).str='knee';
STIM.Word(352).str='knew';
STIM.Word(353).str='knife';
STIM.Word(354).str='known';
STIM.Word(355).str='lake';
STIM.Word(356).str='lamb';
STIM.Word(357).str='lamp';
STIM.Word(358).str='lap';
STIM.Word(359).str='large';
STIM.Word(360).str='last';
STIM.Word(361).str='late';
STIM.Word(362).str='laugh';
STIM.Word(363).str='law';
STIM.Word(364).str='lay';
STIM.Word(365).str='leaf';
STIM.Word(366).str='learn';
STIM.Word(367).str='least';
STIM.Word(368).str='leave';
STIM.Word(369).str='left';
STIM.Word(370).str='leg';
STIM.Word(371).str='less';
STIM.Word(372).str='let';
STIM.Word(373).str='lick';
STIM.Word(374).str='lid';
STIM.Word(375).str='lie';
STIM.Word(376).str='life';
STIM.Word(377).str='lift';
STIM.Word(378).str='light';
STIM.Word(379).str='like';
STIM.Word(380).str='likes';
STIM.Word(381).str='line';
STIM.Word(382).str='lip';
STIM.Word(383).str='lit';
STIM.Word(384).str='live';
STIM.Word(385).str='lives';
STIM.Word(386).str='lock';
STIM.Word(387).str='log';
STIM.Word(388).str='long';
STIM.Word(389).str='look';
STIM.Word(390).str='lose';
STIM.Word(391).str='loss';
STIM.Word(392).str='lost';
STIM.Word(393).str='lot';
STIM.Word(394).str='loud';
STIM.Word(395).str='love';
STIM.Word(396).str='loved';
STIM.Word(397).str='low';
STIM.Word(398).str='luck';
STIM.Word(399).str='lunch';
STIM.Word(400).str='mad';
STIM.Word(401).str='made';
STIM.Word(402).str='mail';
STIM.Word(403).str='make';
STIM.Word(404).str='mall';
STIM.Word(405).str='man';
STIM.Word(406).str='map';
STIM.Word(407).str='mark';
STIM.Word(408).str='mat';
STIM.Word(409).str='may';
STIM.Word(410).str='me';
STIM.Word(411).str='mean';
STIM.Word(412).str='meat';
STIM.Word(413).str='men';
STIM.Word(414).str='mess';
STIM.Word(415).str='might';
STIM.Word(416).str='mile';
STIM.Word(417).str='milk';
STIM.Word(418).str='mill';
STIM.Word(419).str='mind';
STIM.Word(420).str='mine';
STIM.Word(421).str='miss';
STIM.Word(422).str='mix';
STIM.Word(423).str='mom';
STIM.Word(424).str='month';
STIM.Word(425).str='moon';
STIM.Word(426).str='mop';
STIM.Word(427).str='more';
STIM.Word(428).str='most';
STIM.Word(429).str='moth';
STIM.Word(430).str='mouse';
STIM.Word(431).str='mouth';
STIM.Word(432).str='move';
STIM.Word(433).str='much';
STIM.Word(434).str='mud';
STIM.Word(435).str='mug';
STIM.Word(436).str='must';
STIM.Word(437).str='my';
STIM.Word(438).str='name';
STIM.Word(439).str='nap';
STIM.Word(440).str='near';
STIM.Word(441).str='neat';
STIM.Word(442).str='neck';
STIM.Word(443).str='need';
STIM.Word(444).str='nest';
STIM.Word(445).str='next';
STIM.Word(446).str='nice';
STIM.Word(447).str='night';
STIM.Word(448).str='nine';
STIM.Word(449).str='no';
STIM.Word(450).str='noise';
STIM.Word(451).str='none';
STIM.Word(452).str='noon';
STIM.Word(453).str='north';
STIM.Word(454).str='nose';
STIM.Word(455).str='not';
STIM.Word(456).str='note';
STIM.Word(457).str='now';
STIM.Word(458).str='nurse';
STIM.Word(459).str='nut';
STIM.Word(460).str='nuts';
STIM.Word(461).str='oak';
STIM.Word(462).str='oat';
STIM.Word(463).str='of';
STIM.Word(464).str='off';
STIM.Word(465).str='oil';
STIM.Word(466).str='old';
STIM.Word(467).str='on';
STIM.Word(468).str='once';
STIM.Word(469).str='one';
STIM.Word(470).str='or';
STIM.Word(471).str='out';
STIM.Word(472).str='owl';
STIM.Word(473).str='own';
STIM.Word(474).str='pack';
STIM.Word(475).str='pad';
STIM.Word(476).str='page';
STIM.Word(477).str='pair';
STIM.Word(478).str='pan';
STIM.Word(479).str='pants';
STIM.Word(480).str='park';
STIM.Word(481).str='part';
STIM.Word(482).str='pass';
STIM.Word(483).str='past';
STIM.Word(484).str='paste';
STIM.Word(485).str='pat';
STIM.Word(486).str='path';
STIM.Word(487).str='paw';
STIM.Word(488).str='pay';
STIM.Word(489).str='pea';
STIM.Word(490).str='peace';
STIM.Word(491).str='peach';
STIM.Word(492).str='peg';
STIM.Word(493).str='pen';
STIM.Word(494).str='pet';
STIM.Word(495).str='pick';
STIM.Word(496).str='pie';
STIM.Word(497).str='pig';
STIM.Word(498).str='pile';
STIM.Word(499).str='pin';
STIM.Word(500).str='pinch';
STIM.Word(501).str='pine';
STIM.Word(502).str='pink';
STIM.Word(503).str='pipe';
STIM.Word(504).str='pit';
STIM.Word(505).str='place';
STIM.Word(506).str='plan';
STIM.Word(507).str='plane';
STIM.Word(508).str='plant';
STIM.Word(509).str='plate';
STIM.Word(510).str='play';
STIM.Word(511).str='please';
STIM.Word(512).str='plow';
STIM.Word(513).str='plus';
STIM.Word(514).str='point';
STIM.Word(515).str='pond';
STIM.Word(516).str='poor';
STIM.Word(517).str='post';
STIM.Word(518).str='pot';
STIM.Word(519).str='press';
STIM.Word(520).str='price';
STIM.Word(521).str='prince';
STIM.Word(522).str='print';
STIM.Word(523).str='prove';
STIM.Word(524).str='pull';
STIM.Word(525).str='purse';
STIM.Word(526).str='push';
STIM.Word(527).str='put';
STIM.Word(528).str='queen';
STIM.Word(529).str='quick';
STIM.Word(530).str='quit';
STIM.Word(531).str='race';
STIM.Word(532).str='rack';
STIM.Word(533).str='rag';
STIM.Word(534).str='rain';
STIM.Word(535).str='raise';
STIM.Word(536).str='rake';
STIM.Word(537).str='ran';
STIM.Word(538).str='rat';
STIM.Word(539).str='rate';
STIM.Word(540).str='raw';
STIM.Word(541).str='reach';
STIM.Word(542).str='read';
STIM.Word(543).str='real';
STIM.Word(544).str='rent';
STIM.Word(545).str='rest';
STIM.Word(546).str='rib';
STIM.Word(547).str='rice';
STIM.Word(548).str='rich';
STIM.Word(549).str='rid';
STIM.Word(550).str='ride';
STIM.Word(551).str='ring';
STIM.Word(552).str='rip';
STIM.Word(553).str='ripe';
STIM.Word(554).str='rise';
STIM.Word(555).str='road';
STIM.Word(556).str='roar';
STIM.Word(557).str='rob';
STIM.Word(558).str='rock';
STIM.Word(559).str='rod';
STIM.Word(560).str='roof';
STIM.Word(561).str='room';
STIM.Word(562).str='rope';
STIM.Word(563).str='rose';
STIM.Word(564).str='rot';
STIM.Word(565).str='round';
STIM.Word(566).str='row';
STIM.Word(567).str='rub';
STIM.Word(568).str='rug';
STIM.Word(569).str='rule';
STIM.Word(570).str='run';
STIM.Word(571).str='sack';
STIM.Word(572).str='sad';
STIM.Word(573).str='safe';
STIM.Word(574).str='said';
STIM.Word(575).str='sale';
STIM.Word(576).str='salt';
STIM.Word(577).str='same';
STIM.Word(578).str='sand';
STIM.Word(579).str='save';
STIM.Word(580).str='saw';
STIM.Word(581).str='say';
STIM.Word(582).str='scab';
STIM.Word(583).str='scare';
STIM.Word(584).str='scene';
STIM.Word(585).str='school';
STIM.Word(586).str='score';
STIM.Word(587).str='scream';
STIM.Word(588).str='sea';
STIM.Word(589).str='seal';
STIM.Word(590).str='search';
STIM.Word(591).str='seat';
STIM.Word(592).str='seed';
STIM.Word(593).str='seek';
STIM.Word(594).str='seem';
STIM.Word(595).str='sell';
STIM.Word(596).str='send';
STIM.Word(597).str='sent';
STIM.Word(598).str='serve';
STIM.Word(599).str='set';
STIM.Word(600).str='shake';
STIM.Word(601).str='shape';
STIM.Word(602).str='shark';
STIM.Word(603).str='sharp';
STIM.Word(604).str='shave';
STIM.Word(605).str='she';
STIM.Word(606).str='sheep';
STIM.Word(607).str='sheet';
STIM.Word(608).str='shell';
STIM.Word(609).str='shine';
STIM.Word(610).str='ship';
STIM.Word(611).str='shirt';
STIM.Word(612).str='shock';
STIM.Word(613).str='shoe';
STIM.Word(614).str='shop';
STIM.Word(615).str='shore';
STIM.Word(616).str='short';
STIM.Word(617).str='shot';
STIM.Word(618).str='shout';
STIM.Word(619).str='show';
STIM.Word(620).str='shut';
STIM.Word(621).str='shy';
STIM.Word(622).str='sick';
STIM.Word(623).str='side';
STIM.Word(624).str='sight';
STIM.Word(625).str='sign';
STIM.Word(626).str='since';
STIM.Word(627).str='sing';
STIM.Word(628).str='sit';
STIM.Word(629).str='six';
STIM.Word(630).str='size';
STIM.Word(631).str='skate';
STIM.Word(632).str='skin';
STIM.Word(633).str='skunk';
STIM.Word(634).str='sky';
STIM.Word(635).str='sled';
STIM.Word(636).str='sleep';
STIM.Word(637).str='slice';
STIM.Word(638).str='slip';
STIM.Word(639).str='slow';
STIM.Word(640).str='small';
STIM.Word(641).str='smart';
STIM.Word(642).str='smile';
STIM.Word(643).str='smoke';
STIM.Word(644).str='snail';
STIM.Word(645).str='snake';
STIM.Word(646).str='snow';
STIM.Word(647).str='so';
STIM.Word(648).str='sock';
STIM.Word(649).str='soft';
STIM.Word(650).str='some';
STIM.Word(651).str='song';
STIM.Word(652).str='soon';
STIM.Word(653).str='sort';
STIM.Word(654).str='sound';
STIM.Word(655).str='soup';
STIM.Word(656).str='south';
STIM.Word(657).str='space';
STIM.Word(658).str='speak';
STIM.Word(659).str='spell';
STIM.Word(660).str='spill';
STIM.Word(661).str='spin';
STIM.Word(662).str='splash';
STIM.Word(663).str='spoke';
STIM.Word(664).str='spoon';
STIM.Word(665).str='sport';
STIM.Word(666).str='spot';
STIM.Word(667).str='spring';
STIM.Word(668).str='stake';
STIM.Word(669).str='stand';
STIM.Word(670).str='star';
STIM.Word(671).str='start';
STIM.Word(672).str='state';
STIM.Word(673).str='stay';
STIM.Word(674).str='step';
STIM.Word(675).str='stick';
STIM.Word(676).str='still';
STIM.Word(677).str='stood';
STIM.Word(678).str='stop';
STIM.Word(679).str='store';
STIM.Word(680).str='stove';
STIM.Word(681).str='strange';
STIM.Word(682).str='stream';
STIM.Word(683).str='street';
STIM.Word(684).str='string';
STIM.Word(685).str='stripe';
STIM.Word(686).str='strong';
STIM.Word(687).str='stuff';
STIM.Word(688).str='such';
STIM.Word(689).str='suit';
STIM.Word(690).str='sun';
STIM.Word(691).str='sweet';
STIM.Word(692).str='swim';
STIM.Word(693).str='swing';
STIM.Word(694).str='tag';
STIM.Word(695).str='tail';
STIM.Word(696).str='take';
STIM.Word(697).str='talk';
STIM.Word(698).str='tall';
STIM.Word(699).str='tan';
STIM.Word(700).str='tap';
STIM.Word(701).str='tape';
STIM.Word(702).str='taste';
STIM.Word(703).str='team';
STIM.Word(704).str='teeth';
STIM.Word(705).str='tell';
STIM.Word(706).str='ten';
STIM.Word(707).str='tent';
STIM.Word(708).str='than';
STIM.Word(709).str='thank';
STIM.Word(710).str='that';
STIM.Word(711).str='the';
STIM.Word(712).str='them';
STIM.Word(713).str='then';
STIM.Word(714).str='there';
STIM.Word(715).str='these';
STIM.Word(716).str='they';
STIM.Word(717).str='thick';
STIM.Word(718).str='thin';
STIM.Word(719).str='thing';
STIM.Word(720).str='think';
STIM.Word(721).str='third';
STIM.Word(722).str='this';
STIM.Word(723).str='those';
STIM.Word(724).str='thought';
STIM.Word(725).str='three';
STIM.Word(726).str='threw';
STIM.Word(727).str='throat';
STIM.Word(728).str='throw';
STIM.Word(729).str='tick';
STIM.Word(730).str='tide';
STIM.Word(731).str='tie';
STIM.Word(732).str='tight';
STIM.Word(733).str='tile';
STIM.Word(734).str='time';
STIM.Word(735).str='tip';
STIM.Word(736).str='tire';
STIM.Word(737).str='to';
STIM.Word(738).str='toe';
STIM.Word(739).str='told';
STIM.Word(740).str='ton';
STIM.Word(741).str='took';
STIM.Word(742).str='tool';
STIM.Word(743).str='tooth';
STIM.Word(744).str='top';
STIM.Word(745).str='tough';
STIM.Word(746).str='town';
STIM.Word(747).str='toy';
STIM.Word(748).str='track';
STIM.Word(749).str='train';
STIM.Word(750).str='trap';
STIM.Word(751).str='tray';
STIM.Word(752).str='tree';
STIM.Word(753).str='trick';
STIM.Word(754).str='trip';
STIM.Word(755).str='truck';
STIM.Word(756).str='true';
STIM.Word(757).str='trust';
STIM.Word(758).str='truth';
STIM.Word(759).str='try';
STIM.Word(760).str='tub';
STIM.Word(761).str='tuck';
STIM.Word(762).str='tug';
STIM.Word(763).str='tune';
STIM.Word(764).str='turn';
STIM.Word(765).str='twelve';
STIM.Word(766).str='twist';
STIM.Word(767).str='type';
STIM.Word(768).str='up';
STIM.Word(769).str='us';
STIM.Word(770).str='used';
STIM.Word(771).str='van';
STIM.Word(772).str='view';
STIM.Word(773).str='vine';
STIM.Word(774).str='voice';
STIM.Word(775).str='wait';
STIM.Word(776).str='wake';
STIM.Word(777).str='walk';
STIM.Word(778).str='wall';
STIM.Word(779).str='want';
STIM.Word(780).str='war';
STIM.Word(781).str='warm';
STIM.Word(782).str='was';
STIM.Word(783).str='wash';
STIM.Word(784).str='waste';
STIM.Word(785).str='watch';
STIM.Word(786).str='wave';
STIM.Word(787).str='wax';
STIM.Word(788).str='way';
STIM.Word(789).str='ways';
STIM.Word(790).str='we';
STIM.Word(791).str='wear';
STIM.Word(792).str='weed';
STIM.Word(793).str='week';
STIM.Word(794).str='well';
STIM.Word(795).str='went';
STIM.Word(796).str='were';
STIM.Word(797).str='west';
STIM.Word(798).str='wet';
STIM.Word(799).str='whale';
STIM.Word(800).str='what';
STIM.Word(801).str='wheat';
STIM.Word(802).str='wheel';
STIM.Word(803).str='when';
STIM.Word(804).str='which';
STIM.Word(805).str='while';
STIM.Word(806).str='white';
STIM.Word(807).str='who';
STIM.Word(808).str='why';
STIM.Word(809).str='wide';
STIM.Word(810).str='wife';
STIM.Word(811).str='wig';
STIM.Word(812).str='will';
STIM.Word(813).str='wind';
STIM.Word(814).str='wing';
STIM.Word(815).str='wipe';
STIM.Word(816).str='wise';
STIM.Word(817).str='wish';
STIM.Word(818).str='with';
STIM.Word(819).str='wolf';
STIM.Word(820).str='wood';
STIM.Word(821).str='word';
STIM.Word(822).str='work';
STIM.Word(823).str='worm';
STIM.Word(824).str='worse';
STIM.Word(825).str='wreck';
STIM.Word(826).str='write';
STIM.Word(827).str='wrong';
STIM.Word(828).str='yard';
STIM.Word(829).str='year';
STIM.Word(830).str='yell';
STIM.Word(831).str='yes';
STIM.Word(832).str='yet';
STIM.Word(833).str='you';
STIM.Word(834).str='young';
STIM.Word(835).str='your';
STIM.Word(836).str='zip';
STIM.Word(837).str='zoo';

