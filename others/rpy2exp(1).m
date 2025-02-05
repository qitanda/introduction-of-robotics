function [psi,theta]=rpy2exp(phi,alpha,ksi,p)
R1=[1 0 0;...
    0 cosd(phi) -sind(phi);...
    0 sind(phi) cosd(phi);];
R2=[cosd(alpha) 0 sind(alpha);...
    0 1 0;...
    -sind(alpha) 0 cosd(alpha);];
R3=[cosd(ksi) -sind(ksi) 0;...
    sind(ksi) cosd(ksi) 0;...
    0 0 1;];
R=R3*R2*R1;
T=[R p;...
    0 0 0 1;]
theta=acosd(0.5*(trace(R)-1));
w_m=1/(2*sind(theta))*(R-R');
theta1=deg2rad(theta);
invG=1/(theta1)*eye(3,3)-0.5*w_m+ ...
    (1/theta1-0.5*cot(theta1/2))*w_m^2;
v=invG*p;
w1=w_m(3,2);
w2=w_m(1,3);
w3=w_m(2,1);
w=[w1;w2;w3];
psi=[w; v;];
end
