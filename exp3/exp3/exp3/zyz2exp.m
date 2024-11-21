function T = zyz2exp(V, W, theta)
I = eye(3);
theta = theta /180*acos(-1);
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
