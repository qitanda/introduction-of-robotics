function [fai, theta, psai, P] = exp2rpy(T)
T =   [ 0.7500   -0.0474    0.6597    1.0000
    0.4330    0.7891   -0.3062    1.0000
   -0.5000    0.6124    0.6124    1.0000
         0         0         0    1.0000];
theta = atan2(-T(3, 1), sqrt(T(3, 2)^2+T(3, 3)^2));
fai = atan2(T(2, 1)/cos(theta), T(1, 1)/cos(theta));
psai = atan2(T(3, 2)/cos(theta), T(3, 3)/cos(theta));
P = T(1:3,4);