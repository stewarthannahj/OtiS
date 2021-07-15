function [sig_Start, sig_End] = mark_Signal(y_In, fringe_Threshold)

% This function marks the start and end of the signal, assuming y_In looks
% like [ leading fringe, signal, trailing fringe]

% Initialize
sig_Start = length(y_In);
sig_End = 1;

% Get sig_Start
k = 3;
while k < length(y_In)
    if ( abs(y_In(k)) + abs(y_In(k-1)) + abs(y_In(k-2)) ) > 3*fringe_Threshold
        sig_Start = k-2;
        break;
    end
    k = k + 1;
end

% Get sig_End
k = length(y_In);
while k > 3
    if ( abs(y_In(k)) + abs(y_In(k-1)) + abs(y_In(k-2)) ) > 3*fringe_Threshold
        sig_End = k-2;
        break;
    end
    k = k - 1;
end
