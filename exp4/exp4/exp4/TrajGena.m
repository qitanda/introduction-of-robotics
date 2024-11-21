% Author: 
%
% ABSTRACT:  根据时间和路径公式参数结构体计算当前时间点，关节位置，速度和加速度
%
% INPUTS: time            当前时刻
%         MotionData      路径公式参数结构体，包括s,v,a,j,t信息
%         loc1            路径起点点位
%         loc2            路径终点点位
%             
% OUTPUTS: q              当前时间点，关节位置向量1xN，单位m或rad
%          qd             当前时间点，关节速度向量1xN,单位m/s或rad/s
%          qdd            当前时间点，关节加速度向量1xN,单位m/s^2或rad/s^2       
%
function theta_all = TrajGena(time, MotionData, loc1, loc2)
    g0=[-1 0 0 loc1(1);
        0 -1 0 loc1(2);
        0 0 1 loc1(3);
        0 0 0 1];
    x = MotionData.s(1,:);
    y = MotionData.s(2,:);
    z = MotionData.s(3,:);
    index = 0;
    for i = 1:length(MotionData.t(1,:))
        if (time > MotionData.t(1,i) && index ~= 0) 
            index = i;
        end
    end
    if (index <= 0) index = 1; end
    if (index > length(MotionData.s(1,:))) index = length(MotionData.s(1,:)); end
    config=[491;450;450;84];
    for i = 1:length(MotionData.t(1,:)) 
        x_target = loc1(1) + x(i);
        y_target = loc1(2) + y(i);
        z_target = loc1(3) + z(i);
        g_st=[0.6790 0.0841 0.7293 x_target;
            -0.1655 -0.9503 0.2637 y_target;
            0.7152 -0.2998 -0.6313 z_target;
            0 0 0 1];
        theta = Ikine6s(g_st,config)
        if i == 1
            for j = 1:8
                if abs(theta(1,j) < 170) && abs(theta(2,j) < 120) && abs(theta(3,j) < 140) && abs(theta(4,j) < 170) && abs(theta(5,j) < 120)
                    theta_last = theta(:,j);
                    theta_all = [theta_last]
                end
            end
        end
        if i >= 2
            for j = 1:8
                id = 0;
                min = 10000000000000;
                if abs(theta(1,j) < 170) && abs(theta(2,j) < 120) && abs(theta(3,j) < 140) && abs(theta(4,j) < 170) && abs(theta(5,j) < 120)
                    sum = 0
                    for k = 1:6
                        sum = sum + (theta(k,j)-theta_last(k))^2;
                    end
                    sum
                    if sum < min
                        id = j;
                        min = sum;
                    end
                end
            end
            theta_last = theta(:,id);
            theta_all = [theta_all theta_last];
        end 
    end
%     MotionPlanning(loc2-loc1, Vmax, Accel, Decel, Ts)
    
end

