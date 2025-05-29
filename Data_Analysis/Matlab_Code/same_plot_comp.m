% Plot pressure against each other on same plot

% Extract the date and pressure data from both sensors
dates_s1 = s1_pressure_data.Date; % Date column from sensor 1
pressure_s1 = s1_pressure_data.Pressure_mBar_; % Pressure column from sensor 1

dates_s2 = s2_pressure_data.Date; % Date column from sensor 2
pressure_s2 = s2_pressure_data.Pressure_mBar_; % Pressure column from sensor 2

% % Create a single figure for both sensors
% figure;
% 
% % Plot Sensor 1 pressure
% plot(dates_s1, pressure_s1, 'b-', 'LineWidth', 1.5, 'DisplayName', 'Sensor 1'); % Blue line for sensor 1
% hold on; % Keep the plot active to add the second line
% 
% % Plot Sensor 2 pressure
% plot(dates_s2, pressure_s2, 'r-', 'LineWidth', 1.5, 'DisplayName', 'Sensor 2'); % Red line for sensor 2
% hold off; % Release the plot
% 
% % Add titles, labels, and formatting
% title('Pressure Readings from Sensor 1 and Sensor 2');
% xlabel('Date');
% ylabel('Pressure (mBar)');
% grid on;
% datetick('x', 'mm/dd/yyyy HH:MM', 'keepticks'); % Format the date on x-axis
% set(gca, 'XTickLabelRotation', 45); % Rotate x-axis labels for readability
% 
% % Add a legend
% legend('Location', 'best'); % Automatically place the legend in the best location
% 
% figure;
% plot(dates_s1(1:100), pressure_s1(1:100) - pressure_s2(1:100), 'b-', 'LineWidth', 1.5, 'DisplayName', 'Sensor Diff');
% title('Pressure difference between 2 sensors raw data');
% xlabel('Date');
% ylabel('Pressure (mBar)');
% grid on;
% datetick('x', 'mm/dd/yyyy HH:MM', 'keepticks');
% set(gca, 'XTickLabelRotation', 45);

% Define the window size for the moving average filter
window_size = 10; % Adjust this value as needed (e.g., 5, 10, 20)

% Apply a moving average filter to both datasets
pressure_s1_movmean = movmean(pressure_s1, window_size);
pressure_s2_movmean = movmean(pressure_s2, window_size);

% Design a low-pass filter
fs = 1 / seconds(mean(diff(dates_s1))); % Sampling frequency (based on time intervals)
cutoff_freq = 0.5; % Cutoff frequency in Hz (adjust as needed)
order = 100; % Filter order
lpFilt = designfilt('lowpassfir', 'FilterOrder', order, 'CutoffFrequency', cutoff_freq, 'SampleRate', fs);

% Apply the low-pass filter to both datasets
pressure_s1_filtered = filtfilt(lpFilt, pressure_s1);
pressure_s2_filtered = filtfilt(lpFilt, pressure_s2);

% % Plot the moving average data
% figure;
% % Plot filtered Sensor 1 pressure
% plot(dates_s1, pressure_s1_movmean, 'b-', 'LineWidth', 1.5, 'DisplayName', 'Sensor 1 Movmean Filter');
% hold on;
% % Plot filtered Sensor 2 pressure
% plot(dates_s2, pressure_s2_movmean, 'r-', 'LineWidth', 1.5, 'DisplayName', 'Sensor 2 Movmean Filter');
% hold off;
% 
% % Add titles, labels, and formatting
% title('Movmean Filtered Pressure Readings from Sensor 1 and Sensor 2');
% xlabel('Date');
% ylabel('Pressure (mBar)');
% grid on;
% datetick('x', 'mm/dd/yyyy HH:MM', 'keepticks');
% set(gca, 'XTickLabelRotation', 45);
% 
% % Add a legend
% legend('Location', 'best');

% % Plot the LP filtered data
% figure;
% % Plot filtered Sensor 1 pressure
% plot(dates_s1, pressure_s1_filtered, 'b-', 'LineWidth', 1.5, 'DisplayName', 'Sensor 1 LP Filter');
% hold on;
% % Plot filtered Sensor 2 pressure
% plot(dates_s2, pressure_s2_filtered, 'r-', 'LineWidth', 1.5, 'DisplayName', 'Sensor 2 LP Filter');
% hold off;

% % Add titles, labels, and formatting
% title('Filtered LPF Pressure Readings from Sensor 1 and Sensor 2');
% xlabel('Date');
% ylabel('Pressure (mBar)');
% grid on;
% datetick('x', 'mm/dd/yyyy HH:MM', 'keepticks');
% set(gca, 'XTickLabelRotation', 45);

% Add a legend
legend('Location', 'best');

% Calculate the mean of the filtered pressures
mean_pressure_s1 = mean(pressure_s1_movmean(end-10:end));
mean_pressure_s2 = mean(pressure_s2_movmean(end-10:end));

% Calculate the offset (Sensor 2 - Sensor 1)
offset = mean_pressure_s2 - mean_pressure_s1;
% offset = 0;

% Display the offset
fprintf('Offset between Sensor 2 and Sensor 1: %.4f mBar\n', offset);

% Adjust Sensor 2 data by subtracting the offset
pressure_s2_adjusted = pressure_s2 - offset; % Unfiltered
pressure_s2_movmean_adjusted = pressure_s2_movmean - offset; % Filtered
pressure_s2_lpf_adj = pressure_s2_filtered - offset;

% Plot the unfiltered data after adjustment
figure;
% Plot unfiltered Sensor 1 (unchanged)
plot(dates_s1, pressure_s1, 'b-', 'LineWidth', 1, 'DisplayName', 'Sensor 1 Unfiltered');
hold on;
% Plot adjusted unfiltered Sensor 2
plot(dates_s2, pressure_s2_adjusted, 'r-', 'LineWidth', 1, 'DisplayName', 'Sensor 2 Unfiltered (Adjusted)');
hold off;

% Difference Plot
% figure;
% plot(dates_s2, pressure_s2_adjusted - pressure_s1, 'g-', 'LineWidth', 1, 'DisplayName', 'Pressure Difference');

% Add titles, labels, and formatting
title('Unfiltered Pressure Readings (Sensor 2 Adjusted)');
xlabel('Date');
ylabel('Pressure (mBar)');
grid on;
datetick('x', 'mm/dd/yyyy HH:MM', 'keepticks');
set(gca, 'XTickLabelRotation', 45);
legend('Location', 'best');

% Plot the movmean data after adjustment
figure;
% Plot filtered Sensor 1 (unchanged)
plot(dates_s1, pressure_s1_movmean, 'b-', 'LineWidth', 1.5, 'DisplayName', 'Sensor 1 Filtered');
hold on;
% Plot adjusted filtered Sensor 2
plot(dates_s2, s2_pressure_movmean_adjusted, 'r-', 'LineWidth', 1.5, 'DisplayName', 'Sensor 2 Filtered (Adjusted)');
hold off;

% Add titles, labels, and formatting
title('Filtered Pressure Readings (Sensor 2 Adjusted)');
xlabel('Date');
ylabel('Pressure (mBar)');
grid on;
datetick('x', 'mm/dd/yyyy HH:MM', 'keepticks');
set(gca, 'XTickLabelRotation', 45);
legend('Location', 'best');

% Plot the LPF data after offset
% Plot the movmean data after adjustment
figure;
% Plot filtered Sensor 1 (unchanged)
plot(dates_s1, pressure_s1_filtered, 'b-', 'LineWidth', 1.5, 'DisplayName', 'Sensor 1 LPF');
hold on;
% Plot adjusted filtered Sensor 2
plot(dates_s2, pressure_s2_lpf_adj, 'r-', 'LineWidth', 1.5, 'DisplayName', 'Sensor 2 LPF (Adjusted)');
hold off;

% Add titles, labels, and formatting
title('LPF Pressure Readings (Sensor 2 Adjusted)');
xlabel('Date');
ylabel('Pressure (mBar)');
grid on;
datetick('x', 'mm/dd/yyyy HH:MM', 'keepticks');
set(gca, 'XTickLabelRotation', 45);
legend('Location', 'best');

% Plot difference in pressure between 2 sensors after adj
figure;
plot(dates_s1(1:size(dates_s1)-100), pressure_s1_filtered(1:size(dates_s1)-100) - pressure_s2_lpf_adj(1:size(dates_s1)-100), 'b-', 'LineWidth', 1.5, 'DisplayName', 'Sensor Diff LPF');
title('Pressure difference between 2 sensors LPF data');
xlabel('Date');
ylabel('Pressure (mBar)');
grid on;
datetick('x', 'mm/dd/yyyy HH:MM', 'keepticks');
set(gca, 'XTickLabelRotation', 45);

s2_pressure_max = max(s2_pressure_movmean_adjusted);

fprintf("Pressure Max = %.4f [hPa]\n", s2_pressure_max);
pressure_diff = s2_pressure_max - mean(pressure_s1_movmean);
fprintf("Pressure Difference = %.4f [hPa]\n", pressure_diff);
alt_diff = 1.6*pressure_diff/0.2;
fprintf("Altitude difference = %.3f[m]\n", alt_diff);