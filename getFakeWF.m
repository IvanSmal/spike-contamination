%% MAKE FAKE WAVEFORMS
% load ExampleChannel.mat or any other waveforms file from sorted mksort
% output
function fakeWF=getFakeWF(nfakes)
fidx=randi(nfakes,1,size(waveforms.waves,2));
for i=1:nfakes
    fakeWF(i,:)=mean(waveforms.waves(:,fidx==i),2);
end
end