iterazioni = 100;
simulazioni = 1;
n=5; T=15;
%percentuale;
dc=0;

figure; hold on
xlabel('Informazione')
ylabel('Stabilità')
BIG_media = zeros(3,5);
Expected_param2 = Exp_KL1(n,T);
Expected_param3 = Exp_KL2(n,T);
for simul=1:simulazioni
    %progresso = [100*(simul/simulazioni+percentuale)/108, 100, 100*simul/simulazioni, 100]
    progresso = [100*simul/simulazioni, 100]
    r=rand(n,10*n);
    r = r - mean(r')'*ones(1,10*n);
    SIGMA=r*r';
    
    %calcolo la correlazione
    D=diag(sqrt( (diag(SIGMA)).^-1 ));
    CORR = D*SIGMA*D;
    %calcolo la radice di sigma per generare vettori gaussiani di media nulla e varianza SIGMA
    [V,D]=eig(SIGMA);
    Dsqr = sqrt(D);
    sqrSIGMA = V*Dsqr*V';
    %alcuni vettori utili
    paramN1=zeros(1,5); mediaN1=zeros(1,5);
    paramN2=zeros(1,5); mediaN2=zeros(1,5);
    param1=zeros(1,5); media1=zeros(1,5);
    param2=zeros(1,5); media2=zeros(1,5);
    param3=zeros(1,5); media3=zeros(1,5);

    corr=zeros(n); corr2=zeros(n);
    Cmax=zeros(n); C2max=zeros(n);
    Cmed=zeros(n); C2med=zeros(n);
    Cros=zeros(n); C2ros=zeros(n);
    Cpot=zeros(n); C2pot=zeros(n);
    
    BIG_C = zeros(iterazioni,n,n);
    BIG_Cmax = zeros(iterazioni,n,n);
    BIG_Cmed = zeros(iterazioni,n,n);
    BIG_Cros = zeros(iterazioni,n,n);
    BIG_Cpot = zeros(iterazioni,n,n);
    for it=1:iterazioni
        dati=zeros(n,T);
        for i=1:T
            dati(:,i)= sqrSIGMA*randn(n,1);
        end
        dati = dati - mean(dati')'*ones(1,T);
        C = dati*dati'/T;
        D=diag(sqrt( (diag(C)).^-1 ));
        corr = D*C*D;
        if det(corr)==0
            dc=dc+1
        end
        [Cmax,Cmed,Cros,Cpot] = simulazione(C,n,T);
        BIG_C(it,:,:)=corr;
        BIG_Cmax(it,:,:)=Cmax;
        BIG_Cmed(it,:,:)=Cmed;
        BIG_Cros(it,:,:)=Cros;
        BIG_Cpot(it,:,:)=Cpot;
    end
    for it=1:iterazioni
        corr(:,:) = BIG_C(it,:,:);
        Cmax(:,:) = BIG_Cmax(it,:,:);
        Cmed(:,:) = BIG_Cmed(it,:,:);
        Cros(:,:) = BIG_Cros(it,:,:);
        Cpot(:,:) = BIG_Cpot(it,:,:);
%         if det(CMax)==0
%             dc=dc+1
%         end
        param2 = [KL(corr,Cmax),KL(corr,Cmed),KL(corr,Cros),KL(corr,Cpot),KL(corr,CORR)];
        %param2 = [norm(corr-Cmax,inf),norm(corr-Cmed,inf),norm(corr-Cros,inf),norm(corr-Cpot,inf),norm(corr-CORR,inf)];
        %param2 = [norm(CORR-Cmax,inf),norm(CORR-Cmed,inf),norm(CORR-Cros,inf),norm(CORR-Cpot,inf),norm(corr-CORR,inf)];
        media2 = media2 + param2;
    end
    media2 = media2./iterazioni;
    for it=1:(iterazioni-1)
        corr(:,:) = BIG_C(it,:,:);
        Cmax(:,:) = BIG_Cmax(it,:,:);
        Cmed(:,:) = BIG_Cmed(it,:,:);
        Cros(:,:) = BIG_Cros(it,:,:);
        Cpot(:,:) = BIG_Cpot(it,:,:);
        for jt=(it+1):iterazioni
            corr2(:,:) = BIG_C(jt,:,:);
            C2max(:,:) = BIG_Cmax(jt,:,:);
            C2med(:,:) = BIG_Cmed(jt,:,:);
            C2ros(:,:) = BIG_Cros(jt,:,:);
            C2pot(:,:) = BIG_Cpot(jt,:,:);
            param3 = [KL(Cmax,C2max),KL(Cmed,C2med),KL(Cros,C2ros),KL(Cpot,C2pot),KL(corr,corr2)];
            %param3 = [norm(Cmax-C2max,inf),norm(Cmed-C2med,inf),norm(Cros-C2ros,inf),norm(Cpot-C2pot,inf),norm(corr-corr2,inf)];
            media3 = media3 + param3;
        end
    end
    media3 = media3./(iterazioni*(iterazioni-1)/2);
    
    plot(media2(1),media3(1),'.y');
    plot(media2(2),media3(2),'.b');
    plot(media2(3),media3(3),'.g');
    plot(media2(4),media3(4),'.m');
    %plot(media2(5),media3(5),'.k');
    for filt=1:5
        BIG_media(1,filt) = BIG_media(1,filt) + media1(filt);
        BIG_media(2,filt) = BIG_media(2,filt) + media2(filt);
        BIG_media(3,filt) = BIG_media(3,filt) + media3(filt);
    end
end
BIG_media(:,:) = BIG_media(:,:)./simulazioni;
%plotta medie finali
plot(BIG_media(2,1),BIG_media(3,1),'*y');
plot(BIG_media(2,2),BIG_media(3,2),'*b');
plot(BIG_media(2,3),BIG_media(3,3),'*g');
plot(BIG_media(2,4),BIG_media(3,4),'*m');
%plot(BIG_media(2,5),BIG_media(3,5),'*k');

%plotta linee rosse e verdi
plot(ones(1,1161)*Expected_param2 , -10:1150 , 'g')
plot(-10:1150 , ones(1,1161)*Expected_param3 , 'r')
legend('Max','Med','Potter','Rosenow')
xlim([0,1.6*Expected_param2])
ylim([0,1.1*Expected_param3])
%xlim([0,1.6*BIG_media(2,5)])
%ylim([0,1.1*BIG_media(3,5)])
% xlim([0,1.6*MAX(Expected_param2,BIG_media(2,5))])
% ylim([0,1.1*MAX(Expected_param3,BIG_media(3,5))])
title('N='+string(n)+'    T='+string(T))
hold off
saveas(gcf,'Plot_Teorici\Plot_n'+string(n)+'_T'+string(T)+'_it'+string(iterazioni)+'_simul'+string(simulazioni)+'.png')


%percentuale=percentuale+1;
