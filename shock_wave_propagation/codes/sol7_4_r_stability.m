clc
clear
close all

% LateX interpreter for plots
set(groot, 'defaultAxesTickLabelInterpreter','latex'); set(groot, 'defaultLegendInterpreter','latex');

% problem data
c__p = 1000; %wave propagation speed[m/s]
a = 1; %cavity radius[m]
nu = 0.45; %Poisson's ratio
t = linspace(0, 0.05, 1000);
r = linspace(1.0001*a, 20*a, 10);
p = 1;
T = zeros(size(r)); %save stability time

for ii = 1:length(r)
    alpha = 1 / sqrt(1-2*nu);
    tau = t - (r(ii) - a) / c__p;
    d = (1 - nu) / (2 * (1 - 2 * nu));
    theta = alpha*c__p*tau/(2*d*a);
    sigma__r = -p*a^3/r(ii)^3 * (1 + ((r(ii)^2-a^2)/a^2*cos(theta) - ((r(ii)-a)/a)^2*1/alpha*sin(theta)) .* exp(-c__p * tau/(2*d*a))) .* heaviside(tau);
    sigma__r = double(sigma__r);
    
    for jj = 1:length(t) - 1
        if abs((sigma__r(jj + 1) - sigma__r(jj)) / sigma__r(jj)) < 0.01 && sigma__r(jj) ~= 0 % stability criterion (relative error less than 1%)
            T(ii) = t(jj) - t(find(sigma__r == 0, 1, 'last' ));
            break
        end
    end
end

figure ('position', [0 0 800 500])
plot(r/a, T*c__p./r, '-ok', 'LineWidth', 2)
set(gca, 'FontSize', 16)
xlabel('$\frac{r}{a}$[-]', 'Interpreter','latex', 'FontSize', 28)
ylabel('$\frac{c_p t}{r}$[-]', 'Interpreter','latex', 'FontSize', 28);

% save figures
saveas(figure(1), 'r_t_plot', 'epsc')