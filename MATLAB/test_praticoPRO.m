%n=7; T=17;
dc=0;

BIG_DATA;
[num_stock,lung_dati] = size(BIG_DATA);
%r=BIG_DATA(1:n,1:lung_dati);
%SIGMA=r*r';
%D=diag(sqrt( (diag(SIGMA)).^-1 ));
%CORR = D*SIGMA*D;


figure; hold on
xlabel('Informazione')
ylabel('Stabilità')
BIG_media = zeros(3,5);
Expected_param2 = Exp_KL1(n,T);
Expected_param3 = Exp_KL2(n,T);

num_simul = round(lung_dati/T - 0.5);

param2=zeros(1,5); media2=zeros(1,5);
param3=zeros(1,5); media3=zeros(1,5);
buoni=zeros(1,4);
saltati=0;
for scelta_stock=1:num_stock-n
    simulazione_numero = [scelta_stock, num_stock-n, saltati]
    
    corr=zeros(n); corr2=zeros(n);
    Cmax=zeros(n); C2max=zeros(n);
    Cmed=zeros(n); C2med=zeros(n);
    Cros=zeros(n); C2ros=zeros(n);
    Cpot=zeros(n); C2pot=zeros(n);
    
    BIG_C = zeros(num_simul,n,n);
    BIG_Cmax = zeros(num_simul,n,n);
    BIG_Cmed = zeros(num_simul,n,n);
    BIG_Cros = zeros(num_simul,n,n);
    BIG_Cpot = zeros(num_simul,n,n);
    salta=0;
    for simul=1:num_simul
        %simulazione_numero = [scelta_stock, num_stock-n, simul, num_simul]
        dati=BIG_DATA(scelta_stock:scelta_stock+n-1 , simul*T-T+1:simul*T);
        
        dati = dati - mean(dati')'*ones(1,T);
        C = dati*dati'/T;
        D=diag(sqrt( (diag(C)).^-1 ));
        corr = D*C*D;
        if (normMAX(corr)==inf) || (det(C)==0)
            salta=1;
        else
            C;
            [Cmax,Cmed,Cros,Cpot] = simulazione(C,n,T);
        end
        BIG_C(simul,:,:)=corr;
        BIG_Cmax(simul,:,:)=Cmax;
        BIG_Cmed(simul,:,:)=Cmed;
        BIG_Cros(simul,:,:)=Cros;
        BIG_Cpot(simul,:,:)=Cpot;
    end
    if salta==0
        for it=1:num_simul
            corr(:,:) = BIG_C(it,:,:);
            Cmax(:,:) = BIG_Cmax(it,:,:);
            Cmed(:,:) = BIG_Cmed(it,:,:);
            Cros(:,:) = BIG_Cros(it,:,:);
            Cpot(:,:) = BIG_Cpot(it,:,:);
            param2 = [KL(corr,Cmax),KL(corr,Cmed),KL(corr,Cros),KL(corr,Cpot),0];
            media2 = media2 + param2;
        end
        media2 = media2./num_simul;
        for it=1:(num_simul-1)
            corr(:,:) = BIG_C(it,:,:);
            Cmax(:,:) = BIG_Cmax(it,:,:);
            Cmed(:,:) = BIG_Cmed(it,:,:);
            Cros(:,:) = BIG_Cros(it,:,:);
            Cpot(:,:) = BIG_Cpot(it,:,:);
            for jt=(it+1):num_simul
                corr2(:,:) = BIG_C(jt,:,:);
                C2max(:,:) = BIG_Cmax(jt,:,:);
                C2med(:,:) = BIG_Cmed(jt,:,:);
                C2ros(:,:) = BIG_Cros(jt,:,:);
                C2pot(:,:) = BIG_Cpot(jt,:,:);
                param3 = [KL(Cmax,C2max),KL(Cmed,C2med),KL(Cros,C2ros),KL(Cpot,C2pot),KL(corr,corr2)];
                media3 = media3 + param3;
            end
        end
        media3 = media3./(num_simul*(num_simul-1)/2);

        plot(media2(1),media3(1),'.y');
        plot(media2(2),media3(2),'.b');
        plot(media2(3),media3(3),'.g');
        plot(media2(4),media3(4),'.m');
    %         plot(param2(1),param3(1),'.y');
    %         plot(param2(2),param3(2),'.b');
    %         plot(param2(3),param3(3),'.g');
    %         plot(param2(4),param3(4),'.m');
    %         plot(param2(5),param3(5),'*k');
        for filt=1:5
            BIG_media(2,filt) = BIG_media(2,filt) + media2(filt);
            BIG_media(3,filt) = BIG_media(3,filt) + media3(filt);
        end
    else
        saltati=saltati+1;
    end
end
BIG_media(:,:) = BIG_media(:,:)./(num_stock-n-saltati);
%plotta medie finali
plot(BIG_media(2,1),BIG_media(3,1),'*y');
plot(BIG_media(2,2),BIG_media(3,2),'*b');
plot(BIG_media(2,3),BIG_media(3,3),'*g');
plot(BIG_media(2,4),BIG_media(3,4),'*m');
plot(ones(1,1161)*Expected_param2 , -10:1150 , 'g')
plot(-10:1150 , ones(1,1161)*Expected_param3 , 'r')
%plot(-10:1150 , ones(1,1161)*BIG_media(3,5) , 'k')
legend('Max','Med','Potter','Rosenow')
xlim([0,2*Expected_param2])
ylim([0,1.35*Expected_param3])
title('N='+string(n)+'    T='+string(T))
hold off
saveas(gcf,'Plot_Pratici\PRO\Plot_n'+string(n)+'_T'+string(T)+'.png')


saltati