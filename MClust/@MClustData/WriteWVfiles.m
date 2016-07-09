function OK = WriteWVfiles(self)

% OK = WriteWVfiles(MCD)

MCD = self;

nClust = length(MCD.Clusters);

WV = MCD.LoadNeuralWaveforms();
WVT = WV.range();
WVD = WV.data();

for iC = 1:nClust
    tSpikes = MCD.Clusters{iC}.GetSpikes;
    if ~isempty(tSpikes)
        fnWV = [MCD.TfileBaseName(iC) '-wv.mat'];
        
        tsdobj = tsd(WVT(tSpikes), WVD(tSpikes, :,:));
        RawData = PackRawData(tsdobj); %pack Raw spikes Data.
        [mWV, sWV, xrange] = MClust.AverageWaveform(tsdobj); %#ok<NASGU,ASGLU>

        save(fnWV,'mWV','sWV','xrange','RawData','-mat');
    end
end

OK = true;

function RawData = PackRawData(tsdobj)
RawData.iTime = tsdobj.T;
RawData.waveform = tsdobj.D;
