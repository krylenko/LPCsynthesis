% LPCSR_LoopWrapper Iterate over frames of an input sample to perform 
% LPC analysis and synthesis
  %
  %   [xin,s,e,g,pd] = LPCSR_LoopWrapper(filename,Lm,Rm,order,volume)
  %   slices the input file specified by filename into frames of length
  %   Lm with offset Rm (both in ms) and iterates over frames to produce
  %   the following output arrays:
  %     xin: The original input audio in Matlab array format
  %     s: synthesized output array
  %     e: complete excitation array
  %     g: complete gain history
  %     pd: complete pitch period array 
  %   
  %   When finished running, it shows a text listing of relevant parameter
  %   values and output metrics, such as compression ratio.
  %
  %   LPC Speech Recognition Project
  %   ECE 529 Spring 2014
  %   Daniel Ford

function [xin,s,e,g,pd] = LPCSR_LoopWrapper(filename,Lm,Rm,order,volume);

% read in audio sample and preprocess
[x,fs] = audioread(filename);
xin = LPCSR_Prefilter(x,fs);

L=round(Lm*fs/1000);    % convert to samples
R=round(Rm*fs/1000);    % convert to samples

% limit inputs if necessary
if Lm<1 Lm=1; end
if Lm>length(xin) Lm=length(xin); end

if Rm<1 Rm=1; end
if Rm>length(xin) Rm=length(xin); end

if order<1 order=1; end
if order>20 order=20; end

% init arrays
s=zeros((length(xin)+L),1);   % output array
e=zeros((length(xin)+L),1);   % excitation array for plotting
g=zeros((length(xin)+L),1);   % gain array for plotting
pd=zeros((length(xin)+L),1);  % pitch period array for plotting

% analyze and re-synthesize speech
n = 1; nframes = 0;
while (n+L-1 <= length(xin))

  % grab a frame of input 
  x=xin(n:n+L-1);                         

  % estimate pitch, LPC coeffs, voiced/unvoiced detection
  [b0,a,pitch,v] = LPCSR_Analysis(x,fs,L,order);
  
  % encode LPC coeffs into line spectral pairs and concatenate
  prms = LPCSR_EncodeParams(b0,a,pitch,v);

  % emulate transmission over channel w/ 'volume' dB of noise 
  params = LPCSR_NoisyTransmit(prms,order,fs,volume);

  % decode received parameters
  [B,A,P,V] = LPCSR_DecodeParams(params,order);

  % ***** plotting below for paper only
  %{
  % pull out and plot an input frame and filter info
  if mod(nframes,57) == 0
    [H1 w] = freqz(b0,a); H1 = 20*log10(abs(H1));
    [H2 w] = freqz(B,A); H2 = 20*log10(abs(H2));
    subplot(121); plot(x);
    title('Input Frame Audio');
    xlabel('Sample (frame units)'); ylabel('Amplitude');
    grid on; axis([0 L -0.5 0.5]);
    axis 'auto y';
    subplot(122);
    plot(w/pi,H1,w/pi,H2,'r')
    grid on; title('Frequency Response of Estimated LPC Filters');
    xlabel('Normalized frequency (rad)');
    ylabel('Magnitude (dB)');
    legend('original estimate','received over channel');
  end  
  %}
  
  % synthesize speech output based on parameters
  [sout,excit] = LPCSR_Synthesis(B,A,P,V,L,order);

  % add frames w/ overlap to create final signal 
  [s,e,g,pd] = LPCSR_AddOverlap(s,e,g,pd,sout,excit,B,P,L,R,n);

  % increment counters
  n=n+R;                            
  nframes=nframes+1;

end

% display info
clc;
insize = length(xin)*2; outsize = (order+3)*2;
fprintf(1,'****************************\n');
fprintf(1,'*  Post-Processing Report  *\n');
fprintf(1,'****************************\n\n');

fprintf(1,'****** input ******\n');
fprintf(1,'Sampling rate (Hz): %d\n',fs);
fprintf(1,'Input length (samples): %d\n',length(xin));
fprintf(1,'Input length (seconds): %f\n',length(xin)/fs);
if volume == 0
  fprintf(1,'Channel noise volume (dB): none\n\n',volume);
else
  fprintf(1,'Channel noise volume (dB): %.2f\n\n',volume);
end

fprintf(1,'****** output ******\n');
fprintf(1,'Analysis/synthesis frames: %d\n',nframes);
fprintf(1,'Frame length (ms): %d\n',Lm);
fprintf(1,'Frame offset (ms): %d\n',Rm);
fprintf(1,'Parameter length per frame (bytes): %d\n\n',outsize); % 16-bit

fprintf(1,'****** compression ******\n');
fprintf(1,'Input size (bytes): %d\n',insize); % assumes 16-bit
fprintf(1,'Transmitted size (bytes): %d\n',nframes*outsize);
fprintf(1,'Compression ratio: %.2f\n',insize/(nframes*outsize));
fprintf(1,'Transmission bit rate (kbps): %.2f\n\n',...
(8/1024)*(nframes*outsize)/(length(xin)/fs));