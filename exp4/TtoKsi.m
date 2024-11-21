function [ksi, theta]=TtoKsi(T)
p=[T(1,4) T(2,4) T(3,4)]';
R=T(1:3,1:3);
if(trace(R)==3)
    w=[0 0 0]';
    theta=0;
    v=p;
    v=v/norm(v);
    ksi=[w; v;];
    return;
end
if(trace(R)>=-1&&trace(R)<3)
theta=acosd(0.5*(trace(R)-1));
w_m=1/(2*sind(theta))*(R-R');
theta1=deg2rad(theta);
invG=1/(theta1)*eye(3,3)-0.5*w_m+ ...
    (1/theta1-0.5*cot(theta1/2))*w_m^2;
v=invG*p;
w1=w_m(3,2);
w2=w_m(1,3);
w3=w_m(2,1);
w=[R(3,2)-R(2,3);R(1,3)-R(3,1);R(2,1)-R(1,2)]/(2*sind(theta));
ksi=[w; v;];    
end
    
end