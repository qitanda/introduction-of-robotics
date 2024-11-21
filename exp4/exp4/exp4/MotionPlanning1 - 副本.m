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

function MotionData = MotionPlanning1(TotalLength, Vmax, Accel, Decel, Ts)
    for i = 1:length(TotalLength)
        if (i == 1)
            t = 0;
            t1 = Vmax(i)/Accel(i);
            t2 = Vmax(i)/Decel(i);
            if (Vmax(i)^2/2/Accel(i) + Vmax(i)^2/2/Decel(i) <= 0.3 * TotalLength*(i))
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
                        x = x + v * 0.001;
                        t_count = t_count + 0.001;
                        s(i, count) = x;
                        t(i, count) = Ts + count * 0.001;
                        v_all(i, count) = v;
                        a(i, count) = 0;
                    elseif (t_count >= t3 && v > 0)
                        v1 = v - Decel(i)*0.001;
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
            else if (Vmax(i)^2/2/Accel(i) + Vmax(i)^2/2/Decel(i) > 0.3 * TotalLength*(i))
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
                        x = x + v * 0.001;
                        t_count = t_count + 0.001;
                        s(i, count) = x;
                        t(i, count) = Ts + count * 0.001;
                        v_all(i, count) = v;
                        a(i, count) = 0;
                    elseif (t_count >= t3 && v > 0)
                        v1 = v - Decel(i)*0.001;
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
        end
        elseif (i > 1)
             Vm = Accel(i)*Decel(i)/(Accel(i)+Decel(i))*(-max_time+sqrt(max_time^2+2*(Accel(i)+Decel(i))/Accel(i)/Decel(i)*TotalLength(i)));
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
                    x = x + v * 0.001;
                    t_count = t_count + 0.001;
                    s(i, count) = x;
                    t(i, count) = Ts + count * 0.001;
                    v_all(i, count) = v;
                    a(i, count) = 0;
                elseif (t_count >= t3 && v > 0)
                    v1 = v - Decel(i)*0.001;
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
    end
    MotionData = struct();
    MotionData.t = t;
    MotionData.v = v_all;
    MotionData.a = a;
    MotionData.s = s;
    MotionData.maxtime = max_time;
end
