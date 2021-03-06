clear
clc
% 质量集中，无惯性矩阵，连杆长度与质心位置重合
syms m1 m2 l1 l2 g 
syms q1 q2 q1d q2d q1dd q2dd 
syms x1(t) x1d x1dd x2(t) x2d x2dd

x1d=diff(x1,t); x2d=diff(x2,t);
x1dd=diff(x1,t,t); x2dd=diff(x2,t,t);

%质量矩阵
M1=diag([m1,m1]);
M2=diag([m2,m2]);

% 速度
V1=[[l1*cos(x1(t)) 0];[l1*sin(x1(t)) 0]]*[x1d;x2d];
V2=[[-l1*sin(x1(t))-l2*sin(x1(t)+x2(t)) -l2*sin(x1(t)+x2(t))];
    [l1*cos(x1(t))+l2*cos(x1(t)+x2(t)) l2*cos(x1(t)+x2(t))]]*[x1d;x2d];

% 动能
K1=simplify((1/2)*V1.'*M1*V1);

K2=simplify((1/2)*V2.'*M2*V2);
K =K1+K2;

% 势能
u1=m1*g*l1*sin(q1);
u2=m2*g*(l1*sin(q1)+l2*sin(q1+q2));
u =u1+u2;

% 拉格朗日方程
L=K-u;
L=subs(L,{x1,x2,x1d,x2d,x1dd,x2dd},{q1,q2,q1d,q2d,q1dd,q2dd});

% 利用运动方程计算力矩方程
dLdqd=[diff(L,q1d); diff(L,q2d)];
dLdqd =subs(dLdqd, {q1,q2,q1d,q2d,q1dd,q2dd}, {x1,x2,x1d,x2d,x1dd,x2dd});
ddLdqddt=diff(dLdqd,t);
ddLdqddt= subs(ddLdqddt,{x1,x2,x1d,x2d,x1dd,x2dd},{q1,q2,q1d,q2d,q1dd,q2dd});
dLdq=[diff(L,q1); diff(L,q2)];

% 输出结果
syms f
f=simplify(ddLdqddt-dLdq)

%% 化为矩阵形式
%%coeffs(a*x^3+2*x+1,x,'All')，能够提取出为零的系数
tau_tmp = [l1^2*m1*q1dd + l1^2*m2*q1dd + l2^2*m2*q1dd + ...
                   l2^2*m2*q2dd + g*m2*(l2*cos(q1 + q2) + l1*cos(q1)) + ...
                   g*l1*m1*cos(q1) - l1*l2*m2*q2d^2*sin(q2) + 2*l1*l2*m2*q1dd*cos(q2) + ...
                   ...
                   l1*l2*m2*q2dd*cos(q2) - 2*l1*l2*m2*q1d*q2d*sin(q2); 
            
            l2*m2*(l1*sin(q2)*q1d^2 + l2*q1dd + l2*q2dd + g*cos(q1 + q2) + l1*q1dd*cos(q2))];
tau1_m1 = diff(tau_tmp(1),m1);
tau1_m2 = diff(tau_tmp(1),m2);
tau2_m1 = diff(tau_tmp(2),m1);
tau2_m2 = diff(tau_tmp(2),m2);
Y = [tau1_m1 tau1_m2;
        tau2_m1 tau2_m2];
    