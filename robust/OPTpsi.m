function psi=OPTpsi(x,c)
%OPTpsi computes psi function (derivative of rho function) for optimal weight function
%
%<a href="matlab: docsearch('optpsi')">Link to the help function</a>
%
%
%  Required input arguments:
%
%    x:         n x 1 vector containing residuals or Mahalanobis distances
%               for the n units of the sample
%    c :        scalar greater than 0 which controls the robustness/efficiency of the estimator
%               (beta in regression or mu in the location case ...)
%
% Function OPTpsi transforms vector x as follows
%
%               |  (1/3.25*c^2) x                                                        |x|<=2c
%               |   
%   \psi(x,c) = |  (1/3.25) * (-1.944 * x / c^2 + 1.728 * x.^3 / c^4 - 0.312 * x.^5 / c^6 + 0.016 * x.^7 / c^8)     2c<=|x|<=3c
%               |
%               |   0                                                                      |x|>3c                              
%
%
% Remark: Optimal psi-function is almost linear around u = 0 in accordance with
% Winsor's principle that all distributions are normal in the middle.
% This means that  \psi (u)/u is approximately constant over the linear region of \psi,
% so the points in that region tend to get equal weight.
%
%
% References:
%
% ``Robust Statistics, Theory and Methods'' by Maronna, Martin and Yohai;
% Wiley 2006.
%
%
% Copyright 2008-2014.
% Written by FSDA team
%
%
%<a href="matlab: docsearch('OPTpsi')">Link to the help page for this function</a>
% Last modified 08-Dec-2013
%
% Examples:

%{

x=-6:0.01:6;
psiOPT=OPTpsi(x,1.2);
plot(x,psiOPT)
xlabel('x','Interpreter','Latex')
ylabel('$\psi (x)$','Interpreter','Latex')

%}

%% Beginning of code

% Computes Standardized optimal psi function (first derivative of rho function)
% \rho'(x)

psi = zeros(length(x),1);
absx=abs(x);

% r /(3.25c^2) if r <=2*c
inds1 = absx <= 2*c;
psi(inds1) = x(inds1) / (3.25*c^2);

% 1/(3.25) * ( -1.944* (r/c)^2 .... +8*0.002 (r/c)^8 )    if    2c< r <3c
inds1=(absx > 2*c)&(absx <= 3*c);
x1 = x(inds1);
psi(inds1) = (-1.944 * x1 / c^2 + 1.728 * x1.^3 / c^4 - 0.312 * x1.^5 / c^6 + 0.016 * x1.^7 / c^8) / 3.25;

% 0 if r >3*c

end
