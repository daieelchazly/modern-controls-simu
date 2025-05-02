A = [0 0 1 0;
     0 0 0 1;
     0 0 0 0;
     0 0 0 0];

B = [0     0;
     0     0;
     0.5012 -0.7180;
    -0.7180  1.7640];

C = [1 0 0 0;
     0 1 0 0];

D = [0 0;
     0 0];

H = [0;
     0;
    -5.7461;
     4.6375];
Aim=[zeros(2,2) C; zeros(4,2) A];
Bim = [zeros(2,2); B];
Kim =place(Aim,Bim,[2+1i*3 -2-1i*3 -10+1i*15 -10-1i*15 -20 -25]);
ACLim=Aim-Bim*Kim;
eig(ACLim)


A_aug = [A, zeros(4, 2);
         C, zeros(2, 2)];

B_aug = [B;
         zeros(2, 2)];


K = place(A_aug, B_aug, desired_poles);


disp('Gain Matrix K:');
disp(K);


t_final = 10; 
dt = 0.01;   
t = 0:dt:t_final;

q1_ref = pi/8; 
q2_ref = pi/16; 
ref_input = [q1_ref; q2_ref];


X0 = zeros(4, 1); 


sys_cl = ss((A - B * K(:, 1:4)), B, C, D);


[Y, T, X] = lsim(sys_cl, repmat(ref_input', length(t), 1), t, X0);


figure;
subplot(2, 1, 1);
plot(T, Y(:, 1), 'r', 'LineWidth', 1.5); hold on;
plot(T, Y(:, 2), 'b', 'LineWidth', 1.5);
xlabel('Time (s)');
ylabel('Joint Angles (rad)');
legend('q1', 'q2');
title('Joint Angles Response');
grid on;

subplot(2, 1, 2);
plot(T, ref_input(1) * ones(size(T)), '--r', 'LineWidth', 1.2); hold on;
plot(T, ref_input(2) * ones(size(T)), '--b', 'LineWidth', 1.2);
xlabel('Time (s)');
ylabel('Reference Inputs (rad)');
legend('q1_{ref}', 'q2_{ref}');
grid on;