syms h real%;
syms l1 real%;
syms l2 real%;
syms theta1 real%;
syms theta2 real%;
syms theta3 real%;
syms theta4 real%;
syms theta5 real%;
syms theta6 real%;
gst_0 = [1 0 0 0
         0 1 0 l1+l2
         0 0 1 h
         0 0 0 1];
w1 = [0 0 1]';
w2 = rot('z',theta1)*[-1 0 0]';
w3 = rot('z',theta1)*rot('x',-theta2)*[-1 0 0]';
w4 = rot('z',theta1)*rot('x',-theta2)*rot('x',-theta3)*[-1 0 0]';
w5 = rot('z',theta1)*rot('x',-theta2)*rot('x',-theta3)*rot('x',-theta4)*[0 0 1]';
w6 = rot('z',theta1)*rot('x',-theta2)*rot('x',-theta3)*rot('x',-theta4)*rot('z',theta5)*[0 1 0]';
q1 = [0 0 h]';
q2 = [0 0 h]';
q3 = [0 0 h]'+rot('z',theta1)*rot('x',-theta2)*[0 l1 0]';
q4 = q3+rot('z',theta1)*rot('x',-theta2)*rot('x',-theta3)*[0 l2 0]';
q5 = q3+rot('z',theta1)*rot('x',-theta2)*rot('x',-theta3)*[0 l2 0]';
q6 = q3+rot('z',theta1)*rot('x',-theta2)*rot('x',-theta3)*[0 l2 0]';
% g1 = zyz2exp(-cross(w1,q1),w1,theta1);
% g2 = zyz2exp(-cross(w2,q2),w2,theta2);
% g3 = zyz2exp(-cross(w3,q3),w3,theta3);
% g4 = zyz2exp(-cross(w4,q4),w4,theta4);
% g5 = zyz2exp(-cross(w5,q5),w5,theta5);
% g6 = zyz2exp(-cross(w6,q6),w6,theta6);
% gst_end = g1*g2*g3*g4*g5*g6*gst_0
% R = gst_end(1:3,1:3);
% p = gst_end(1:3,4);
% p_hat = [0 -p(3,1) p(2,1)
%          p(3,1) 0 -p(1,1)
%          -p(2,1) p(1,1) 0];
% Ad = [R p_hat*R
%       0 R];
Js = [-cross(w1,q1),-cross(w2,q2),-cross(w3,q3),-cross(w4,q4),-cross(w5,q5),-cross(w6,q6)
      w1,w2,w3,w4,w5,w6]
Jb = Ad^(-1)*Js

