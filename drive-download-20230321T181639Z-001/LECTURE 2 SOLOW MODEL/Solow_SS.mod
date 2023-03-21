%  This file uses Dynare's perfect foresight solver to study the transition behavior of
%  simple Solow-Swan economy with Cobb-Douglas production function to its steady state. 

% It starts the simulation with a capital stock corresponding to 90% of its steady state value.
%  Notes: Because the model is purely backward-looking, only an initval-block is required.
%  The endval block's only purpose here is to provide starting values for the perfect foresight solver

% //****************************************************************************
% //Define variables
% //****************************************************************************
var
c                   ${c}$ (long_name='consumption (intensive form)')
k                   ${k}$ (long_name='capital (intensive form)')
y                   ${y}$ (long_name='output (intensive form)')
invest              ${i}$ (long_name='investment (intensive form)')
log_c               ${\log c}$ (long_name='log consumption (intensive form)')
log_k               ${\log k}$ (long_name='log capital (intensive form)')
log_y               ${\log y}$ (long_name='log output (intensive form)')
log_invest          ${\log i}$ (long_name='log investment (intensive form)')
g_k_aggregate       ${\Delta K}$ (long_name='Growth rate aggregate capital')
g_k_per_capita      ${\Delta \kappa}$ (long_name='Growth rate capital per capita')
g_k_intensive       ${\Delta k}$ (long_name='Growth rate capital in intensive form')
;
% //****************************************************************************
% //Define predetermined variables
% //****************************************************************************

predetermined_variables k;

% //****************************************************************************
% //Define parameters
% //****************************************************************************
parameters
s           ${s}$ (long_name='saving rate')
alpha       ${\alpha}$ (long_name='capital share production function')
delta       ${\delta}$ (long_name='depreciation rate')
n           ${n}$ (long_name='population growth rate')
g           ${g}$ (long_name='technology growth rate')
;

% //****************************************************************************
% //set parameters
% //****************************************************************************
s=0.2;
alpha=0.3;
delta=0.1;
n=0.01;
g=0.02;
% g_initial=0.02;

% //****************************************************************************
% //enter the model equations (model-block)
% //****************************************************************************
model;
% [name='Law of motion capital']
(1+n+g+n*g)*k(+1)=(1-delta)*k+invest;
% [name='resource constraint']
invest+c=y;
% [name='behavioral rule savings']
c=(1-s)*y;
% [name='production function']
y=k^alpha;
% [name='Definition log output']
log_y=log(y);
% [name='Definition log consumption']
log_c=log(c);
% [name='Definition log investment']
log_invest=log(invest);
% [name='Definition capital decided upon today']
log_k=log(k(+1));
% [name='Definition capital growth rate between today and tomorrow ']
g_k_intensive=log(k(+1))-log(k); %//this is capital growth rate between today and tomorrow that is decided upon based on the growth rate of labor augmenting technology between today and tomorrow
% [name='Definition capital per capita growth rate between today and tomorrow']
g_k_per_capita=g_k_intensive+g; 
% [name='Definition aggregate capital growth rate between today and tomorrow']
g_k_aggregate=g_k_intensive+g+n; 
end;

% //****************************************************************************
% //initval-block: set initial condition of capital to 90% of steady state value 
% //****************************************************************************
initval;
    k=0.9*((delta+n+g+n*g)/s)^(1/(alpha-1));
    y=k^alpha;
    c=(1-s)*y;
    invest=y-c;
    log_y=log(y);
    log_c=log(c);
    log_invest=log(invest);
    log_k=log(k);
    g_k_intensive=0;
    g_k_per_capita=g_k_intensive+g; 
    g_k_aggregate=g_k_intensive+g+n;
end;

% //****************************************************************************
% //endval-block: set terminal condition to steady state value
% //****************************************************************************
endval;
    k=((delta+n+g+n*g)/s)^(1/(alpha-1));
    y=k^alpha;
    c=(1-s)*y;
    invest=y-c;
    log_y=log(y);
    log_c=log(c);
    log_invest=log(invest);
    log_k=log(k);
    g_k_intensive=0;
    g_k_per_capita=g_k_intensive+g; 
    g_k_aggregate=g_k_intensive+g+n;
end;
% //****************************************************************************
% //resid command: show residuals based on last entered block 
% //(should be 0 if our SS was correct)
% //****************************************************************************
resid;

% //****************************************************************************
% //perfect_foresight_setup: set up the simulation for 200 periods
% //you can check the settings in oo_.endo_simul (and oo_.exo_simul if there 
% //were exogenous variables)
% //****************************************************************************
perfect_foresight_setup(periods=200);

% //****************************************************************************
% //perfect_foresight_solver: compute the solution
% //****************************************************************************
perfect_foresight_solver;

% //****************************************************************************
% //rplot command: display simulation results
% //****************************************************************************
rplot  k; % g_k_aggregate
rplot g_k_per_capita;
rplot g_k_aggregate;
% rplot log_c;
% rplot log_y;

write_latex_definitions;
write_latex_parameter_table;
write_latex_original_model;
%write_latex_dynamic_model;
write_latex_static_model;
% write_latex_steady_state_model;
collect_latex_files;