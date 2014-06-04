% LPCSR_DecodeParams Extraction of individual parameters from vector and
% conversion from line spectral frequencies to LPC coefficients
%
%   [B,A,P,V] = LPCSR_DecodeParams(params,order) extracts frame gain B,
%   LPC coefficients A, pitch period P, and voiced/unvoiced metric V from
%   the params vector. Extraction includes converting the line spectral
%   frequencies in params into LPC coefficients.
%
%   LPC Speech Recognition Project
%   ECE 529 Spring 2014
%   Daniel Ford

function [B,A,P,V] = LPCSR_DecodeParams(params,order)

% extract separate params from vector
B = params(1);
lsfs = params(2:order+1);
P = params(order+2);
V = params(order+3);

% convert line spectral frequencies/line spectral pairs to LPC coeffs
A = lsf2poly(lsfs);
