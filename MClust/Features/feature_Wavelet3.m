function [waveletData, waveletNames, waveletPars] = feature_Wavelet3(V, ttChannelValidity, ~)

% MClust
% [Data, Names, Params] = feature_Wavelet3(V, ttChannelValidity, Params)
% Calculate waveform WAVELET (Wavelet:3)
%
% Similar to feature_Wavelet1
[waveletData, waveletNames, waveletPars] = feature_Wavelet1(V, ttChannelValidity, [], 3);