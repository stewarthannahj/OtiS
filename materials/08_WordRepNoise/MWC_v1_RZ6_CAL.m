%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MWC_v1_RZ6_CAL()
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function MWC_v1_RZ6_CAL()

% INITIALIZE
close all                           
[CONST]=SetConstants;               
[CONST]=GetRunInfo(CONST);
addpath('Z:\CSRC\Dave_Moore-Project_Library-2014\Tasks\BoysTown\matlab_1speaker');
RP2=SetTDT(CONST);
pause(CONST.duration_Secs)

invoke(RP2,'halt');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function RP2 = SetTDT(CONST)

RP2 = actxcontrol('RPCO.X');		% look for RP2 & assign shortcut
%c=invoke(RP2, 'ConnectRP2','usb',1);
c=RP2.ConnectRZ6('GB',1);
pause(1);
l=invoke(RP2,'LoadCOF',[CONST.Root,CONST.TDT_filename]);	% load .ROC file
rn=invoke(RP2,'Run');				% start that .RCO circuit
if(c+l+rn<3),						% report any errors
    error('error in initialization: RP2');
end;

e(1)=invoke(RP2,'SetTagVal','MskAmp',1);
switch CONST.MaskerCondNum
    case 1
        e(2)=invoke(RP2,'SetTagVal','MskChannel',1);    % SSN from 2TM
    case 2
        e(2)=invoke(RP2,'SetTagVal','MskChannel',3);    % SSN from concat. tokens
    otherwise
        error('Unknown MaskerCondNum');
end


if sum(e)~=2,
    error('unable to set masker condition properly');
end;
display_String1 = sprintf('%s %s %s','This program plays the selected SSN at amplitude 1 for',num2str(CONST.duration_Secs),'seconds');
display_String2 = 'After measuring the calibration level, update SetConstantsCommon.m.';
disp(display_String1);
disp(display_String2);

set(gcf,'visible','off');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [CONST]=SetConstants

CONST.Root='C:\projects\MWC\';     % root for this experiment
CONST.TDT_filename='MWC_v1_RZ6.rcx';
CONST.duration_Secs = 30;




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [CONST]=GetRunInfo(CONST)			

disp(' '); % blank carriage return

CONST.MaskerConditionStr={'SSN from 2-talker male masker','SSN from concatenated tokens'};
CONST.MaskerCond=[];
while isempty(CONST.MaskerCond),
    disp(' ');
    disp('Select which SSN to use for calibration: ')
    for i=1:length(CONST.MaskerConditionStr),
        disp(['   ',num2str(i),') ',CONST.MaskerConditionStr{i}]);
    end;
    tmp=input('        : ');
    if (tmp>0) && (tmp<=length(CONST.MaskerConditionStr)),
        CONST.MaskerCond=CONST.MaskerConditionStr{tmp};
        CONST.MaskerCondNum = tmp;
    end;
end