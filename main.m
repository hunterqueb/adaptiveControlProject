
clear;

tSim = 10;

g = 9.81;
m = 1;
S = 1;
Cd = 0.02;
Cl = 0.02;
v0 = 200;
rho = 1.22;

A = [0 0 v0;
     0 -rho*Cd*S/(2*m) -g;
     0 rho*Cl*S/(2*m) 0];

B = [0;0;1];

Q = eye(3);
R = eye(1);

K = lqr(A,B,Q,R);

Aref =  A-B*K;
Bref = [-1;0;0];

Gama = 1;
Theta = [0 0 1];

Gamax = 100*eye(3);
Gamar = 100;
Gamat = 100*eye(3);
Qref = diag([1 1 1]);

P = lyap(Aref',Q);

x0 = [300;v0;deg2rad(5)];

sim('example_9_3')