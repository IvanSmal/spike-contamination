function [spt,c_spt,raw_sig, filt_sig]=fakesignals(trials,avgfr,burstL,fakeWF)
%% create fake spike times based on trials and max fr
epspf=epspKernel; % set the kernel for spike smoothing using a function

lpf=lowpassfilt; % set your filter using a function
    
fts=nan(trials,ceil(avgfr/50));
for tr=1:trials
    ms=1;
    while ms<=ceil(avgfr/(1000/burstL)) %figure out spikes/burst length
        tempts=ceil(normrnd(ceil(burstL/2),...
            ceil(burstL/6))); %get a random spike time
        if any(fts(tr,:)==tempts)
            continue
        else
            fts(tr,ms)=tempts;
            ms=ms+1;
        end
    end
    shifttp=(-min(fts(tr,:)))+1;
    fts(tr,:)=fts(tr,:)+shifttp+50; %%set first spike to be exactly at the start of the burst
    %% turn spiketimes into binary spike trains
    spt(tr,1:50)=0;
    spt(tr,fts(tr,:))=1;
    spt(tr,end+1:500)=0;
    
    %% convert binary spike trains to convolved ones
    temp=conv(spt(tr,:),epspf);
    c_spt(tr,:)=temp(100:end-100);
    clear temp
    
    %% turn spiketimes into 30K Hz sampled waveforms
    for s=1:size(fts(tr,:),2)
        wf=fakeWF(randi(size(fakeWF,1)),:); %pull random waveform
        sp=fts(tr,s)*30; %get start point in 30k hz sampled
        ep=sp+length(wf)-1; %get end point for waveform
        raw_sig(tr, sp:ep)=wf;
    end
    raw_sig(tr, end+1:15000)=0;
    %% turn 30KHz signal to low-passed down-sampled signal (spike contamination signal)
    temp=filtfilt(lpf, raw_sig(tr, :));
    filt_sig.ds(tr,:)=downsample(temp,30); %downsampled to 1000hz
    filt_sig.raw(tr,:)=temp; % not downsampled
    clear temp;
end
end

function epspf=epspKernel
Tg=1; %growth
Td=20; %decay
clear epspf
timeint=-100:104;
for m= 1:length(timeint)
    if timeint(m)<0
        epspf(m)=0;
    else
        epspf(m)=((1-exp((-timeint(m))./1))).*exp((-timeint(m))./Td);
    end
end
epspf=[epspf(5:end)];
end

function out=lowpassfilt

out = designfilt('lowpassfir', 'FilterOrder', 20, 'CutoffFrequency', (100/30000)); 

end