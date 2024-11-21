function T = rpy2exp(fai, theta, psai, P)
fai = acos(-1)/4;
theta = acos(-1)/6;
psai = acos(-1)/6;
P = [1, 1, 1]'
R = [cos(psai)*cos(theta), -sin(psai)*cos(fai)+cos(psai)*sin(theta)*sin(fai), sin(psai)*sin(fai)+cos(psai)*sin(theta)*cos(fai)
     sin(psai)*cos(theta), cos(psai)*cos(fai)+sin(psai)*sin(theta)*sin(fai), -cos(psai)*sin(fai)+cos(psai)*sin(theta)*cos(fai)
     -sin(theta),          cos(theta)*sin(fai),                               cos(theta)*cos(fai)];
T = [R, P
    [0, 0, 0, 1]];
T