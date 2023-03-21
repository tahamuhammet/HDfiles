% BASIC SOLOW MODEL - deterministic model with three variables: capital, consumption and output
% Remember that all variables grow by pop.growth (n), hence we detrend all variables and define them in per capita terms
% Declare variables and parameters

var c y k ; % three variables per capita terms
varexo A; % tech. shock
parameters alpha delta s n;

alpha = 0.40; % share of capita
delta = 0.10; % depreciation rate
s = 0.10; % saving rate
n = 0.05; % population growth rate

model; % all variables are defined in exp(x) form to compute impulse response functions as percentage deviation from SS

% exp(y) = A*(exp(k(-1))^(alpha));
% exp(c) = (1-s)*exp(y);
% (1+n)*exp(k) = s*exp(y(-1)) + (1-delta)*exp(k(-1));

y = A*(k(-1)^alpha);
c = (1-s)*y;
(1+n)*k = s*y(-1) + (1-delta)*k(-1);
end;



% steady_state_model;
% k = ((s*A)/(n+delta))^(1/(1-alpha));
% y = A*((s*A)/(n+delta))^(alpha/(1-alpha));
% c = (1-s)*A*((s*A)/(n+delta))^(alpha/(1-alpha));
% end;

initval; % Since the model is written in log form, the (approximate) steady state values in this block are also written in log form.
% c = log(0.675);
% y = log(0.75);
% k = log(0.5);
% A = 1;
% 
c = 0.675;
y = 0.75;
k = 0.5;
A = 1;
end;

steady; % The command steady forces all initial values to the (exact) steady states
check;

shocks;
var A;
periods 4:6; % shock hits during period 4 to 6
values 1.2; % We are interested in analyzing the effect of increasing productivity from A = 1 to A = 1.2
end;

steady;


perfect_foresight_setup(periods=100);
perfect_foresight_solver; % solves for the perfect foresight and without this all horizons will be the SS as they are
%simul(periods=100); % We simulate the model for 100 periods

rplot c y k; % IRF are plotted on a single diagram
rplot A; % IRF plotted for A separately