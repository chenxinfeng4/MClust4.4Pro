function [wavePCData, wavePCNames, wavePCPar] = feature_WavePC2(V, ttChannelValidity, Params)

% MClust
% [wavePCData, wavePCNames, wavePCPar] = feature_WavePC2(V, ttChannelValidity, Params)
% Calculate first waveform PRINCIPAL COMPONENTS  (PC2)
%
% Similar to feature_WavePC1
if ~exist('Params','var'); Params = []; end
[wavePCData, wavePCNames, wavePCPar] = feature_WavePC1(V, ttChannelValidity, Params, 2);