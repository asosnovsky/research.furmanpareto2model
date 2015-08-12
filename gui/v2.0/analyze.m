function [ ana ] = analyze( X )
% Ordering function
    function [odata] = orderIT(dt, corr, E, V, E2) 
        disp(dt);
        odata = cell(length(dt.a)+2,length(dt.a));
        odata(1,1)= num2cell(corr);
        odata(2,:)= num2cell(E);
        odata(3,:)= num2cell(V);
        odata(4,:)= num2cell(E2);
        odata(5,1)= num2cell(dt.a0);
        odata(7,:)= num2cell(dt.a);
        if(isfield(dt,'s'))     
            odata(6,:)= num2cell(dt.s);
        end
    end
% Get Basic data
    E = mean(X);
    V = var(X);
    E2 = mean(X.^2);
    p = corr(X,'Type','Pearson');
    k = corr(X,'Type','Kendall');
    s = corr(X,'Type','Spearman');
% Analyze data    
    ana = struct('Pearson',struct(),'Kendall',struct(),'Spearman',struct());
    % Pearson
    est = estimate(E, E2, V, p(2));
        ana.Pearson.V = orderIT(est.V, p(2), E, V, E2);
        ana.Pearson.E2 = orderIT(est.E2, p(2), E, V, E2);
        ana.Pearson.null = orderIT(nullestimate(E, p(2)), p(2), E, V, E2);
    % Kendall
    est = estimate(E, E2, V, k(2));
        ana.Kendall.V = orderIT(est.V, k(2), E, V, E2);
        ana.Kendall.E2 = orderIT(est.E2, k(2), E, V, E2);
        ana.Kendall.null = orderIT(nullestimate(E, k(2)), k(2), E, V, E2);
    % Spearman
    est = estimate(E, E2, V, s(2));
        ana.Spearman.V = orderIT(est.V, s(2), E, V, E2);
        ana.Spearman.E2 = orderIT(est.E2, s(2), E, V, E2);
        ana.Spearman.null = orderIT(nullestimate(E, s(2)), s(2), E, V, E2);
    % Final
    ana = { {ana.Pearson.V, ana.Pearson.E2, ana.Pearson.null} , {ana.Kendall.V, ana.Kendall.E2, ana.Kendall.null} ,{ana.Spearman.V, ana.Spearman.E2, ana.Spearman.null}};
end

