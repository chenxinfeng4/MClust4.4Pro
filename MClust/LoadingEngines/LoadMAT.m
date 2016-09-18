function [t, wv] = LoadMAT(fn, R, U)
% Loading enginer for MClust-4.4
% inspired by 'LoadSEfromCSC.m', 'TDT2MClust.m', 'LoadTDT.m'
% @Chen xinfeng, 2016-7-8
%
% ------------------------FILE FORMAT-------------------------
% %example.mat, contains 
% iTime     : a vector, unit (seconds).
% waveform  : nspikes_by_nchan_by_spikewidth, unit (any).

if nargin == 1 
    % directly load file
    load(fn, '-mat');
    t = iTime;
    wv = waveform;
elseif nargin == 2 
    % New "get" construction
    if strcmp(fn, 'get')
        switch(R)
            case 'ChannelValidity'
                t = [true true true true];
            case 'ExpectedExtension'
                t = '.mat';
            otherwise
                error('Unknown get condition.');
        end
        return
    else
        error('2 argins requires "get" as the first argument.');
    end
elseif nargin == 3 
% fn : file to load
% R  : records_to_get, a range of values
% U  : a flag taking one of 5 case
    load(fn, '-mat');
    t = iTime;
    wv = waveform;
    switch(U)
        case 1 
        % range is timestamp list
            ind = ismember(t, R);
            t = t(ind);
            wv = wv(ind, :, :);
        case 2 
        % range is record number
            t = t(R);
            wv = wv(R, :, :);
        case 3
        % range is [start timestamp, stop timestamp]
            ind = (t >= range(1) & t <= range(2));
            t = t(ind);
            wv = wv(ind, :, :);
        case 4
        % range is [start record, stop record]
            ind = R(1):R(2);
            t = t(ind);
            wv = wv(ind, :, :);
        case 5
        % return the count of spikes
            t = numel(t);
            wv = [];
    end
end
            