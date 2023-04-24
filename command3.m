function xdot = command3(t,x,net)
r = x(1); v = x(2); gamma = x(3);

% sigma = net(t);
sigma = t;
sigma = deg2rad(sigma);

beta = 0.14;            %inverse scale height [km^-1] (page 381)
r_e = 6378.137;         %earth radius [km] (page 381)
g_s = 9.81;             %acceleration of gravity at earth surface [m/s^2]
m = 5498.22;            %Apollo 10 pre-entry mass [kg]
S = 12.017;             %Apollo 10 reference area [m^2]
Cd = 1.2569;            %averaged fit for Cd
Cl = 0.40815;           %averaged fit for Cl
rho_s = 1.225;          %atmospheric density at earth surface [kg/m^3] (page 381)

beta = beta/1000;   %[m^-1]
r_e = r_e*1000;     %[m]

g = g_s*(r_e/r)^2;
if r == r_e
    rho = rho_s; 
else
    rho = 0.5*rho_s*exp(-beta*(r-r_e));
end
L = 0.5*rho*Cl*S*v^2;
D = 0.5*rho*Cd*S*v^2;

%xdot = [rdot vdot gammadot]';

rdot = v*sin(gamma);
vdot = -D/m - g*sin(gamma);
gammadot = (1/v)*((L/m)*cos(sigma) - g*cos(gamma) + ((v^2)/r)*cos(gamma));

xdot = [rdot vdot gammadot]';
end