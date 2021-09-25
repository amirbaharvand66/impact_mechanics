clc
clear 
close all

%% normalized by c_1
%v = 0
v0 = importdata("data_from_7_3\v0.txt");
t_v0 = v0.data(:, 1);
u_v0 = v0.data(:, 2);
[val1, idx1] = max(u_v0(1:65));
[val2, idx2] = max(u_v0(71:end));
t_v0(71 + idx2) - t_v0(idx1)

%v = 0.25
v025 = importdata("data_from_7_3\v0_25.txt");
t_v025 = v025.data(:, 1);
u_v025 = v025.data(:, 2);
[val1, idx1] = max(u_v025(1:65));
[val2, idx2] = max(u_v025(71:end));
t_v025(71 + idx2) - t_v025(idx1)

%v = 0.25
v045 = importdata("data_from_7_3\v0_45.txt");
t_v045 = v045.data(:, 1);
u_v045 = v045.data(:, 2);
[val1, idx1] = max(u_v045(1:121));
[val2, idx2] = max(u_v045(122:end));
t_v045(122 + idx2) - t_v045(idx1)


%% normalized by c_1p
clear
%v = 0
v0 = importdata("data_from_7_3\u_0_v0.txt");
t_v0 = v0.data(:, 1);
u_v0 = v0.data(:, 2);
[val1, idx1] = max(u_v0(1:70));
[val2, idx2] = max(u_v0(70:end));
t_v0(70 + idx2) - t_v0(idx1)

%v = 0.25
v025 = importdata("data_from_7_3\u_0_v0_25.txt");
t_v025 = v025.data(:, 1);
u_v025 = v025.data(:, 2);
[val1, idx1] = max(u_v025(1:70));
[val2, idx2] = max(u_v025(70:end));
t_v025(70 + idx2) - t_v025(idx1)

%v = 0.25
v045 = importdata("data_from_7_3\u_0_v0_45.txt");
t_v045 = v045.data(:, 1);
u_v045 = v045.data(:, 2);
[val1, idx1] = max(u_v045(1:90));
[val2, idx2] = max(u_v045(90:end));
t_v045(90 + idx2) - t_v045(idx1)