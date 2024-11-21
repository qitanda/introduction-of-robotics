function [theta1,theta2]=pk_sub3(ksi,p,q,eta,r)
w=ksi(1:3);
u=p-r;
v=q-r;
u_1=u-w*w'*u;
v_1=v-w*w'*v;
eta_1=norm((eta^2-(w'*(p-q))^2))^(1/2);
theta0=atan2d(w'*cross(u_1,v_1),(u_1')*v_1);
a=(norm(u_1)^2+norm(v_1)^2-eta_1^2)/(2.*norm(u_1)*norm(v_1));
b=norm(u_1)^2+norm(v_1)^2-eta_1^2;
theta1=theta0+acosd((norm(u_1)^2+norm(v_1)^2-eta_1^2)/(2.*norm(u_1)*norm(v_1)));
theta2=theta0-acosd((norm(u_1)^2+norm(v_1)^2-eta_1^2)/(2.*norm(u_1)*norm(v_1)));
end