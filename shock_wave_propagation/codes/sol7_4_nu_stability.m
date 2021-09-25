clc
clear
close all

% LateX interpreter for plots
set(groot, 'defaultAxesTickLabelInterpreter','latex'); set(groot, 'defaultLegendInterpreter','latex');

% problem data
c__p = 1000; %wave propagation speed[m/s]
a = 1; %cavity radius[m]
nu = linspace(0, 0.45, 10); %Poisson's ratio
t = linspace(0, 0.05, 10);
r = 4*a;
p = 1;
T = zeros(size(nu)); %save stability time

for ii = 1:length(nu)
    alpha = 1 / sqrt(1-2*nu(ii));
    tau = t - (r - a) / c__p;
    d = (1 - nu(ii)) / (2 * (1 - 2 * nu(ii)));
    theta = alpha*c__p*tau/(2*d*a);
    sigma__r = -p*a^3/r^3 * (1 + ((r^2-a^2)/a^2*cos(theta) - ((r-a)/a)^2*1/alpha*sin(theta)) .* exp(-c__p * tau/(2*d*a))) .* heaviside(tau);
    sigma__r = double(sigma__r);
    
    for jj = 1:length(t) - 1
        if abs((sigma__r(jj + 1) - sigma__r(jj)) / sigma__r(jj)) < 0.01 && sigma__r(jj) ~= 0 % stability criterion (relative error less than 1%)
            T(ii) = t(jj) - t(find(sigma__r == 0, 1, 'last' ));
            break
        end
    end
end

figure ('position', [0 0 800 500])
plot(nu, T*c__p/a, '-ok', 'LineWidth', 2)
set(gca, 'FontSize', 16)
xlabel('$\nu$[-]', 'Interpreter','latex', 'FontSize', 20)
ylabel('$\frac{c_p t}{a}$[-]', 'Interpreter','latex', 'FontSize', 28);
ylim([0, 45])

% save figures
saveas(figure(1), 'v_t_plot', 'epsc')