% --- CIRCLE MAP CML ---
N = 100;          % Number of Lattice Sites
T = 2000;         % Number of time steps
K = 1;            % Non Linearity Parameter
omega = 0.7;        % Natural frequency
eps = 0.9;        % Coupling strength

% Randomize the theta lattice
theta = rand(1, N );
store = zeros(T, N);

for t = 1:T
    % Defining the Function
    f = theta + omega - (K/(2*pi)) * sin(2*pi * theta);
    left_n  = circshift(f, [0, 1]);
    right_n = circshift(f, [0, -1]);
    %Coupled Map Lattice equation
    theta = mod((1 - eps) * f + (eps/2) * (left_n + right_n),1);
    
    store(t, :) = theta;
end

% --- PLOT RESULTS ---
imagesc(store);
colormap('hot'); %
colorbar;
xlabel('Lattice Sites');
ylabel('Time Steps');
title('Spatiotemporal Evolution of Coupled Map Lattice');