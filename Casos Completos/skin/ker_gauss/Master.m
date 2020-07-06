%% Init

load_data;
error_por=[];
generate_D_s_Y_g;

%% Búsqueda general

bus_dec=10;%busquedas por década
dec_num=10;%numero de decadas
index=(1:bus_dec*dec_num);%#busquedas
centering=1/2;
gamma_vec=10.^((index-centering*dec_num*bus_dec)./bus_dec);

bus_dec_sig=10;%busquedas por década
dec_num_sig=10;%numero de decadas
index_sig=(1:bus_dec_sig*dec_num_sig);%#busquedas
centering_sig=1/2;
sigma_vec=10.^...
    ((index_sig-centering_sig*dec_num_sig*bus_dec_sig)./bus_dec_sig);

[GAMMA,SIGMA]=meshgrid(gamma_vec,sigma_vec);
Bag_vals=[GAMMA(:),SIGMA(:)]';

fprintf('Getting in the stuff\n');

for index=1:length(Bag_vals)
    gamma=Bag_vals(1,index);
    sigma=Bag_vals(2,index);
    generateKermatrix;
    Eqsys;
    validator;
end

fprintf('Finished_mesh\n');
clear Bag_values centering centering_sig;
error_por=reshape(error_por,size(GAMMA));
ploterrorsigma;
fprintf('error mínimo aprox:\t%f\n',min(error_por(:)));

%% Construcción de paso siguiente
gamma_vec=GAMMA(error_por(:)==min(error_por(:)))';
sigma_vec=SIGMA(error_por(:)==min(error_por(:)))';
index_not=gamma_vec.*sigma_vec==min(gamma_vec.*sigma_vec); 
%nos  quedamos con el de menor peso cruzado
gamma_vec=gamma_vec(index_not);
sigma_vec=sigma_vec(index_not);
clear index_not GAMMA SIGMA Bag_vals
gamma_vec=gamma_vec(1);
sigma=sigma_vec(1);

generateKermatrix;
%Sigma is now selected. I have noticed the system is more 
%robust against changes in sigma

%% Nit-pick gamma
fprintf('Looking closer\nChosen sigma is:\t%f\n',sigma);
error_por=[];
steps=100;
all_gammas=zeros(length(gamma_vec),steps);
index=1;

for gamma_s=gamma_vec
    all_gammas(index,1:steps)=[
        linspace(gamma_s-gamma_s*log(10)/bus_dec,gamma_s,steps/2),....
        linspace(gamma_s,gamma_s+gamma_s*log(10)/bus_dec,steps/2)];
    index=index+1;
end
all_gammas=all_gammas(:)';

fprintf('Got all gammas\n');

for gamma=all_gammas
    Eqsys;
    validator;
end
gamma=min(all_gammas(error_por==min(error_por)));
ploterrorgamma;
fprintf('Gamma selected:\t%f\n',gamma);
%% Mapeado Superficie
error_por=[];
Eqsys;
validator;
fprintf('Error is %g%%  \n',error_por*100);
str=[name_data,'res_ker_gauss',num2str(meta)];
save(str,'gamma','error_por','p','b','sigma','train_data','boot_data')
clear sigma index all_gammas b.* D 
clear d.* e* g* i* K* machine_data t* Y si* s se*