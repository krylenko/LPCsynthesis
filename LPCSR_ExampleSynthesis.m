% LPCSR_ExampleSynthesis Example script to run LPC analysis and synthesis with
% LPCSR
%
%   LPCSR_ExampleSynthesis requests the following parameters from the user:
%     -Filename for the 16-bit, 8 kHz WAV file to be resynthesized (assumed
%     to be in Matlab's path)
%     -Frame length in ms
%     -Frame offset in ms
%     -LPC filter order
%     -Noise volume in transmission channel in dB
%
%   LPC Speech Recognition Project
%   ECE 529 Spring 2014
%   Daniel Ford

% housekeeping
clear all; clc;

% user info
fprintf(1,'**********************************\n');
fprintf(1,'*  LPC Synthesis Example Script  *\n');
fprintf(1,'**********************************\n\n');

% user input
filename = input('Enter filename for resynthesis: ','s');
Lm = input('Enter frame length in ms (e.g., 40): ');
Rm = input('Enter frame offset in ms (e.g., 10): '); 
order = input('Enter filter order (1-20) (e.g., 10): ');
volume ...
= input('Enter noise volume in transmission channel in dB (0 = no noise): ');

% send audio and user params to main function
% receive back original input, synthesized sound s,
% complete excitation e, per-frame gain g, and per-frame pitch periods pd
[input,s,e,g,pd] = LPCSR_LoopWrapper(filename,Lm,Rm,order,volume);

% plot relevant variables
LPCSR_PlotAnalysis(input,s,e,g,pd);

% normalize volume and play synthetic output
s = s/max(s); sound(s);