function Filt = filtraggio_POT(C,lambda_max)
% Filtraggio tramite diagonalizzazione ortogonale
% Si mettono gli autovalori piccoli uguali alla loro media
Filt = C;
[n,~]=size(Filt);
[V,D]=eig(Filt);
%calcola la media
media=0; counter=0;
for i=1:n
    if D(i,i)<lambda_max
        media = media + D(i,i);
        counter=counter+1;
    end
end
if counter>0
    media = media/counter;
    for i=1:n
        if D(i,i)<lambda_max
            D(i,i) = media;
        end
    end
    Filt = V*D*V';
    scal=sqrt(inv(diag(diag(Filt))));
    Filt = scal*Filt*scal;
end

