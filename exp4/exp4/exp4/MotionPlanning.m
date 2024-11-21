% Author: 
%
% ABSTRACT:  三阶轨迹规划最基本文件
%
% INPUTS:InterpolationCycle      计算步长，单位s 设置为0.001s
%        TotalLength             轨迹长度，1xN数组，N为轨迹自由度数，单位m或者rad
%        Vmax                    轨迹匀速段最大速度，1xN数组，单位m/s 或rad/s
%        Acc                     最大加速度，1xN数组，单位m/s^2 或 rad/s^2
%        Dec                     最大减速度，1xN数组，单位m/s^2 或 rad/s^2
%
% OUTPUTS:MotionData             轨迹公式参数，
%         s 	                 轨迹长度数组，NxM数组，单位m 或 rad
%         v 	                 速度数组，NxM数组，单位m/s 或rad/s
%         a 	                 加速度数组，NxM数组，单位m/s^2 或 rad/s^2
%         t 	                 时间数组，Mx1数组，单位s
%         maxtime 	             所需时间，单位s

function MotionData = MotionPlanning(TotalLength, Vmax, Accel, Decel, Ts)
    td1 = 2*TotalLength(1)/Accel(1)+2*TotalLength(1)/Decel(1);
    td2 = 2*TotalLength(2)/Accel(2)+2*TotalLength(2)/Decel(2);
    td3 = 2*TotalLength(3)/Accel(3)+2*TotalLength(3)/Decel(3);
    if (td3 >= td2 && td3 >= td1)
        td = 1.5*td3;
        t = 0:0.001:td;
        acc = min(Accel(3), Decel(3));
        tb = td/2 - sqrt(acc^2*td^2-4*acc*TotalLength(3))/2/acc;
        for i = 1:length(t)
            if (t(i) <= tb)
                s(3:i) = acc/2*t(i)^2;
            elseif (tb <= t(i) && t(i) <= td - tb)
                s(3:i) = acc/2*tb*(t(i)-tb/2);
            elseif (td - tb <= t(i) && t(i) <= td)
                s(3:i) = TotalLength(3) - acc*(td - t(i))^2/2;
            end
        end
        for i = 1:length(t)
            if (t(i) <= tb)
                v(3:i) = acc*t(i);
            elseif (tb <= t(i) && t(i) <= td - tb)
                v(3:i) = acc/2*tb;
            elseif (td - tb <= t(i) && t(i) <= td)
                v(3:i) = acc*(td - t(i));
            end
        end
        for i = 1:length(t)
            if (t(i) <= tb)
                a(3:i) = acc;
            elseif (tb <= t(i) && t(i) <= td - tb)
                a(3:i) = 0;
            elseif (td - tb <= t(i) && t(i) <= td)
                a(3:i) = -acc;
            end
        end
        
    end
    if (td2 >= td1 && td2 >= td3)
        td = 1.5*td2;
        t = 0:0.001:td;
        acc = min(Accel(2), Decel(2));
        tb = td/2 - sqrt(acc^2*td^2-4*acc*TotalLength(3))/2/acc;
    end
    if (td1 >= td2 && td1 >= td3)
        td = 1.5*td1;
        t = 0:0.001:td;
        acc = min(Accel(1), Decel(1));
        tb = td/2 - sqrt(acc^2*td^2-4*acc*TotalLength(3))/2/acc;
    end
    for i = 1:length(t)
        if (t(i) <= tb)
            theta(i) = acc/2*t(i)^2;
        elseif (tb <= t(i) && t(i) <= td - tb)
            theta(i) = acc/2*tb*(t(i)-tb/2);
        elseif (td - tb <= t(i) && t(i) <= td)
            theta(i) = TotalLength(3) - acc*(td - t(i))^2/2;
        end
    end
    for i = 1:length(t)
        if (t(i) <= tb)
            v(i) = acc*t(i);
        elseif (tb <= t(i) && t(i) <= td - tb)
            v(i) = acc/2*tb;
        elseif (td - tb <= t(i) && t(i) <= td)
            v(i) = acc*(td - t(i));
        end
    end
    for i = 1:length(t)
        if (t(i) <= tb)
            a(i) = acc;
        elseif (tb <= t(i) && t(i) <= td - tb)
            a(i) = 0;
        elseif (td - tb <= t(i) && t(i) <= td)
            a(i) = -acc;
        end
    end
    for i = 1:length(TotalLength)
    
    end
    MotionData = struct();
    MotionData.t = t;
    MotionData.v = v_all;
    MotionData.a = a;
    MotionData.s = s;
    MotionData.maxtime = max_time;
end
