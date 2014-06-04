% LPCSR_Prony Estimation of filter coefficients using Prony's method
  %
  %   [a,err] = LPCSR_Prony(x,p,q) returns estimated denominator
  %   coefficients a and estimation error err after running Prony's
  %   method on input sample x, assuming q zeros and p poles in the model.
  %   It uses the matrix pseudoinverse to avoid problems with numerically
  %   ill-conditioned input samples.
  %
  %   The sequence x is modeled as the unit sample response of
  %   a filter having a system function of the form H(z) = B(z)/A(z) 
  %   The polynomials B(z) and A(z) are formed from the vectors
  %     b=[b(0), b(1), ... b(q)]
  %     a=[1   , a(1), ... a(p)]
  %   The input q defines the number of zeros in the model
  %   and p defines the number of poles.  The modeling error
  %   is returned in err.
  %
  %   see also ACM, COVM, PADE, SHANKS
  %
  %   ---------------------------------------------------------------
  %   copyright 1996, by M.H. Hayes.  For use with the book 
  %   "Statistical Digital Signal Processing and Modeling"
  %   (John Wiley & Sons, 1996).
  %   ---------------------------------------------------------------
  %
  %   LPC Speech Recognition Project
  %   ECE 529 Spring 2014
  %   Daniel Ford

function [a,err] = LPCSR_Prony(x,p,q)

x   = x(:);
N   = length(x);
if p+q>=length(x), error('Model order too large'), end
X   = convm(x,p+1);
Xq  = X(q+1:N+p-1,1:p);
a   = [1;pinv(-Xq)*X(q+2:N+p,1)];   % pseudoinverse version
err = x(q+2:N)'*X(q+2:N,1:p+1)*a;
end




