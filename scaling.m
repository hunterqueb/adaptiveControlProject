clc; clear;

%%-------------------------------Parameters------------------------------%%
beta = 0.14;            %inverse scale height [km^-1] (page 381)
r_e = 6378.137;         %earth radius [km] (page 381)
g_s = 9.81;             %acceleration of gravity at earth surface [m/s^2]
m = 5498.22;            %Apollo 10 pre-entry mass [kg]
S = 12.017;             %Apollo 10 reference area [m^2]
Cd = 1.2569;            %averaged fit for Cd
Cl = 0.40815;           %averaged fit for Cl
rho_s = 1.225;          %atmospheric density at earth surface [kg/m^3] (page 381)

%%----------------------------Initial Values-----------------------------%%
r0 = 6498.27;                   %entry radius [km]
v0 = 11.06715;                  %entry velocity [km/s] (pg 377)
gamma0 = deg2rad(-6.6198381);   %entry flight path angle

mbar = m;           %mass [kg]
lbar = r_e;         %length [km]
vbar = v0;          %velocity [km/s]
tbar = lbar/vbar;   %time [s]
abar = vbar/tbar;   %acceleration [km/s^2]
fbar = mbar*abar;   %force [kg*km/s^2]
angbar = gamma0;    %angle [rad]

%%------------------------------Scaled Values----------------------------%%
m = m/mbar;
r0 = r0/lbar;
v0 = v0/vbar;
gamma0 = gamma0/angbar;
g_s = (g_s/1000)/abar;
S = (S/(1000^2))/(lbar^2);
beta = beta*lbar;
rho_s = (rho_s*1000^3)/mbar*(lbar^3);

x0 = [r0;v0;gamma0];
params = [m;g_s;S;beta;rho_s];
save('scaled.mat','x0',"params")
