function OK = LoadTetrodeData(self, useFileDialog)

if useFileDialog
    % find basename
    [fn dn] = uigetfile(self.TText, ...
        'Select the spike data file from the desired tetrode.');
    if isequal(fn,0) % user hit cancel
        return
    end
    else
    % use "get" paradigm
    MCS = MClust.GetSettings();
    [fn dn] = feval(MCS.NeuralLoadingFunction, 'get', 'filenames');
end

[self.TTdn self.TTfn self.TText] = fileparts(fullfile(dn,fn));
if exist(fullfile(self.TTdn, 'FD'), 'dir')
    self.FDdn = fullfile(self.TTdn, 'FD');
else
    self.FDdn = self.TTdn;
end


% Calculate features
OK = self.FillFeatures();

% Calculate waveform ylim
MCS = MClust.GetSettings();
[~, wv] = feval(MCS.NeuralLoadingFunction,[dn,fn]);
wv_max = max(wv(:));
wv_min = min(wv(:));
MCS.AverageWaveform_ylim = [wv_min, wv_max];
end
