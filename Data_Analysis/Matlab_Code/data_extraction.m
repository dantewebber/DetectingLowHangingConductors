% Data extraction

s1_pressure_stat_data = readtable("EEE4022F\ST Sensor\data\t10_stat_outside\s1\20250509_152238_Pressure.csv");
s2_pressure_stat_data = readtable("EEE4022F\ST Sensor\data\t10_stat_outside\s2\20250509_152238_Pressure.csv");

s1_pressure_stair_data = readtable("EEE4022F\ST Sensor\data\t8_step\s1\20250509_151148_Pressure.csv");
s2_pressure_stair_data = readtable("EEE4022F\ST Sensor\data\t8_step\s2\20250509_151148_Pressure.csv");

s1_pressure_swing_data = readtable("EEE4022F\ST Sensor\data\t9_swing\s1\20250509_151927_Pressure.csv");
s2_pressure_swing_data = readtable("EEE4022F\ST Sensor\data\t9_swing\s2\20250509_151926_Pressure.csv");

s1_pressure_long_step_data = readtable("EEE4022F\ST Sensor\data\t12_long_step\s1\20250511_174148_Pressure.csv");
s2_pressure_long_step_data = readtable("EEE4022F\ST Sensor\data\t12_long_step\s2\20250511_174147_Pressure.csv");

s1_pressure_data = s1_pressure_swing_data;
s2_pressure_data = s2_pressure_swing_data;

% Extract the date and pressure data from both sensors
dates_s1 = s1_pressure_data.Date; % Date column from sensor 1
pressure_s1 = s1_pressure_data.Pressure_mBar_; % Pressure column from sensor 1

dates_s2 = s2_pressure_data.Date; % Date column from sensor 2
pressure_s2 = s2_pressure_data.Pressure_mBar_; % Pressure column from sensor 2