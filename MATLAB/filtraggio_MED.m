function Filt = filtraggio_MED(C)
% Filtraggio tramite riduzione grafo a MST
% Ad ogni passo si prende la media pesata
Filt = C;
[n,~]=size(Filt);
cluster = zeros(n);
cluster_size = ones(n,1);
for i=1:n
    cluster(i,1)=i; %la riga i-esima rappresenta il cluster i-esimo
end

for iter=1:n-1
    %trova l'elemento massimo
    max=-1000000000; I_max = 0; J_max=0;
    for clusterA = 1:n
        for clusterB = (clusterA+1):n
            i=cluster(clusterA,1);
            j=cluster(clusterB,1);
            if (i~=0) && (j~=0)
                if Filt(i,j)>max
                    max=Filt(i,j);
                    I_max = clusterA;
                    J_max = clusterB;
                end
            end
        end
    end
    [I_max,J_max];
    %aggiorna la matrice Filtr nei cluster I_max e J_max
    for clusterK = 1:n
        if (clusterK~=I_max) && (clusterK~=J_max)  %k non appartenente ne a I ne a J
            for k_index=1:cluster_size(clusterK)
                k=cluster(clusterK,k_index);
                i=cluster(I_max,1);
                j=cluster(J_max,1);
                provv_med = cluster_size(I_max)*Filt(i,k) + cluster_size(J_max)*Filt(j,k);
                provv_med = provv_med /(cluster_size(I_max)+cluster_size(I_max));
                for q_index=1:cluster_size(I_max)  %modifico i Filt(q,k) con q \in I
                    q=cluster(I_max,q_index);
                        Filt(q,k) = provv_med;
                        Filt(k,q) = provv_med;
                end
                for q_index=1:cluster_size(J_max)  %modifico i Filt(q,k) con q \in J
                    q=cluster(J_max,q_index);
                        Filt(q,k) = provv_med;
                        Filt(k,q) = provv_med;
                end
            end
        end
    end
    %mergia i cluster I_max e J_max
    sizeI=cluster_size(I_max);
    sizeJ=cluster_size(J_max);
    for p=1:sizeJ
        cluster(I_max,sizeI+p) = cluster(J_max,p);
        cluster(J_max,p) = 0;
    end
    cluster_size(I_max) = sizeI+sizeJ;
    cluster_size(J_max) = 0;
end
        
%%%% evita che restituisca matrici non def pos%%%%
if det(Filt)<=0
    Filt=C;
end
%%%%% WATCH OUT %%%%%%%%%%


end