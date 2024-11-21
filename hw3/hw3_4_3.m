l_1 = 1;
l_2 = 1;
h = 1;
theta1 = 0;
theta2 = 0;
theta3 = 1;
theta4 = 0;
theta5 = 0;
theta6 = 0;
gst_0 = [1 0 0 0
         0 1 0 l_1+l_2
         0 0 1 h
         0 0 0 1];
g1 = zyz2exp(-cross([0 0 1]',[0 0 h]'),[0 0 1]',theta1);
g2 = zyz2exp(-cross([0 -1 0]',[0 0 h]'),[0 -1 0]',theta2);
g3 = zyz2exp([0,1,0]',[0 0 0]',theta3);
g4 = zyz2exp(-cross([-1 0 0]',[0 l_1+l_2 h]'),[-1 0 0]',theta4);
g5 = zyz2exp(-cross([0 0 1]',[0 l_1+l_2 h]'),[0 0 1]',theta5);
g6 = zyz2exp(-cross([0 1 0]',[0 0 h]'),[0 1 0]',theta6);
gst_end = g1*g2*g3*g4*g5*g6*gst_0
