% function [V, W] = exp2zyz(T)
% T = [0 1 0 10
%      0 0 -1 20
%      -1 0 0 1
%      0 0 0 1];
% I = eye(3);
% R = T(1:3,1:3);
% P = T(1:3,4);
% theta = acos((trace(R)-1)/2);
% if (abs(theta) < 1e-5)
%     omg = [0,0,0];
%     theta = norm(P);a
%     E = [[I,P/theta],
%         [0,0,0,1]];
%     V = P;
%     W = [0, 0, 0]';
% end
% W_single = ((R-transpose(R))/(2*sin(theta)));
% W = [W_single(3,2),W_single(1,3),W_single(2,1)]';
% W_ = [0,-W(3),W(2),
%       W(3),0,-W(1),
%      -W(2),W(1),0];
% V = [W * W' * theta + (I - R) * W_]^(-1) * P;
% W = W * theta;
% twist = [V, 
%          W];
% twist
function [fai, theta, psai, P] = exp2zyz(T)
T = [0.1768   -0.9186    0.3536    1.0000
    0.8839    0.3062    0.3536    1.0000
   -0.4330    0.2500    0.8660    1.0000
         0         0         0    1.0000];
theta = atan2(sqrt(T(3, 1)^2+T(3, 2)^2), T(3, 3));
theta
fai = atan2(T(2, 3)/sin(theta), T(1, 3)/sin(theta));
fai
psai = atan2(T(3, 2)/sin(theta), -T(3, 1)/sin(theta));
psai
P = T(1:3,4);
