function [theta1 theta2]=sub2(w1,w2,p,q)
if(w1==w2)
    theta1=sub1(w1,p,q);
    theta2=0;
    return
end
p1 = w1'; 
v1 = w1'; 
p2 = w2';
v2 = w2'; 
A = [v1, -v2];
B = p2 - p1;
params = linsolve(A, B);
r = p1 + params(1) * v1;
r=r'
v=q-r;
u=p-r;
alpha=(((w1')*w2)*(w2')*u-w1'*v)/(((w1')*w2)^2-1);
beta=(((w1')*w2)*(w1')*v-(w2')*u)/(((w1')*w2)^2-1);
gamma=(norm(u).^2-alpha.^2-beta.^2-2.*alpha.*beta.*w1'.*w2)./(norm(cross(w1,w2))).^2;
z=alpha*w1+beta*w2+gamma*(cross(w1,w2));
[theta1]=sub1(-w1,q,z);
[theta2]=sub1(w2,p,z);
a=1;
end