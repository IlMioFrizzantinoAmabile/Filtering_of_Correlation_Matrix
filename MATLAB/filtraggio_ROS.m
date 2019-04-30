function Filt = filtraggio_ROS(C,lambda_max)
% Filtraggio tramite diagonalizzazione ortogonale
% Si mettono gli autovalori piccoli a 0. Poi si mette 1 nella diagonale
Filt = C;
[n,~]=size(Filt);
[V,D]=eig(Filt);
autovalori = diag(D);
for i=1:n
    if D(i,i)<lambda_max
        D(i,i)=0;
    end
end
Filt = V*D*V';
for i=1:n
    Filt(i,i)=1;
end
end

