function [corrFmax,corrFmed,corrFros,corrFpot] = simulazione(C,n,T)
%SIMULAZIONE
D=diag(sqrt( (diag(C)).^-1 ));
corr = D*C*D;

corrFmax = filtraggio_MAX(corr);
corrFmed = filtraggio_MED(corr);
lambda_max = 1 + n/T + 2*sqrt(n/T); %Boh
corrFros = filtraggio_ROS(corr,lambda_max);
corrFpot = filtraggio_POT(corr,lambda_max);


% KLmax = KL(corr,corrFmax);
% KLmed = KL(corr,corrFmed);
% KLros = KL(corr,corrFros);
% KLpot = KL(corr,corrFpot);
% 
% Expected = Exp_KL1(n,T);
end

