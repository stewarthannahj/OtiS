% Adjust the amplitude of the maskers so that the RMS is 0.065 so that they are consistent with the RMS of the tokens
addpath('C:\projects\Common');

[y_In,Fs] = wavread('2maleTalkerJackandtheBeanstalk_Equalized_Pt1.wav');
adj_Factor = 0.065/std(y_In);
y_Out = adj_Factor*y_In;
wavwrite(y_Out,Fs,'2maleTalkerJackandtheBeanstalk_Equalized_Pt065.wav');


