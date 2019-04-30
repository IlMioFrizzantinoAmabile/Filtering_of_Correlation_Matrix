function E = Exp_KL1(n,T)
%Valore atteso della distanza KL tra C e SIGMA
E = n*log(T/2);
for p=(T-n+1):T
    E = E-psi(p/2);
end
E = E/2;
end

