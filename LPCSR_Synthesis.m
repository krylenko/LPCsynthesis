% LPCSR_Synthesis Synthesis of an output sample from LPC coefficients and 
% pitch information
%
%   [sout,excit] = LPCSR_Synthesis(b0,a,pitch,v,L,order) returns the 
%   synthesized output sample sout and the excitation sample excit, both of 
%   which are length L. If V = 1, excit is an impulse train of period 'pitch';
%   if V = 0, excit is white noise. sout is synthesized by processing excit
%   with an IIR filter with numerator coefficient b0 and denominator 
%   coefficients a. 
%
%   LPC Speech Recognition Project
%   ECE 529 Spring 2014
%   Daniel Ford

function [sout,excit] = LPCSR_Synthesis(b0,a,pitch,v,L,order)
                 
win=hamming(L);                   % L-length hamming window
excit = LPCSR_Excite(L,pitch,v);  % create excitation frame
sout = filter(b0,a,excit);        % filter w/ derived coeffs
sout = sout.*win;                 % apply hamming 