function T = zyz2exp(V, W, theta)
% V = [-1.3505, 10.7739, -4.4230]';
% W = [1.2092, 1.2092, -1.2092]';
I = eye(3);
W_ = [0,-W(3),W(2),
      W(3),0,-W(1),
     -W(2),W(1),0];
W_single = W_;
W2 = W;
R = expm(W_.*theta);
P = (I - R) * W_single * V + W2 * W2' * V * theta;
if W==[0 0 0]'
    T = [I, V.*theta
        [0, 0, 0, 1]];
else
    T = [R, P
        [0, 0, 0, 1]];
end
