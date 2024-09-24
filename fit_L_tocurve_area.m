function [bestx, F] = fit_L_tocurve_area(x,y, plotit)
%[bestx, F] = fit_L_tocurve_area(x,y, plotit)

if nargin < 3
    plotit = 1;
end
x = x(:);
y = y(:);
%%
% P = [xbp m1 m2 b]
options = optimset('TolFun',1e-14, 'TolX', 1e-14, 'MaxFunEvals', 100000, 'MaxIter', 10000);
P0(1) = x(5);
P0(2) = (y(4)-y(2))/(x(4)-x(2));
P0(3) = (y(end)-y(end-1))/(x(end)-x(end-1));
P0(4) = y(5);

LB = [x(2)    -Inf -Inf  min(y)];
UB = [x(end-1) 0     0   max(y)];

[PF,RESNORM,RESIDUAL,EXITFLAG,OUTPUT] = lsqcurvefit(@Lcurve,P0,x,y, LB, UB, options);

bestx = ceil(PF(1));

yfit = Lcurve(PF, x);

% bpoint = 2:(length(x)-1);
% OBJ = zeros(1,length(bpoint));
% count = 0;
% 
% truearea = trapz(x,y);
% for ii = bpoint
%     count = count+1;
%     % fit first part
%     [fit_1, r_1] = lsfit(x(1:ii), y(1:ii));
%     % fit second part
%     [fit_2, r_2] = lsfit(x(ii:end), y(ii:end));
%     
%     %OBJ(count)=length(r_1)*sum((r_1).^2) + length(r_2)*sum((r_2).^2);
%     fitarea = trapz(x(1:ii),fit_1) + trapz(x(ii:end), fit_2);
%     OBJ(count) = abs(fitarea - truearea);
%     
%     
%end

%%
% [mv, mind] = min(OBJ);
% [fit_1, r_1, b1] = lsfit(x(1:bpoint(mind)), y(1:bpoint(mind)));
% [fit_2, r_2, b2] = lsfit(x(bpoint(mind):end), y(bpoint(mind):end));
%%
%intersection point
%bestx = ceil((b1(2)-b2(2))/(b2(1)-b1(1))); 

%%
F = 0;
if plotit
    F= figure('Color', 'w');
    %plot(x(1:bpoint(mind)),fit_1, 'g-')
    %hold on
    %plot(x(bpoint(mind):end),fit_2, 'b-')
    plot(x,y,'r.-')
    hold on
    plot(x,yfit,'k')
    box off
    axis tight
    ax = axis;
    set(gca, 'XLim', [x(1)-1, x(end)+1], 'YLim', [0 ax(4)], 'TickDir', 'out')
end

function [yhat, r, b] = lsfit(x,y)

n=1;
% Construct Vandermonde matrix.
V(:,n+1) = ones(length(x),1,class(x));
for j = n:-1:1
   V(:,j) = x.*V(:,j+1);
end

% Solve least squares problem.
[Q,R] = qr(V,0);
b = R\(Q'*y);   
yhat = V*b;  
r = y-yhat;

function Z = Lcurve(P, XDATA)
% P = [xbp m1 m2 b]

XDATA = XDATA-P(1);

% curve 1
Y1 = P(2)*XDATA + P(4);
% curve 2
Y2 = P(3)*XDATA + P(4);

Z = zeros(size(Y1));
Z(XDATA < 0) = Y1(XDATA < 0);
Z(XDATA >= 0) = Y2(XDATA >= 0);

