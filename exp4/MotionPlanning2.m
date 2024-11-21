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

function MotionData = MotionPlanning2(TotalLength, Vmax, Accel, Decel, Ts)
    t_acc = 0;
    t_dec = 0;
    flag_acc = 0;
    flag_dec = 0;
    v_max = 0;
    flag_x = 1;
    flag_y = 1;
    flag_z = 1;
    if (TotalLength(1) < 0) 
        flag_x = 0;
        TotalLength(1) = -TotalLength(1);
    end
    if (TotalLength(2) < 0) 
        flag_y = 0;
        TotalLength(2) = -TotalLength(2);
    end
    if (TotalLength(3) < 0) 
        flag_z = 0;
        TotalLength(3) = -TotalLength(3);
    end
    td1 = 2*TotalLength(1)/Accel(1)+2*TotalLength(1)/Decel(1);
    td2 = 2*TotalLength(2)/Accel(2)+2*TotalLength(2)/Decel(2);
    td3 = 2*TotalLength(3)/Accel(3)+2*TotalLength(3)/Decel(3);
    if (td3 >= td2 && td3 >= td1)
        i = 3;
    end
    if (td2 >= td1 && td2 >= td3)
        i = 2;
    end
    if (td1 >= td2 && td1 >= td3)
        i = 1;
    end
    t = 0;
    t1 = Vmax(i)/Accel(i);
    t2 = Vmax(i)/Decel(i);
    if (Vmax(i)^2/2/Accel(i) + Vmax(i)^2/2/Decel(i) <= 0.3 * TotalLength(i))
        t3 = (TotalLength(i) - Vmax(i)^2/2/Accel(i) - Vmax(i)^2/2/Decel(i))/Vmax(i);
        x = 0;
        v = 0;
        t_count = 0;
        count = 0;
        flag = 1;
        while (x < TotalLength(i) && flag)
            count = count + 1;
            if (v + Accel(i)*0.001 < Vmax(i) && t_count == 0)
                v1 = v + Accel(i)*0.001;
                x = x + (v1^2-v^2)/2/Accel(i);
                v = v + Accel(i)*0.001;
                s(i, count) = x;
                t(i, count) = Ts + count * 0.001;
                v_all(i, count) = v;
                a(i, count) = Accel(i);
            elseif (v + Accel(i)*0.001 >= Vmax(i) && t_count < t3)
                if flag_acc == 0
                    flag_acc = 1;
                    t_acc = t(i, count-1);
                end
                x = x + v * 0.001;
                v_max = v;
                t_count = t_count + 0.001;
                s(i, count) = x;
                t(i, count) = Ts + count * 0.001;
                v_all(i, count) = v;
                a(i, count) = 0;
            elseif (t_count >= t3 && v > 0)
                v1 = v - Decel(i)*0.001;
                if flag_dec == 0
                    flag_dec = 1;
                    t_dec = t(i, count-1);
                end
                if (v1 > 0)
                    x = x + (v^2-v1^2)/2/Decel(i);
                    v = v - Decel(i)*0.001;
                    s(i, count) = x;
                    t(i, count) = Ts + count * 0.001;
                    v_all(i, count) = v;
                    a(i, count) = -Decel(i);
                elseif (v1 <= 0)
                    t4 = v / Decel(i);
                    x = x + v^2/2/Decel(i);
                    s(i, count) = x;
                    t(i, count) = Ts + t(i, count-1) + t4;
                    v_all(i, count) = 0;
                    a(i, count) = -Decel(i);
                    flag = 0;
                end
            end
        end
        max_time = t(i, count);
    elseif (Vmax(i)^2/2/Accel(i) + Vmax(i)^2/2/Decel(i) > 0.3 * TotalLength(i))
        Vm = sqrt(0.6*TotalLength(i)*Accel(i)*Decel(i)/(Accel(i)+Decel(i)));
        t3 = (TotalLength(i) - Vm^2/2/Accel(i) - Vm^2/2/Decel(i))/Vm;
        x = 0;
        v = 0;
        t_count = 0;
        count = 0;
        flag = 1;
        while (x < TotalLength(i) && flag)
            count = count + 1;
            if (v + Accel(i)*0.001 < Vm && t_count == 0)
                v1 = v + Accel(i)*0.001;
                x = x + (v1^2-v^2)/2/Accel(i);
                v = v + Accel(i)*0.001;
                s(i, count) = x;
                t(i, count) = Ts + count * 0.001;
                v_all(i, count) = v;
                a(i, count) = Accel(i);
            elseif (v + Accel(i)*0.001 >= Vm && t_count < t3)
                v_max = v;
                if flag_acc == 0
                    flag_acc = 1;
                    t_acc = t(i, count-1);
                end
                x = x + v * 0.001;
                t_count = t_count + 0.001;
                s(i, count) = x;
                t(i, count) = Ts + count * 0.001;
                v_all(i, count) = v;
                a(i, count) = 0;
            elseif (t_count >= t3 && v > 0)
                v1 = v - Decel(i)*0.001;
                if flag_dec == 0
                    flag_dec = 1;
                    t_dec = t(i, count-1);
                end
                if (v1 > 0)
                    x = x + (v^2-v1^2)/2/Decel(i);
                    v = v - Decel(i)*0.001;
                    s(i, count) = x;
                    t(i, count) = Ts + count * 0.001;
                    v_all(i, count) = v;
                    a(i, count) = -Decel(i);
                elseif (v1 <= 0)
                    t4 = v / Decel(i);
                    x = x + v^2/2/Decel(i);
                    s(i, count) = x;
                    t(i, count) = Ts + t(i, count-1) + t4;
                    v_all(i, count) = 0;
                    a(i, count) = -Decel(i);
                    flag = 0;
                end
            end
        end
        max_time = t(i, count);
    end
    if i==1
        k = 2;
        s(k,1) = 0;
        for j = 1:length(s(i,:))
            vm = v_max * TotalLength(k)/TotalLength(i);
            v_all(k,j) = v_all(i,j) * TotalLength(k)/TotalLength(i);
            t(k,j) = t(i,j);
            if t(k,j) <= t_acc
                a(k,j) = vm/t_acc;
            elseif t_acc < t(k,j) && t(k,j) <= t_dec
                a(k,j) = 0;
            elseif t(k,j) > t_dec
                a(k,j) = -vm/(max_time-t_dec);
            end
            if j == 1
                s(k,j) = 0.001 * v_all(i,j) * TotalLength(k)/TotalLength(i);
            end
            if j > 2
                s(k,j) = s(k,j-1) + (t(k,j) - t(k,j-1)) * v_all(i,j) * TotalLength(k)/TotalLength(i);
            end 
        end
        k = 3;
        s(k,1) = 0;
        for j = 1:length(s(i,:))
            vm = v_max * TotalLength(k)/TotalLength(i);
            v_all(k,j) = v_all(i,j) * TotalLength(k)/TotalLength(i);
            t(k,j) = t(i,j);
            if t(k,j) <= t_acc
                a(k,j) = vm/t_acc;
            elseif t_acc < t(k,j) && t(k,j) <= t_dec
                a(k,j) = 0;
            elseif t(k,j) > t_dec
                a(k,j) = -vm/(max_time-t_dec);
            end
            if j == 1
                s(k,j) = 0.001 * v_all(i,j) * TotalLength(k)/TotalLength(i);
            end
            if j > 2
                s(k,j) = s(k,j-1) + (t(k,j) - t(k,j-1)) * v_all(i,j) * TotalLength(k)/TotalLength(i);
            end 
        end
    end
    if i==2
        k = 1;
        s(k,1) = 0;
        for j = 1:length(s(i,:))
            vm = v_max * TotalLength(k)/TotalLength(i);
            v_all(k,j) = v_all(i,j) * TotalLength(k)/TotalLength(i);
            t(k,j) = t(i,j);
            if t(k,j) <= t_acc
                a(k,j) = vm/t_acc;
            elseif t_acc < t(k,j) && t(k,j) <= t_dec
                a(k,j) = 0;
            elseif t(k,j) > t_dec
                a(k,j) = -vm/(max_time-t_dec);
            end
            if j == 1
                s(k,j) = 0.001 * v_all(i,j) * TotalLength(k)/TotalLength(i);
            end
            if j > 2
                s(k,j) = s(k,j-1) + (t(k,j) - t(k,j-1)) * v_all(i,j) * TotalLength(k)/TotalLength(i);
            end 
        end
        k = 3;
        s(k,1) = 0;
        for j = 1:length(s(i,:))
            vm = v_max * TotalLength(k)/TotalLength(i);
            v_all(k,j) = v_all(i,j) * TotalLength(k)/TotalLength(i);
            t(k,j) = t(i,j);
            if t(k,j) <= t_acc
                a(k,j) = vm/t_acc;
            elseif t_acc < t(k,j) && t(k,j) <= t_dec
                a(k,j) = 0;
            elseif t(k,j) > t_dec
                a(k,j) = -vm/(max_time-t_dec);
            end
            if j == 1
                s(k,j) = 0.001 * v_all(i,j) * TotalLength(k)/TotalLength(i);
            end
            if j > 2
                s(k,j) = s(k,j-1) + (t(k,j) - t(k,j-1)) * v_all(i,j) * TotalLength(k)/TotalLength(i);
            end 
        end
    end
    if i==3
        k = 1;
        s(k,1) = 0;
        for j = 1:length(s(i,:))
            vm = v_max * TotalLength(k)/TotalLength(i);
            v_all(k,j) = v_all(i,j) * TotalLength(k)/TotalLength(i);
            t(k,j) = t(i,j);
            if t(k,j) <= t_acc
                a(k,j) = vm/t_acc;
            elseif t_acc < t(k,j) && t(k,j) <= t_dec
                a(k,j) = 0;
            elseif t(k,j) > t_dec
                a(k,j) = -vm/(max_time-t_dec);
            end
            if j == 1
                s(k,j) = 0.001 * v_all(i,j) * TotalLength(k)/TotalLength(i);
            end
            if j > 2
                s(k,j) = s(k,j-1) + (t(k,j) - t(k,j-1)) * v_all(i,j) * TotalLength(k)/TotalLength(i);
            end 
        end
        k = 2;
        s(k,1) = 0;
        for j = 1:length(s(i,:))
            vm = v_max * TotalLength(k)/TotalLength(i);
            v_all(k,j) = v_all(i,j) * TotalLength(k)/TotalLength(i);
            t(k,j) = t(i,j);
            if t(k,j) <= t_acc
                a(k,j) = vm/t_acc;
            elseif t_acc < t(k,j) && t(k,j) <= t_dec
                a(k,j) = 0;
            elseif t(k,j) > t_dec
                a(k,j) = -vm/(max_time-t_dec);
            end
            if j == 1
                s(k,j) = 0.001 * v_all(i,j) * TotalLength(k)/TotalLength(i);
            end
            if j > 2
                s(k,j) = s(k,j-1) + (t(k,j) - t(k,j-1)) * v_all(i,j) * TotalLength(k)/TotalLength(i);
            end 
        end
    end
    for i = 1:3
        if (s(i, length(s(i,:))) == 0) s(i, length(s(i,:))) = s(i, length(s(i,:))-1); end
        if (t(i, length(t(i,:))) == 0) t(i, length(t(i,:))) = t(i, length(t(i,:))-1); end
    end
    if flag_x == 0
        for i = 1:length(s(1,:))
            s(1, i) = -s(1, i);
            v_all(1, i) = -v_all(1, i);
            a(1, i) = -a(1, i);
        end
    end
    if flag_y == 0
        for i = 1:length(s(2,:))
            s(2, i) = -s(2, i);
            v_all(2, i) = -v_all(2, i);
            a(2, i) = -a(2, i);
        end
    end
    if flag_z == 0
        for i = 1:length(s(3,:))
            s(3, i) = -s(3, i);
            v_all(3, i) = -v_all(3, i);
            a(3, i) = -a(3, i);
        end
    end
    MotionData = struct();
    MotionData.t = t;
    MotionData.v = v_all;
    MotionData.a = a;
    MotionData.s = s;
    MotionData.maxtime = max_time;
end
