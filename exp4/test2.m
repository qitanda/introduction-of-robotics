clc
% MotionData = MotionPlanning([10,10,10], [2,2,2], [2,2,2], [2,2,2], 0);
% MotionData = MotionPlanning1(0.1, 10, 10, 10, 0);
loc1 = [650 -100 940];
loc2 = [680 -150 1000];
MotionData = MotionPlanning2([100,10,1], [30,30,30], [20,20,20], [20,20,20], 0);
motion1 = MotionData.s(1,:);
motion2 = MotionData.s(2,:);
motion3 = MotionData.s(3,:);
t1 = MotionData.t(1,:);
t2 = MotionData.t(2,:);
t3 = MotionData.t(3,:);
figure(1);
plot(t1, motion1);
figure(2);
plot(t2, motion2);
figure(3);
plot(t3, motion3);
% TrajGena(0, MotionData, loc1, loc2)