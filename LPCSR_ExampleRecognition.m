% LPCSR_ExampleRecognition Example script to demonstrate use of LPCSR for
% speech recognition
%
%   LPCSR_ExampleRecognition allows the user to choose to try recognition
%   of a single selectable sample, or to run multiple trials with added noise
%   and automatic variation of the signal-to-noise ratio to evaluate the
%   code's performance. In the latter case, the script plots the recognition
%   results averaged over the specified number of trials per SNR point.   
% 
%   LPC Speech Recognition Project
%   ECE 529 Spring 2014
%   Daniel Ford

% housekeeping
clear all; clc;

% process sample database
order = 10;
[samples,analysis_db] = LPCSR_ProcessSamples(order);

% user info
fprintf(1,'*******************************************\n');
fprintf(1,'*  LPC Speech Recognition Example Script  *\n');
fprintf(1,'*******************************************\n\n');

% user input
choice ...
= input('Enter 1 for single example, 2 to average over multiple trials: ');

% single example
if choice == 1

  % prompt user for sample to test
  idx = input('\nEnter index of sample to choose for recognition test: ');
  if idx < 1 idx = 1; end
  if idx > length(samples) idx = length(samples); end
  vol = input('Enter noise volume in db: ');
  
  % load selected sample
  [x,fs] = audioread(samples{idx});
  
  % add noise
  noise = 10^(vol/20)*(2*(rand(length(x),1)-0.5));
  x = x + noise;
  
  % perform recognition  
  match = LPCSR_Recognize(x,fs,order,analysis_db,idx);  

  % display original and matched samples
  fprintf('original: %s\n',samples{idx});
  if match ~= 0
    fprintf('matched: %s\n',samples{match});
  else
    disp('no match!');
  end
  fprintf('\n');

end  

% automated trials  
if choice == 2

  N = input('\nEnter number of SNR points (e.g., 25): '); 
  numsamples = input('Enter number of samples per SNR point (e.g., 10): ');

  % run recognition to plot accuracy
  vol = 1e-5;         % initial noise volume (-100 dB)
  matchctr = 0;       % number of exact matches
  SNR = 0;
  results = [];

  % start execution time clock
  timerVal = tic;
   
  % loop over SNR values
  for p=1:N  
  
    % loop over samples
    for k=1:numsamples

      % select a sample at random from the database
      idx = randi(length(samples),1);
      [x,fs] = audioread(samples{idx}); 
    
      % increase noise w/ each iteration
      noise = vol*10^(0.1*p)*(2*(rand(length(x),1)-0.5));

      % add noise, calc SNR
      SNR = SNR + 10*log10(var(x)/var(noise));
      y = x + noise;
      
      % try to match sample to database
      match = LPCSR_Recognize(y,fs,order,analysis_db,idx);
      if match == idx matchctr = matchctr + 1; end
    
    end
    results = [results; SNR/numsamples matchctr*100./numsamples];
    matchctr = 0; SNR = 0;
    
  end
      
  % show elapsed time
  fprintf(1,'\nElapsed time = %.3f seconds\n\n',toc(timerVal));

  % plot results
  %results = sortrows(results);
  plot(results(:,1),results(:,2));
  set(gca,'xdir','reverse');
  axis([0 10 0 100]);
  axis 'auto x';
  grid on
  title('Noisy Speech Recognition Accuracy');
  xlabel('Average Signal-to-Noise Ratio (dB)');
  ylabel('Correct Matches (%)');
end