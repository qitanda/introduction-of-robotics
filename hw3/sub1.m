function [theta]=sub1(w,p,q)
r=w;
u=p-r;
v=q-r;
u1=(eye(3)-w*w')*u;
v1=(eye(3)-w*w')*v;
theta=atan2(w'*cross(u1,v1),u1'*v1);
end
