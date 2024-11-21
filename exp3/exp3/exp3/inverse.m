function theta = inverse(g)
    % T_desired是期望的末端执行器变换矩阵
    % 返回所有可能的关节角度组合
 gst_0 = [-1 0 0 0
           0 -1 0 0
           0 0 1 491+450+450+84
           0 0 0 1];
 g1 = g*inv(gst_0);
 eta = g1*[0 0 1391 1]'-[0 0 491 1]';
 eta = eta(1:3);
 [theta3_1, theta3_2] = pk_sub3([0 1 0]', [0 0 1391]', [0 0 491]', norm(eta), [0 0 491]');
 theta3_1
 theta3_2
 g3 = zyz2exp(-cross([0 1 0]',[0 0 941]'),[0 1 0]',theta3);
 [theta1_1, theta1_2, theta2_1, theta2_2] = pk_sub2([0 0 1]', [0 1 0]', g3*[0 0 1391 1]', g*[0 0 1391 1]');
 theta = [theta1, theta2, theta3, theta4, theta5, theta6];
end
