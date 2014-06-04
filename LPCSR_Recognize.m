% LPCSR_Recognize Matching of an input sample to an existing sample database
%
%   match = LPCSR_Recognize(x,fs,order,analysis_db,select) analyzes the input
%   sample X, calculates the L2 norm between its LPC coefficients and the
%   samples in analysis_db, and returns the index match of the closest fit
%   extant in the analysis_db array of analysis parameters of the previously
%   processed sample database. 
%
%   LPC Speech Recognition Project
%   ECE 529 Spring 2014
%   Daniel Ford

function match = LPCSR_Recognize(x,fs,order,analysis_db,select)

% perform LPC analysis
sample = LPCSR_Prefilter(x,fs);
[b0,a,pitch,v] = LPCSR_Analysis(sample,fs,length(sample),order);

% calculate distance measure 
distance = 0; mindist = 10; idx = 0;
[m,n] = size(analysis_db);
for i=1:m 
  % only check if voiced/unvoiced matches  
  if v == analysis_db(i)    
    for j=2:length(a)     % skip first coeff of 1
      % calculate least squares distance of sum of LPC coeffs
      distance = distance + (a(j)-analysis_db(i,j+3))^2; 
    end
    distance = sqrt(distance);
    if i==1
      mindist = distance;
    else
      if distance < mindist
        mindist = distance;
        idx = i;
      end
    end
  end
end

mindist;
match = idx;