data_validation_size=data_size-train_data_size;
% disp('init_vali');
out=predictor(data_validation',...
    p,...
    train_data,...
    dimensions,...
    b*ones(1,data_validation_size),...
    c,...
    d);
errors=abs((out'-data_validation(:,end)))';
errors(errors>0.5*max(abs(data_validation(:,end))))=1;
errors(errors<0.1*max(abs(data_validation(:,end))))=0;
error=sum(errors);
error_por=[error_por,error/data_validation_size];