l_1 = 1;
l_2 = 1;
h = 1;
g = [1     0     0     0
     0     1     0     2
     0     0     1     1
     0     0     0     1];
 gst_0 = [1 0 0 0
         0 1 0 l_1+l_2
         0 0 1 h
         0 0 0 1];
theta3 = sub3([0 0 1]',[0 l_1+l_2 h]',[0 0 h]',norm(g.*[0 l_1+l_2 h 1]'-[0 0 h]'));
g3_ = zyz2exp(-cross([-1 0 0]',[0 l_1 h]'),[-1 0 0]',-theta3);
g3 = zyz2exp(-cross([-1 0 0]',[0 l_1 h]'),[-1 0 0]',theta3);
theta1,theta2 = sub2([0 0 1]',[-1 0 0]',g3*[0 l_1+l_2 h]',g*[0 l_1+l_2 h]');
g1_ = zyz2exp(-cross([0 0 1]',[0 0 h]'),[0 0 1]',-theta1);
g2_ = zyz2exp(-cross([-1 0 0]',[0 0 h]'),[-1 0 0]',-theta2);
theta4,theta5 = sub2([-1 0 0]',[0 0 1]',[0 0 h],g3_*g2_*g1_*g*inv(gst_0)*[0 0 h]');
g4_ = zyz2exp(-cross([-1 0 0]',[0 l_1+l_2 h]'),[-1 0 0]',-theta4);
g5_ = zyz2exp(-cross([0 0 1]',[0 l_1+l_2 h]'),[0 0 1]',-theta5);
theta6 = sub1([0 1 0]',[0 0 0]',g5_*g4_*g3_*g2_*g1_*g*inv(gst_0)*[0 0 0]');
g6 = zyz2exp(-cross([0 1 0]',[0 0 h]'),[0 1 0]',theta6);