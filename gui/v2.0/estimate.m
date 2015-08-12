function [ est ] = estimate ( E, E2, V, p )
    est = struct('E2',struct(),'V',struct());
    est.V.s = ( ( V + E.^2 )./(V-E.^2) ).*E;
    est.V.a0k = est.V.s ./E + 1;
    est.V.a0 = (sum(est.V.a0k)-2)*(sqrt((est.V.a0k(1)-2)*(est.V.a0k(2)-2)/prod(est.V.a0k))/p+1)^(-1);
    est.V.a = est.V.s./E + 1 - est.V.a0;
    
    est.E2.s = ( 1 + (2.*E.^2)./E2 ).*E;
    est.E2.a0k = est.E2.s ./E + 1;
    est.E2.a0 = (sum(est.E2.a0k)-2)*(sqrt((est.E2.a0k(1)-2)*(est.E2.a0k(2)-2)/prod(est.E2.a0k))/p+1)^(-1);
    est.E2.a = est.E2.s./E + 1 - est.E2.a0;
end