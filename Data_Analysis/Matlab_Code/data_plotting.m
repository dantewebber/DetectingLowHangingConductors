% Calculate the mean of the filtered pressures
mean_pressure_s1 = mean(pressure_s1_aligned(1:100));
mean_pressure_s2 = mean(pressure_s2_aligned(1:100));
% mean_pressure_s1 = mean(pressure_s1_aligned(end-80:end));
% mean_pressure_s2 = mean(pressure_s2_aligned(end-80:end));

% Calculate the offset (Sensor 2 - Sensor 1)
if not (mean_pressure_s1 == mean_pressure_s2)
    offset = mean_pressure_s2 - mean_pressure_s1
end

% Adjust Sensor 2 data by subtracting the offset
pressure_s2_adjusted = pressure_s2_aligned - offset; % Unfiltered

% Design a low-pass filter
fs = 10; % Sampling frequency (based on time intervals)
cutoff_freq = 1; % Cutoff frequency in Hz (adjust as needed)
order = 10; % Filter order
lpFilt = designfilt('lowpassfir', 'FilterOrder', order, 'CutoffFrequency', cutoff_freq, 'SampleRate', fs);

% Apply the low-pass filter to both datasets
% p1_LPF = filtfilt(lpFilt, pressure_s1_aligned);
% p2_LPF = filtfilt(lpFilt, pressure_s2_adjusted);

% Define the window size for the moving average filter
window_size = 20;

% Apply a moving average filter to both datasets
pressure_s1_movmean = movmean(pressure_s1_aligned, window_size);
pressure_s2_movmean = movmean(pressure_s2_adjusted, window_size);

p1_med = movmedian(pressure_s1_movmean, 10);
p2_med = movmedian(pressure_s2_movmean, 10);

% figure;
% plot(time_zeroed, p1_LPF, 'r-', 'LineWidth', 1.5, 'DisplayName', 'Sensor 1');
% hold on;
% plot(time_zeroed, p2_LPF, 'b-', 'LineWidth', 1.5, 'DisplayName', 'Sensor 2');
% title("Lowpass Filtered and Offset Correction Indoors Stationary Test Data");
% xlabel("Time (s)");
% ylabel("Pressure (mBar)");
% legend show;
% grid on;

p_diff = p2_med - p1_med;

figure;
plot(time_zeroed, p_diff, 'LineWidth', 1.5, 'DisplayName', 'Pressure Difference');
title("Pressure Difference of Movmedian Filtered Indoor Stat Test Data")
xlabel("Time (s)");
ylabel("Pressure Difference (mBar)");
grid on;