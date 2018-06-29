channels = 3

% Generate filter bank
for i=1:channels
    f_go = cornerFreq(i+1);             % Get current upper corner frequency
    f_gu = cornerFreq(i);               % Get current lower corner frequency
    N = 8                               % Filter order
                                        % sampling rate f_s

    % Generate new filter
    [newFilter(i), f_r(i), Q(i)] = own_filter(f_go, f_gu, N, f_s);

    % Apply the filter on the signal
    signal_filtered{i} = filter(newFilter(i), signal);
end

% Calculate the amplitude responses with the fourier transform
% of an impulse function

% Generate impulse function
t_signalMax = 1;                        % duration in seconds
t_signal = 0:t_s:t_signalMax;           % time vector in seconds
signal = zeros([1,length(t_signal)]);
signal(1) = 1;
% First the fourier transform of the unfiltered impulse
[X_in, f] = fourier_complete(signal, t_signalMax, f_s);

for i=1:channels
% Next the fouriertransform of the filtered impulse
    [X_out, ~] = fourier_complete(signal_filtered{1,i}, t_signalMax, f_s);
% Save the amplitude response for each filter channel
    ampResponse(:,i) = 20*log10(abs(X_out./X_in));
end
