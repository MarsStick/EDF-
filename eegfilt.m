% 修改原EEGlab的pop_eegfiltnew程序，实现构建带通滤波器
% 2017.11.07
function data = eegfilt(data, locutoff, hicutoff, sf)

% Constants
TRANSWIDTHRATIO = 0.25;
fNyquist = sf / 2;

edgeArray = sort([locutoff hicutoff]);

if isempty(edgeArray)
    error('Not enough input arguments.');
end
if any(edgeArray < 0 | edgeArray >= fNyquist)
    error('Cutoff frequency out of range');
end

% Max stop-band width
maxTBWArray = edgeArray; % Band-/highpass

maxTBWArray(end) = fNyquist - edgeArray(end);

maxDf = min(maxTBWArray);

% Transition band width and filter order
df = min([max([edgeArray(1) * TRANSWIDTHRATIO 2]) maxDf]);
filtorder = 3.3 / (df / sf); % Hamming window
filtorder = ceil(filtorder / 2) * 2; % Filter order must be even.
revfilt = 0;

filterTypeArray = {'lowpass', 'bandpass'; 'highpass', 'bandstop (notch)'};
fprintf('pop_eegfiltnew() - performing %d point %s filtering.\n', filtorder + 1, filterTypeArray{revfilt + 1, length(edgeArray)})
fprintf('pop_eegfiltnew() - transition band width: %.4g Hz\n', df)
fprintf('pop_eegfiltnew() - passband edge(s): %s Hz\n', mat2str(edgeArray))

% Passband edge to cutoff (transition band center; -6 dB)
dfArray = {df, [-df, df]; -df, [df, -df]};
cutoffArray = edgeArray + dfArray{revfilt + 1, length(edgeArray)} / 2;
fprintf('pop_eegfiltnew() - cutoff frequency(ies) (-6 dB): %s Hz\n', mat2str(cutoffArray))

% Window
winArray = windows('hamming', filtorder + 1);

% Filter coefficients
b = firws(filtorder, cutoffArray / fNyquist, winArray);

% Plot frequency response

% Filter
disp('pop_eegfiltnew() - filtering the data');
data = eegfirfilt(data, b);

end
