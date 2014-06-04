% LPCSR_PlotAnalysis Plotting of analysis and synthesis variables 
%
%   LPCSR_PlotAnalysis(orig,s,e,g,pd) creates a multi-pane plot showing the
%   input audio orig, per-frame detected pitch period pd, per-frame excitation
%   signal e with per-frame gain g overplotted, and the complete synthesized
%   audio output s.
%
%   LPC Speech Recognition Project
%   ECE 529 Spring 2014
%   Daniel Ford

function LPCSR_PlotAnalysis(orig,s,e,g,pd)

% original audio
subplot(4,1,1);
plot(orig)
axis([0 length(orig) -1 1]);
ylabel('volume'); title('Input Audio (filtered)');

% voiced/unvoiced detection and pitch period
subplot(4,1,2)
plot(pd,'m');
axis([0 length(orig) 0 150]);
ylabel('period (samples)'); title('Detected Pitch (0 = unvoiced)');
grid on;

% excitation w/ gain overplot
subplot(4,1,3);
idx = [1:1:length(s)];
zeroCheck = (pd==0);
e_noise = e; e_voice = e;
e_noise(~zeroCheck) = NaN;
e_voice(zeroCheck) = NaN;
plot(idx,e_voice,'g',idx,e_noise,'c',idx,g,'k');
legend('voiced','unvoiced','gain');
axis([0 length(orig) -1.25 1.25]);
ylabel('amplitude');
title('Excitation Signal and Gain');

% synthesized output
subplot(4,1,4);
plot(s,'r')
axis([0 length(orig) -1 1]);
ylabel('volume'); title('Synthesized Output');
xlabel('time (samples)'); 