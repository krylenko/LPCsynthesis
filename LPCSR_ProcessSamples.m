% LPCSR_ProcessSamples Loading, preprocessing, and analysis of speech samples
% with LPC to create database for recognition
%
%   [samples,analysis_db] = LPCSR_ProcessSamples(order) runs LPC analysis with
%   filter order 'order' on all the samples in the list 'samples' and returns
%   the sample list and the array analysis_db of LPC coefficients, frame gains,
%   pitch periods, and voiced/unvoiced metrics for all samples (one row per
%   sample). Requires the listed speech samples to exist on the current
%   Matlab path.
%
%   LPC Speech Recognition Project
%   ECE 529 Spring 2014
%   Daniel Ford

function [samples,analysis_db] = LPCSR_ProcessSamples(order)

disp('Processing samples...')

samples = {
'a1.wav'; 'a2.wav'; 'a3.wav'; 'a4.wav'; 'a5.wav'; ...
'e1.wav'; 'e2.wav'; 'e3.wav'; 'e4.wav'; 'e5.wav'; ...
'i1.wav'; 'i2.wav'; 'i3.wav'; 'i4.wav'; 'i5.wav'; ...
'o1.wav'; 'o2.wav'; 'o3.wav'; 'o4.wav'; 'o5.wav'; ...
'u1.wav'; 'u2.wav'; 'u3.wav'; 'u4.wav'; 'u5.wav'; ...
'ah1.wav'; 'ah2.wav'; 'ah3.wav'; 'ah4.wav'; 'ah5.wav'; ...
's1.wav'; 's2.wav'; 's3.wav'; 's4.wav'; 's5.wav'; ...
'z1.wav'; 'z2.wav'; 'z3.wav'; 'z4.wav'; 'z5.wav'; };

%analysis_db = [];             % initialize matrix to hold LPC coeffs

% initialize matrix to hold LPC coeffs
analysis_db = zeros(length(samples),order+4);     
for i=1:length(samples)         % loop over samples
  [x,fs] = audioread(samples{i});        % read one sample
  sample = LPCSR_Prefilter(x,fs);         % normalize and apply BPF

  % estimate coeffs, pitch info for entire sample
  [b0,a,pitch,v] = LPCSR_Analysis(sample,fs,length(sample),order);

  % concatenate into recognition matrix
  %temp = [v pitch b0 a']
  for j=1:order+4
    if j == 1 analysis_db(i,j) = v;
    elseif j == 2 analysis_db(i,j) = pitch;
    elseif j == 3 analysis_db(i,j) = b0;
    elseif j > 3 analysis_db(i,j) = a(j-3); end
  end
end
