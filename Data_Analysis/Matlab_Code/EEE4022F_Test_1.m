% EEE4022F Initial Data analysis - Initial separate plots

s1_pressure_stat_data = readtable("EEE4022F\ST Sensor\data\t10_stat_outside\s1\20250509_152238_Pressure.csv");
s2_pressure_stat_data = readtable("EEE4022F\ST Sensor\data\t10_stat_outside\s2\20250509_152238_Pressure.csv");

s1_pressure_stair_data = readtable("EEE4022F\ST Sensor\data\t8_step\s1\20250509_151148_Pressure.csv");
s2_pressure_stair_data = readtable("EEE4022F\ST Sensor\data\t8_step\s2\20250509_151148_Pressure.csv");

s1_pressure_swing_data = readtable("EEE4022F\ST Sensor\data\t9_swing\s1\20250509_151927_Pressure.csv");
s2_pressure_swing_data = readtable("EEE4022F\ST Sensor\data\t9_swing\s2\20250509_151926_Pressure.csv");

s1_pressure_data = s1_pressure_stair_data;
s2_pressure_data = s2_pressure_stair_data;

% Extract the date and pressure data from both sensors
dates_s1 = s1_pressure_data.Date; % Date column from sensor 1
pressure_s1 = s1_pressure_data.Pressure_mBar_; % Pressure column from sensor 1

dates_s2 = s2_pressure_data.Date; % Date column from sensor 2
pressure_s2 = s2_pressure_data.Pressure_mBar_; % Pressure column from sensor 2

% % Create the first plot for Sensor 1
% figure(1);
% plot(dates_s1, pressure_s1, 'b-', 'LineWidth', 1.5); % Blue line for sensor 1
% title('Pressure Readings from Sensor 1');
% xlabel('Date');
% ylabel('Pressure (mBar)');
% grid on;
% datetick('x', 'mm/dd/yyyy HH:MM', 'keepticks'); % Format the date on x-axis
% set(gca, 'XTickLabelRotation', 45); % Rotate x-axis labels for readability
% 
% % Create the second plot for Sensor 2
% figure(2);
% plot(dates_s2, pressure_s2, 'r-', 'LineWidth', 1.5); % Red line for sensor 2
% title('Pressure Readings from Sensor 2');
% xlabel('Date');
% ylabel('Pressure (mBar)');
% grid on;
% datetick('x', 'mm/dd/yyyy HH:MM', 'keepticks'); % Format the date on x-axis
% set(gca, 'XTickLabelRotation', 45); % Rotate x-axis labels for readability
