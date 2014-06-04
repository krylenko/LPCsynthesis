% LPCSR_Analysis Filter coefficient estimation and pitch detection for LPC
% speech coding
%
%   [b0,a,pitch,v] = LPCSR_Analysis(in,fs,L,order) returns the numerator
%   coefficient b0 (frame gain) and denominator coefficient of an IIR synthesis
%   filter estimated from input sample in, as well as the fundamental pitch
%   period of the sample, if periodic, and the voiced/unvoiced detection 
%   parameter V. V = 1 if the sample is periodic and 0 if it is not, in which
%   case pitch will also be 0.
%
%   The filter coefficients are estimated with Prony's method, while the
%   pitch period and voiced/unvoiced detection are computed using 
%   autocorrelation. The pitch period is limited to periods equivalent to
%   frequencies betwee 80 and 350 Hz.
%  
%   LPC Speech Recognition Project
%   ECE 529 Spring 2014
%   Daniel Ford

function [b0,a,pitch,v] = LPCSR_Analysis(in,fs,L,order)
                 
% limit pitch range to 80-350 Hz
pmin = int32(fs/350);
pmax = int32(fs/80);

% init arrays
win=hamming(L);                   % L-length hamming window

% perform LPC analysis
xw=in.*win;                         % window input w/ hamming
[a,G] = LPCSR_Prony(xw,order,0);    % determine coeffs
b0 = sqrt(G);                       % convert G to b0 coeff
[pitch,v] = LPCSR_Autocorr(xw,pmin,pmax); % determine pitch

