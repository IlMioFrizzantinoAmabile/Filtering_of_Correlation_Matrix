function E = Exp_KL2(n,T)
%Valore atteso della distanza KL tra C e Cfilt
E = n*(n+1)/(T-n-1);
E = E/2;
end

