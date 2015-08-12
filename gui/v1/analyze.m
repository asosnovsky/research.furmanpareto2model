function [ ana ] = analyze( X )
    E = mean(X);
    p = corr(X,'Type','Pearson');
    k = corr(X,'Type','Kendall');
    s = corr(X,'Type','Spearman');
    ana = struct('Pearson',struct(),'Kendall',struct(),'Spearman',struct());
    ana.Pearson = estimate(E, p(2));
    ana.Pearson.corr = p(2);
    ana.Kendall = estimate(E, k(2));
    ana.Kendall.corr = k(2);
    ana.Spearman = estimate(E, s(2));
    ana.Spearman.corr = s(2);
end
