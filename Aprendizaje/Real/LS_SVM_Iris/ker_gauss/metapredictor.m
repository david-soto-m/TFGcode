function out=meta_predictor(total_data,dimensions,sav)
    for ii=1:length(sav)
        outp(:,ii)=predictor(total_data',...
            sav(ii).p,...
            sav(ii).trdata,...
            dimensions,...
            sav(ii).b*ones(1,length(total_data)),...
            sav(ii).sigma);
    end
    out=mode(outp,2);
end