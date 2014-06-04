% LPCSR_EncodeParams Conversion of LPC parameters into more robust line
% spectral frequency form and concatenation of parameters into a single vector
%
%   [params] = LPCSR_EncodeParams(b0,a,pitch,v) converts the LPC coefficients a
%   to line spectral frequencies (LSFs), then assembles a single parameter
%   vector params containing the LSFs, gain b0, pitch period, and voiced/
%   unvoiced metric V.
%
%   LPC Speech Recognition Project
%   ECE 529 Spring 2014
%   Daniel Ford

function [params] = LPCSR_EncodeParams(b0,a,pitch,v)

% convert LPC coeffs to line spectral frequencies/line spectral pairs
lsfs = poly2lsf(a);

% concatenate parameters: [b0 lsfs pitch v]
params = [double(b0) lsfs' double(pitch) double(v)];
