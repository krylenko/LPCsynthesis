% LPCSR_AddOverlap Frame overlapping and addition to concatenate complete
% output sample
  %
  %   [s,e,g,pd] = LPCSR_AddOverlap(sout,excit,L,R,s,e,g,pd,n) adds the
  %   L-length input frames sout and excit to the following existing output
  %   arrays with R samples of frame offset:
  %     s: synthesized output array
  %     e: complete excitation array
  %     g: complete gain history
  %     pd: complete pitch period array
  %
  %   When adding sout to the s array, sout is soft-clipped to [-1,1] by tanh.
  %
  %   LPC Speech Recognition Project
  %   ECE 529 Spring 2014
  %   Daniel Ford

function [s,e,g,pd] = LPCSR_AddOverlap(s,e,g,pd,sout,excit,b0,pitch,L,R,n)

for b=1:L                         % add frames w/ R samples overlap
  if n==1
    s(b) = tanh(sout(b));         % add values w/ soft clipping
    e(b) = excit(b); g(b) = b0; pd(b) = pitch;
  else
    s(n+b) = tanh(s(n+b) + sout(b));  % add values w/ soft clipping
    e(n+b) = excit(b); g(n+b) = b0; pd(n+b) = pitch;
  end
end