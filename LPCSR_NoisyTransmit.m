% LPCSR_NoisyTransmit Transmission of LPC parameters over a simulated
% channel with random noise
%
%   params = LPCSR_NoisyTransmit(params,order,fs,volume) returns the 
%   input vector params with noise of amplitude volume added or, in the case
%   of the voiced/unvoiced detection parameter V, randomly altered.
%
%   LPC Speech Recognition Project
%   ECE 529 Spring 2014
%   Daniel Ford

function params = LPCSR_NoisyTransmit(params,order,fs,volume)

% turn noise off if input parameter is zero
if volume == 0
  vol = 0;
else
  vol = 10^(volume/20);
end

pmin = int32(fs/350);
pmax = int32(fs/80);

% add independent noise to each param

% gain
params(1) = params(1) + vol*(2*(rand-0.5));

% line spectral frequency representations of LPC coeffs
for i=2:order+1
  params(i) = params(i) + vol*(pi*rand);
  if params(i) < 0 params(i) = 0; end
  if params(i) > pi params(i) = pi; end
end

% pitch period
pitchidx = order+2;
params(pitchidx) = params(pitchidx) + vol*(pmin-pmax)*rand;
if vol ~= 0
  if params(pitchidx) > pmax params(pitchidx) = pmax; end
  if params(pitchidx) < pmin params(pitchidx) = pmin; end
end

% voiced/unvoiced
if vol ~= 0
  if rand > 0.5
    if params(order+3) == 0
      params(order+3) = 1;
      return;
    else
      params(order+3) = 0;
    end  
  end 
end  
