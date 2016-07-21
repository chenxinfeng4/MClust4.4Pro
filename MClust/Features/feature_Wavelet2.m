function [waveletData, waveletNames, waveletPars] = feature_Wavelet2(V, ttChannelValidity, ~)

% MClust
% [Data, Names, Params] = feature_Wavelet2(V, ttChannelValidity, Params)
% Calculate waveform WAVELET (Wavelet:2)
%
% Similar to feature_Wavelet1
[waveletData, waveletNames, waveletPars] = feature_Wavelet1(V, ttChannelValidity, [], 2);