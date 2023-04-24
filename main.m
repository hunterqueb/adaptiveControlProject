
clear; close all
Ts = 0.01;
tSim = 550;
% tSim = 100;
%use neural network to figure out relationship between mach number and
%Cl,Cd?
% x0 = load('scaled.mat','x0');
% params = load('scaled.mat','params');
%%-------------------------------Parameters------------------------------%%
% taken from chapter 12 from hicks atmospheric reentry
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
theta0 = deg2rad(174.24384);    %entry longitude
phi0 = deg2rad(23.51457);      %entry latitude
h0 = 123.55077;                 %entry altitude [km]
psi0 = deg2rad(18.0683);        %entry heading angle
%%------------------------------Conversions------------------------------%%
beta = beta/1000;   %[m^-1]
r_e = r_e*1000;     %[m]
r0 = r0*1000;       %[m]
v0 = v0*1000;       %[m/s]
% S = S/(1000)^2;
% rho_s = rho_s/(1000)^3;
% g_s = g_s/1000;

%%------------------------------Equations--------------------------------%%
%g = g_s*(r_e/r)^2;                 %gravity equation
%rho = rho_s*exp(-beta*(r-r_e));    %density equation
%L = 0.5*(rho*Cl*S*V^2);            %lift force equation
%D = 0.5*(rho*Cd*S*V^2);            %drag force equation

%%----------------------------System Dynamics----------------------------%%
% x0 = load('scaled.mat','x0');
% params = load('scaled.mat','params');
% x0 = struct2array(x0);
% params = struct2array(params);
% m = params(1); g_s = params(2); S = params(3); beta = params(4); rho_s = params(5);
rho = rho_s;
g = g_s;

A = [0 0 v0;
     0 -rho*Cd*S/(2*m) -g;
     0 rho*Cl*S/(2*m) 0];

B = [0;0;1];

Q = eye(3);
R = eye(1);

K = lqr(A,B,Q,R);

%%----------------------------Reference Model----------------------------%%
Aref =  A-B*K;
Bref = [0;0;1];

%% --------------------------Adaptive Parameters--------------------------%%
Gama = 1;
Theta = [0 0 1];

Gamax = .1*eye(3);
Gamar = .1;
Gamat = .1*eye(3);
Qref = diag([.1 0 0]);

P = lyap(Aref',Qref);

%% ----------------------------System Conditions----------------------------%%

x0 = [r0;v0;gamma0];            %initial conditions
r_des = 10 * 1000; % 10 km above the surface
load("network.mat",'net')


tspan = linspace(0,550,1000);
[T,X] = ode45(@(t,x) command(t,x,net),tspan,[r0;theta0;phi0;v0;gamma0;psi0]);
% [T,X] = ode45(@(t,x) command3(t,x),tspan,[r0;v0;gamma0]);

figure
plot(T,X(:,1)/1000-r_e/1000)
xlabel('Time [s]')
ylabel('Altitude [km]')
%% 

%%----------------------------Simulation----------------------------%%
sim('EDLSim');


%%----------------------------Plotting----------------------------%%

figure
plot(radiusTracking(:,1),(radiusTracking(:,2:end)-r_e)/1000)
grid on
legend('Signal','Plant','Reference Model')
xlabel('Seconds')
ylabel('Altitude (m)')

figure
plot(u.time,squeeze(u.signals.values))
grid on
