% Plot the difference in pressures

function pressure_diff = pressure_difference(pressure_s1, pressure_s2, time_vector)
% plot_pressure_diff Calculates and plots the difference between two pressure sensor readings.
%
% Args:
%   pressure_s1 (array): Numerical array of pressure readings from sensor 1.
%   pressure_s2 (array): Numerical array of pressure readings from sensor 2.
%                        It is assumed that pressure_s1 and pressure_s2
%                        are of the same length.
%   time_vector (array, optional): Numerical array representing the time
%                                  or sample indices for the x-axis. If not
%                                  provided, sample indices will be used.
%
% Example Usage:
%   % Generate some sample data
%   N = 100; % Number of data points
%   t = (0:N-1)'; % Time vector or sample index
%   s1 = 1000 + 5*sin(2*pi*0.1*t) + randn(N,1)*0.5;
%   s2 = 1000 + 5*sin(2*pi*0.1*t + pi/4) + randn(N,1)*0.5 + 2; % s2 has a phase shift and offset
%
%   % Plot using sample indices
%   plot_pressure_diff(s1, s2);
%
%   % Plot using a time vector
%   time_data = (0:0.1:9.9)'; % Example time vector in seconds
%   plot_pressure_diff(s1, s2, time_data);

% --- Input Validation ---
if nargin < 2
    error('Not enough input arguments. Please provide pressure_s1 and pressure_s2.');
end
if ~isnumeric(pressure_s1) || ~isvector(pressure_s1)
    error('pressure_s1 must be a numeric vector.');
end
if ~isnumeric(pressure_s2) || ~isvector(pressure_s2)
    error('pressure_s2 must be a numeric vector.');
end
if length(pressure_s1) ~= length(pressure_s2)
    error('pressure_s1 and pressure_s2 must be of the same length.');
end

% if nargin < 3 || isempty(time_vector)
%     % If time_vector is not provided or is empty, use sample indices
%     x_data = 1:length(pressure_s1);
%     x_label_text = 'Sample Index';
% else
%     if ~isnumeric(time_vector) || ~isvector(time_vector)
%         error('time_vector must be a numeric vector.');
%     end
%     if length(time_vector) ~= length(pressure_s1)
%         error('time_vector must be the same length as the pressure sensor arrays.');
%     end
%     x_data = time_vector;
%     x_label_text = 'Datetime'; % Or a more specific unit if known, e.g., 'Time (s)'
% end

x_data = time_vector;
x_label_text = 'Time';

% --- Calculate Pressure Difference ---
pressure_diff = pressure_s2 - pressure_s1;

% --- Plotting ---
figure; % Create a new figure window

plot(x_data, pressure_diff, 'LineWidth', 1.5, 'DisplayName', 'Pressure Difference (S2 - S1)');

% Add labels and title
xlabel(x_label_text);
ylabel('Pressure Difference (mBar)'); % You might want to specify units, e.g., 'Pressure Difference (mBar)'
title('Difference Between Pressure Sensor Readings (Sensor 2 - Sensor 1)');

% Add a grid for better readability
grid on;

% Add a legend
legend show;

% Optional: Add some information to the plot or command window
fprintf('Plotted pressure difference. Min: %.2f, Max: %.2f, Mean: %.2f\n', ...
        min(pressure_diff), max(pressure_diff), mean(pressure_diff));

end