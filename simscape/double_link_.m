% clear
% clc
%%%%
g = 9.8;
l1 = 0.3;
l2 = 0.3;
start_num = 100;
tau = [tau1(start_num:length(tout)); tau2(start_num:length(tout))];
Y = [];
for i=start_num:length(tout)
    Y11 = l1^2/4*ddq1(i) + 1/2*g*l1*cos(q1(i));
    Y12 = l2^2/4*(ddq1(i)+ddq2(i)) + 1/2*l1*l2*(2*ddq1(i)+ddq2(i))*cos(q2(i)) + ...
              1/2*l1*l2*(2*dq1(i)+dq2(i))*(-sin(q2(i)))*dq2(i) + g*(l1*cos(q1(i))+l2/2*cos(q1(i)+q2(i)));
    Y13 = ddq1(i);
    Y14 = ddq1(i)+ddq2(i);
    Y21 = 0;
    Y22 = l2^2/4*(ddq1(i)+ddq2(i)) + 1/2*l1*l2*ddq1(i)*cos(q2(i)) + 1/2*l1*l2*dq1(i)*(-sin(q2(i)))*dq2(i) +...
              1/2*l1*l2*dq1(i)*(dq1(i)+dq2(i))*sin(q2(i)) + g/2*l2*cos(q1(i)+q2(i));
    Y23 = 0;
    Y24 = ddq1(i)+ddq2(i);
    tmpY = [Y11 Y12 Y13 Y14
                  Y21 Y22 Y23 Y24];
    Y = [Y;tmpY];
end
p = inv(Y'*Y)*Y'*tau