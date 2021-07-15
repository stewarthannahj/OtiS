function [IO,STIM]=SetConstantsCommon  %NEED TO UPDATE THIS FXN

IO.Root='C:\projects\MWC\';      % this may need to be customized
IO.StimFolder='RajMWC_ALL_Fixed_Equalized\'; 
IO.LogFile='MWC_out.txt';				% log of every run
IO.rcoFile='MWC_v1_RZ6.rcx';				% compiled RPvds file
IO.Prog='MWC';      % name of file that is currently running
IO.apos='''';           % character constant with just an apostrophe


STIM.MaskerConditionStr={'2-talker','2-talker SSN','token SSN'};
STIM.TargetSigLev=65;
STIM.WordNumPts=30000;      % MWC max word length is 21759 (after resampling)
                            %from resampling stimuli (3/2/13)


%%% CHANGE TO MATCH CALIBRATION LEVELS HERE %%%%
% TARGET LEVEL HERE
STIM.MaxSigLev=79;		% level of calibration tone (equal RMS to stim)7/12/13
                        %LJL changed cal level to 82 dB SPL on 3-12-14
                        %LJL changed cal level to 76 dB SPL on 8-9-14 to
                        %reflect rack changes for other programs
                        % 8/19/14 AYB changed so we could run stimuli
                        % through headphones (changed to 95.5 dB SPL)
                        %10/15/2014 NC changed to 75.5 for supplemental data
                        %collection in sound field
                         %10/23/14 NC changed to 76 using OUT B with cord
                        %"Speaker out B
                        %3/26/15 NC changed to 76.5 using OUT B with cord
                        %Speaker OUT B; 8/7/15 AYB changed
                        %calibrated at BTNRH. OUT A to SLA4 using BNC to
                        %1/4 inch cable. calibrated in sound field by LJL
                        %and JM on 6-22-16
                        %LJL changed attenuator and recalibrated on 7-25-16
                        %JB and LJL verified calibration on 5/4/18

%MASKER LEVEL HERE
STIM.MaxMaskerLev=79;    %level of calibration tone (from masker) 7/12/13
                            %LJL changed cal level to 82 dB SPL on 3-12-14
                            %LJL changed cal level to 76 dB SPL on 8-9-14 to
                        %reflect rack changes for other programs
                        %8/19/14 AYB changed so we could run stimuli
                        %through headphones (changed to 92.5)
                        %10/15/2014 NC changed to 75.5 for supplemental data
                        %collection in sound field
                        %10/23/14 NC changed to 76 using OUT B with cord
                        %"Speaker out B; 8/7/15 AYB changed
                        %calibrated at BTNRH. OUT A to SLA4 using BNC to
                        %1/4 inch cable. calibrated in sound field by LJL
                        %and JM on 6-22-16
                        %LJL changed attenuator and recalibrated on 7-25-16
                        %JB and LJL verified calibration on 5/4/18