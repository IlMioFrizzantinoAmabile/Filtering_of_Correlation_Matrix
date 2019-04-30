function x = KL(M,N)
%Kullback-Leibler distance
% if (det(M)==0) or (det(N)==0)
%     x=0;
% else
    [n,~]=size(M);
    x = log(det(N)/det(M)) + sum(diag(inv(N)*M)) - n;
    x = x/2;
% end
end

