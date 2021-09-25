clc
clear
close all

% LateX interpreter for plots
set(groot, 'defaultAxesTickLabelInterpreter','latex'); set(groot, 'defaultLegendInterpreter','latex');

addpath('mesh_convergence')

% beam data
E = 2.1e11; % Young's modulus
rho = 7.9e3; % density
L = 0.3; % length
A = 9e-4; % area
m = 2.133; % mass

% rigid mas data
v__0 = 1; % initial velocity

% calculated parameters
M = m / A;
c = sqrt(E / rho); % wave propagation speed
tt = L / c; % required time for the wave to travel through the beam

t = linspace(0, tt, 100);
sigma = zeros(1, length(t)); % initialize stress wave
sigma__0 = rho * c * v__0; % sigma__0
l = linspace(0, L, length(t));
time = 1.551e-5; % desired time

% analytical solution
figure('position', [0 0 800 600])
hold on
for ii = 1:length(t)
    if t(ii) <= time
        sigma(ii) = v__0 * sqrt(E *rho) * exp(-t(ii) / M * sqrt(E * rho));
    else
        sigma(ii) = 0;
    end
end
plot(l, sigma, 'k', 'LineWidth', 2, 'DisplayName', 'Analytical')
a__a = trapz(l, sigma); % area under analytic stress

% numerical result
mrkr = {'o', '+', '*', '.', 'x', 's'};
a__n = zeros(1, length(mrkr));
mesh_data = {'stress_015.txt', 'stress_0075.txt', 'stress_005.txt', 'stress_003.txt', 'stress_002.txt', 'stress_0015.txt'};
n = [160, 1280, 4320, 20000, 67500, 160000]; % number of elements
% element dimension [m]: 0.015 , 0.0075, 0.005, 0.003, 0.002, 0.0015
for jj = 1:length(mesh_data)
    t__n = importdata(mesh_data{1, jj}); % time
    l__n = t__n.data(:, 2); % length
    s__n = t__n.data(:, 7); % wave stress
    plot(l__n, -s__n, 'Marker', mrkr{jj}, 'LineWidth', 2, 'DisplayName', sprintf('N=%d', n(jj)))
    a__n(jj) = -trapz(l__n, s__n);
end
xlabel('L[m]', 'Interpreter','latex', 'FontSize', 18)
ylabel('$\sigma$[Pa]', 'Interpreter','latex', 'FontSize', 18)
set(gca, 'FontSize', 20)
legend show
box on

% absolute error [%]
figure('position', [0 0 800 600])
e = abs((a__a - a__n) ./ a__n * 100);
plot(n, e, 'k', 'LineWidth', 2)
xlabel('Number of Elements', 'Interpreter','latex', 'FontSize', 18)
ylabel('Absolute Error[\%]', 'Interpreter','latex', 'FontSize', 18)
set(gca, 'FontSize', 18, 'xtick',[])
box on
for kk = 1:length(n)
    n_text = text(n(kk), e(kk), sprintf('N=%d', n(kk)), 'Interpreter','latex', 'FontSize', 16);
    set(n_text, 'Rotation', 45);
end

% report mesh number and error
ne = [n; e];
fprintf('%s %30s \n','Number of Elements','Absolute Error');
fprintf('%d %50.2f \n', ne);

% save figures
saveas(figure(1), 'figs/stress_mesh_study', 'epsc')
saveas(figure(2), 'figs/mesh_study', 'epsc')