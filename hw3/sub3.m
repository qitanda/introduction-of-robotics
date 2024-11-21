function [theta1 theta2]=sub3(w,p,q,delta)
p1 = p;
v1 = p; 
p2 = q; 
v2 = q; 
A = [v1, -v2];
B = p2 - p1;
params = linsolve(A, B);
r = p1 + params(1) * v1;
u=p-r;
v=q-r;
u_1=u-w*w'*u;
v_1=v-w*w'*v;
delta_1=delta^2-norm(w'*(p-q))^2;
theta0=atan2(w'*cross(u_1,v_1),(u_1')*v_1);
theta1=theta0+acos((norm(u_1)+norm(v_1)-delta_1^2)./(2.*norm(u_1).*norm(v_1)));
theta2=theta0-acos((norm(u_1)+norm(v_1)-delta_1^2)./(2.*norm(u_1).*norm(v_1)));
end