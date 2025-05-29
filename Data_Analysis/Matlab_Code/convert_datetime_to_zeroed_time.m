function time_zeroed = convert_datetime_to_zeroed_time(datetime_array)
% CONVERT_DATETIME_TO_ZEROED_TIME Converts a datetime array to minutes and seconds,
% zeroed to the first element.
%
% This function takes a datetime array, extracts just the minutes and seconds
% information, and zeros the time to the first element, effectively making the 
% first element 00:00:00.0000.
%
% Args:
%   datetime_array (datetime array): Array of datetime values
%
% Returns:
%   time_zeroed (duration array): Array of durations in minutes and seconds,
%                                zeroed to the first element
%
% Example Usage:
%   dates = datetime({'2023-05-02 14:30:45', '2023-05-02 14:31:15'});
%   zeroed_times = convert_datetime_to_zeroed_time(dates);
%   % Result: [00:00:00.0000; 00:00:30.0000]

% Input validation
if ~isdatetime(datetime_array)
    error('Input must be a datetime array');
end

% Convert to duration by subtracting the first element
time_zeroed = datetime_array - datetime_array(1);
time_zeroed = seconds(time_zeroed);

% Format to display only minutes and seconds if needed
% NOTE: This doesn't change the actual duration values, only how they're displayed
% You can comment this out if you want the full duration including hours
% time_zeroed.Format = 'mm:ss.SSSS';

end