# spike-contamination
## 1. Create fake waveforms
Either load in ExampleChannel.mat or any sorted dataset from mksort to get a typical waveforms from your data. Or generate your own waveforms.
run: fakeWF=getFakeWF(nfakes) where nfakes=how many fake waveforms you want

## 2. Generate fake burst dataset
run: [sptr,c_sptr,raw_sig, filt_sig]=fakesignals(trials,avgfr,burstL,fakeWF) 

outputs:

trails = how many trials you want. avgfr = average burst FR. burstL = length of your burst. fakeWF = output of step 1

inputs:

spt = spike times. c_spt = convolved spike times. raw_sig = raw signal (at 30KHZ). filt_sig.raw = lowpassed signal. filt_sig.ds = downsampled signal (like our lfps).

Inside the function you can change the kernels for both spikes and filters for lfps.

## 3. Plot

run: corrandplot(c_spt,filt_sig.ds)

you will get a heatmap where the y axis is the LFP timepoint, X axis is the shift, and color is the correlation between LFP and spikes. any correlation here is purely due to spike contamination
