% LPCSR_Excite Generation of excitation frame for LPC synthesis
%
%   excitation = LPCSR_Excite(framelen,Tp,V) returns an excitation frame 
%   of length framelen. The excitation frame will be either a periodic
%   impulse train with period Tp samples or white noise, if Tp = 0. 
%
%   LPC Speech Recognition Project
%   ECE 529 Spring 2014
%   Daniel Ford

function excitation = LPCSR_Excite(framelen,Tp,V);

excitation = zeros(framelen,1);

impidx = 1; imp = 1;
for j=1:framelen
  if V==1                   % voiced
    excitation(j) = imp;
    if mod(impidx,Tp) == 0                % one impulse every Tp
      imp = 1;
    else
      imp = 0;
    end
    impidx = impidx + 1;
  else                      % unvoiced
    excitation(j) = 2*(rand-0.5);
  end
end