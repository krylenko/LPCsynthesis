% LPCSR_Prefilter Preprocessing of input sample before LPC analysis
%
%   filtOut = LPCSR_Prefilter(in,fs) returns the input sample after  
%   normalization to [-1,1], bandpass filtering with a fourth-order
%   digital Butterworth filter with passband 40-1000 Hz and sampling
%   rate fs, and renormalization to [-1, 1].
%
%   LPC Speech Recognition Project
%   ECE 529 Spring 2014
%   Daniel Ford

function filtOut = LPCSR_Prefilter(in,fs)

% normalize input to +/- 1
if max(in) > abs(min(in))
  in = in/max(in);
else
  in = in/abs(min(in));
end

% second-order BPF, 40-1000 Hz
[b_bpf,a_bpf] = butter(2,[40/(fs/2),1000/(fs/2)]);
filtOut = filter(b_bpf,a_bpf,in);

% normalize again to compensate for filtering
if max(in) > abs(min(in))
  in = in/max(in);
else
  in = in/abs(min(in));
end
