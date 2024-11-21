function gst_end = forward(theta)
theta1 = theta(1);
theta2 = theta(2);
theta3 = theta(3);
theta4 = theta(4);
theta5 = theta(5);
theta6 = theta(6);
gst_0 = [-1 0 0 0
         0 -1 0 0
         0 0 1 491+450+450+84
         0 0 0 1];
g1 = zyz2exp(-cross([0 0 1]',[0 0 0]'),[0 0 1]',theta1);
g2 = zyz2exp(-cross([0 1 0]',[0 0 491]'),[0 1 0]',theta2);
g3 = zyz2exp(-cross([0 1 0]',[0 0 941]'),[0 1 0]',theta3);
g4 = zyz2exp(-cross([0 0 1]',[0 0 1391]'),[0 0 1]',theta4);
g5 = zyz2exp(-cross([0 1 0]',[0 0 1391]'),[0 1 0]',theta5);
g6 = zyz2exp(-cross([0 0 1]',[0 0 1475]'),[0 0 1]',theta6);
gst_end = g1*g2*g3*g4*g5*g6*gst_0