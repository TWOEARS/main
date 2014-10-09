function signal = normalize(signal)
% normalize(signal) normalizes the amplitude of the given signal to the range of
% ]-1:1[.

% AUTHOR: Hagen Wierstorf

narginchk(1,1);
% Scaling the signal to -1<sig<1
sig = sig / (max(abs(sig(:)))+eps);
