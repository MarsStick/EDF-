% 修改原EEGlab的firfilt程序，实现对脑电数据的滤波
% 2017.11.07
function data = eegfirfilt(data, b, nFrames)

if nargin < 2
    error('Not enough input arguments.');
end
if nargin < 3 || isempty(nFrames)
    nFrames = 1000;
end

% Filter's group delay
if mod(length(b), 2) ~= 1
    error('Filter order is not even.');
end
groupDelay = (length(b) - 1) / 2;

dcArray = [1 size(data,2)+1];

% Initialize progress indicator
nSteps = 20;
step = 0;
fprintf(1, 'firfilt(): |');
strLength = fprintf(1, [repmat(' ', 1, nSteps - step) '|   0%%']);
tic
iDc = 1;
% Pad beginning of data with DC constant and get initial conditions
ziDataDur = min(groupDelay, dcArray(iDc + 1) - dcArray(iDc));
[temp, zi] = filter(b, 1, double([data(:, ones(1, groupDelay) * dcArray(iDc)) ...
    data(:, dcArray(iDc):(dcArray(iDc) + ziDataDur - 1))]), [], 2);

blockArray = [(dcArray(iDc) + groupDelay):nFrames:(dcArray(iDc + 1) - 1) dcArray(iDc + 1)];
for iBlock = 1:(length(blockArray) - 1)
    
    % Filter the data
    [data(:, (blockArray(iBlock) - groupDelay):(blockArray(iBlock + 1) - groupDelay - 1)), zi] = ...
        filter(b, 1, double(data(:, blockArray(iBlock):(blockArray(iBlock + 1) - 1))), zi, 2);
    
    % Update progress indicator
    [step, strLength] = mywaitbar((blockArray(iBlock + 1) - groupDelay - 1), size(data, 2), step, nSteps, strLength);
end

% Pad end of data with DC constant
temp = filter(b, 1, double(data(:, ones(1, groupDelay) * (dcArray(iDc + 1) - 1))), zi, 2);
data(:, (dcArray(iDc + 1) - ziDataDur):(dcArray(iDc + 1) - 1)) = ...
    temp(:, (end - ziDataDur + 1):end);

% Update progress indicator
[step, strLength] = mywaitbar((dcArray(iDc + 1) - 1), size(data, 2), step, nSteps, strLength);



% Reshape epoched data
% Deinitialize progress indicator
fprintf(1, '\n')

end

function [step, strLength] = mywaitbar(compl, total, step, nSteps, strLength)

progStrArray = '/-\|';
tmp = floor(compl / total * nSteps);
if tmp > step
    fprintf(1, [repmat('\b', 1, strLength) '%s'], repmat('=', 1, tmp - step))
    step = tmp;
    ete = ceil(toc / step * (nSteps - step));
    strLength = fprintf(1, [repmat(' ', 1, nSteps - step) '%s %3d%%, ETE %02d:%02d'], progStrArray(mod(step - 1, 4) + 1), floor(step * 100 / nSteps), floor(ete / 60), mod(ete, 60));
end

end
