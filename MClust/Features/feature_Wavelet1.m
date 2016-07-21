function [waveletData, waveletNames, waveletPars] = feature_Wavelet1(V, ttChannelValidity, ~, iWL)

% MClust
% [Data, Names, Params] = feature_Wavelet1(V, ttChannelValidity, Params)
% Calculate waveform WAVELET (Wavelet:1)
%
% INPUTS
%    V = TT tsd
%    ttChannelValidity = nCh x 1 of booleans%    Params   = feature paramters  (none for energy) 
%    iWL = number of wavelet to keep (per channel), default as 1
%          only used when calculate Wavelet1 2 3 ... 
%
% OUTPUTS
%    Data - nSpikes x nCh of waveform WAVELETs of each spike for each valid channel
%    Names - "Wavelet: Ch"

% extract from "WAVE_CLUS @Rodrigo Quian Quiroga" @Chen Xinfeng


%%% PARAMETERS:  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
defaultWL = 1; % default number of wavelet to keep (per channel)
scales = 4; % wavelet parameter
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if ~exist('iWL','var'); iWL = defaultWL; end %really number of wavelet to keep
TTData = V.data();
[nSpikes, ~, nSamp] = size(TTData);%nSamp = ls, nSpikes = nspk
f = find(ttChannelValidity);
lf = length(f);
waveletNames = cell(lf,1);
waveletPars = {};
waveletData = zeros(nSpikes, lf);
cc = zeros(nSpikes, nSamp); %temp data
for iC = 1:lf
	for iS=1:nSpikes
		c = wavedec(squeeze(TTData(iS,iC,:)),scales,'haar');
		cc(iS,:) = c(:);
    end
    
    sd = zeros(1,nSamp);
	for iA=1:nSamp           % KS test for coefficient selection   
		thr_dist = std(cc(:,iA)) * 3;
		thr_dist_min = mean(cc(:,iA)) - thr_dist;
		thr_dist_max = mean(cc(:,iA)) + thr_dist;
		aux = cc(find(cc(:,iA)>thr_dist_min & cc(:,iA)<thr_dist_max),iA);
		
		if length(aux) > 10;
			[ksstat]=test_ks(aux);
			sd(iA)=ksstat;
		else
			sd(iA)=0;
		end
	end
	[~, ind]=sort(sd);inputs =10;
	coeff(1:inputs)=ind(nSamp:-1:nSamp-inputs+1);
	waveletData(:, iC) = cc(:, coeff(iWL));
	waveletNames{iC} = sprintf('Wavelet%d :%d', iWL, f(iC));
end

function [KSmax] = test_ks(x)
% Calculates the CDF (expcdf)
%[y_expcdf,x_expcdf]=cdfcalc(x);
x = x(~isnan(x));
n = length(x);
x = sort(x(:));
yCDF = (1:n)' / n;
notdup = ([diff(x(:)); 1] > 0);
x_expcdf = x(notdup);
y_expcdf = [0; yCDF(notdup)];
zScores  =  (x_expcdf - mean(x))./std(x);
mu = 0; 
sigma = 1; 
theocdf = 0.5 * erfc(-(zScores-mu)./(sqrt(2)*sigma));
delta1    =  y_expcdf(1:end-1) - theocdf;   % Vertical difference at jumps approaching from the LEFT.
delta2    =  y_expcdf(2:end)   - theocdf;   % Vertical difference at jumps approaching from the RIGHT.
deltacdf  =  abs([delta1 ; delta2]);
KSmax =  max(deltacdf);
