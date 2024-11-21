function [theta1]=pk_sub1(ksi,p,q,r)
w=ksi(1:3);
u=p-r;
v=q-r;
u1=(eye(3)-w*w')*u;
v1=(eye(3)-w*w')*v;
if(((norm(u1)^2-norm(v1)^2)<0.1)&&((w'*u-w'*v)<0.1))
theta1=atan2d(w'*cross(u1,v1),u1'*v1);
return;
end
theta1=NaN;
end
