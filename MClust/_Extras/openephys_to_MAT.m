function openephys_to_MAT(fn)
% Translate *.SPIKES to *.SPIKES.MAT, then the MClust-LOADINGENGINES
% choose "LoadMAT"(refer to chenxinfeng@ibp.hust.edu.cn).
% 
% ------------------------INPUT FILE -----------------------------
% %example.spikes
%
% ------------------------MAT FILE FORMAT-------------------------
% %example.spikes.mat, contains 
% iTime     : a vector, unit (seconds).
% waveform  : nspikes_by_nchan_by_spikewidth, unit (microvolts).
% info      : non-essential, add some user-defined infomation.

%   chenxinfeng@ibp.hust.edu.cn
%   2016-9-18

    %% load files
    if ~exist('fn','var')
        fn=uigetfilemult('*.spikes','load files');
    end
    if isempty(fn);return;end;
    %% translate to mat
    for i=1:length(fn)
        temp_fn = fn{i};
        [wv,iTime,infos] = load_open_ephys_data(temp_fn);
        waveform = permute(wv,[1 3 2]);
        info.sr = infos.header.sampleRate;
        save([temp_fn,'.mat'],'waveform','iTime','info');
    end
end
function pfname=uigetfilemult(varargin)
	[fname,pname]=uigetfile(varargin{:},'MultiSelect','on');
	switch class(fname)
		case 'double'%none loaded
			pfname={};
			return
		case 'char' %one loaded
			pfname={[pname,fname]};
		case 'cell' %mult loaded
			pfname=cell(size(fname));
			for i=1:length(fname)
				pfname(i)={[pname,fname{i}]};
            end
    end
end