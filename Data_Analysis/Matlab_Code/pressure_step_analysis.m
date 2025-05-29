% Step Data Analysis Full Process
data_extraction;
data_align;
movmean_movmedian;
time_zeroed = convert_datetime_to_zeroed_time(dates_s1_aligned);
pressure_diff = pressure_difference(pressure_s1_movmedian, pressure_s2_movmedian, time_zeroed);
pressure_diff_steps_display;