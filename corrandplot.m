%here you want to compare c_sptr and filt_sig

function corrmat=corrandplot(sp,lfp)
%% pad one matrix for out of bounds correlations
    sp2=padarray(sp,[0 50],'both');
    for tp=1:size(lfp,2)
        for shift=1:100
            corrmat(shift,tp)=corr(lfp(:,tp),sp2(:,tp+shift),'type','Spearman');
        end
    end
    figure(1);
    imagesc(corrmat)
    figure(2);
    plot(sp')
    figure(3);
    plot(lfp');
end