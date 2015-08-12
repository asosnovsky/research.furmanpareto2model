function [ est ] = estimate ( E, p )
    est = struct('a0',0,'a',[]);
    est.a0 = (E(1)+E(2))*( ((1/p)*sqrt( ( (1-E(1))*(1-E(2)) )/( (1+E(1))*(1+E(2)) ) )+1)^(-1) )/(E(1)*E(2));
    est.a = 1./E+1-est.a0;
end
