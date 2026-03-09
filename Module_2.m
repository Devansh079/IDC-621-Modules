%% ==========================================================
% Kuramoto Model
% ==========================================================

clear
clc
close all

%% ---------------- PARAMETERS ----------------

N = 120;        % number of oscillators
T = 60;         % simulation time
dt = 0.05;      % timestep
sigma = 1;      % Gaussian frequency width
K = 2;          % coupling used in live simulation

K_start = 0;    % range for synchronization plot
K_end   = 4;
K_step  = 0.25;

steps = round(T/dt);

%% ---------------- NATURAL FREQUENCIES ----------------

omega = sigma*randn(N,1);

%% ---------------- INITIAL PHASES ----------------

theta = 2*pi*rand(N,1);

%% ---------------- CRITICAL COUPLING ----------------

g0 = 1/(sqrt(2*pi)*sigma);
Kc = 2/(pi*g0);

fprintf("Theoretical Critical Coupling Kc = %.3f\n",Kc)

%% ---------------- FIGURE SETUP ----------------

figure('Position',[100 200 1200 400])

%% Oscillator circle
subplot(1,3,1)
circle_plot = polarplot(theta,ones(N,1),'o','MarkerSize',6,'MarkerFaceColor','b');
title('Live Oscillator Phases')
rlim([0 1.2])

%% Order parameter
subplot(1,3,2)
order_plot = plot(0,0,'LineWidth',2);
xlabel('Time')
ylabel('r(t)')
title('Order Parameter Evolution')
grid on
xlim([0 T])
ylim([0 1])

%% Placeholder for synchronization curve
subplot(1,3,3)
hold on
title('Synchronization Transition')
xlabel('Coupling K')
ylabel('Order Parameter r')
grid on

%% ---------------- LIVE SIMULATION ----------------

r_time = zeros(steps,1);

for t = 1:steps
    
    phase_diff = theta - theta';
    interaction = sin(-phase_diff);
    
    dtheta = omega + (K/N)*sum(interaction,2);
    
    theta = theta + dt*dtheta;
    theta = mod(theta,2*pi);
    
    r_complex = mean(exp(1i*theta));
    r = abs(r_complex);
    
    r_time(t) = r;
    
    % Update circle
    set(circle_plot,'ThetaData',theta)
    
    % Update order parameter
    set(order_plot,'XData',(1:t)*dt,'YData',r_time(1:t))
    
    drawnow
    
end

%% ---------------- SYNCHRONIZATION CURVE r(K) ----------------

K_values = K_start:K_step:K_end;
r_avg = zeros(length(K_values),1);

for k_index = 1:length(K_values)

    K_temp = K_values(k_index);
    theta = 2*pi*rand(N,1);

    for t = 1:steps
        
        phase_diff = theta - theta';
        interaction = sin(-phase_diff);
        
        dtheta = omega + (K_temp/N)*sum(interaction,2);
        
        theta = theta + dt*dtheta;
        theta = mod(theta,2*pi);
        
    end
    
    r_avg(k_index) = abs(mean(exp(1i*theta)));
    
end

%% Plot r(K)

subplot(1,3,3)

plot(K_values,r_avg,'o-','LineWidth',2)

% Plot theoretical Kc
xline(Kc,'r--','LineWidth',2)

legend('Simulation r(K)','Critical Coupling K_c')
