%% MAKE FAKE WAVEFORMS
% load ExampleChannel.mat or any other waveforms file from sorted mksort
% output
function fakeWF=getFakeWF(in,nfakes)
fidx=randi(nfakes,1,size(in.waves,2));
for i=1:nfakes
    fakeWF(i,:)=mean(in.waves(:,fidx==i),2);
end
end