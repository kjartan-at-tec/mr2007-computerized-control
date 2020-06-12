%% Root locus exercise. Pair transfer function and root locus
% Kjartan halvorsen
% 2018-02-15
% 2019-09-03 Modified from continuous-time version 

h = 0.3;
G{1} = c2d(zpk([-2],[0,0,-4], 2),h);
G{2} = c2d(zpk([],[0,0,-4], 4),h);
G{3} = c2d(zpk([-2],[0,-4], 2),h);
G{4} = c2d(zpk([-2],[0,-4,-8], 16),h);

annot = {'A', 'B', 'C', 'D'};

figure(1)
clf
for i=1:4
    subplot(2,2,i)
    rlocus(G{i})
    xlim([-2.3,1.2])
    ylim([-1.3,1.3])
    title('')
    xlabel('Re')
    ylabel('Im')
    
    text(-1.8,-1, annot{i}, 'fontsize', 20)

    G{i}
end

print -dpdf -bestfit rlocus_2x2.pdf

