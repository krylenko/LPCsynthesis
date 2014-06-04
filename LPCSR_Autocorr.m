% LPCSR_Autocorr Pitch estimation and voiced/unvoiced detection for an input
% sample
%
%   [Tp,V] = LPCSR_Autocorr(X,pitchmin,pitchmax) computes the autocorrelation
%   of input sample X to determine whether X is periodic and, if so, estimate
%   its fundamental pitch period Tp in samples within the range [pitchmin,
%   pitchmax]. If X is periodic, the voiced/unvoiced parameter V will be set
%   to 1. If not, both V and Tp will be 0. 
%
%   LPC Speech Recognition Project
%   ECE 529 Spring 2014
%   Daniel Ford

function [Tp,V] = LPCSR_Autocorr(X,pitchmin,pitchmax)

kmin = pitchmin;
kmax = pitchmax;
N = length(X);
Rn = zeros(length(X),1); 

% measure max value in X
max = X(1);
for i=1:length(X)
  if X(i) > max
    max = X(i);
  end
end
CL = 0.3*max;   

% perform clipping
for i=1:length(X) 
  if X(i) > CL
    X(i) = 1;
  else
    if X(i) < -CL
      X(i) = -1;
    else
      X(i) = 0;
    end  
  end
end

% do autocorrelation
for k=kmin:kmax
  for m=1:length(X)-k
    Rn(k) = Rn(k) + X(m)*X(m+k);
  end
end  

% calculate Rn(0)
R0 = 0;
for m=1:length(X)
  R0 = R0 + X(m)*X(m);
end

% find max R and delay k
Rmax = Rn(1); kidx = 1;
for k=1:length(Rn)
  if Rn(k) > Rmax
    Rmax = Rn(k);         % save max R
    kidx = k + kmin - 1;  % save pitch period  
  end
end

% decide voiced or unvoiced
if Rmax > 0.1*R0  % lower creates more voiced frames
                  % higher values w/ unfiltered noise are good too
  V = 1;
  Tp = kidx;
else
  V = 0;
  Tp = 0;
end

end % function end