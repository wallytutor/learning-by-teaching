function h = graf_plot(t, Y, saveas)
    % Display solution of kinetics integration in a standard way.
    h = figure();

    subplot(2,2,1);
    plot(t, Y(:,1), "linewidth", 4);
    grid();
    set(gca, 'GridLineStyle', ':');
    xlabel("Time (s)");
    ylabel("Mass fraction");
    l = legend("C_2H_2  ");
    set(l, 'location', 'northeast');

    subplot(2,2,2);
    plot(t, Y(:,[2, 7]), "linewidth", 4);
    grid();
    set(gca, 'GridLineStyle', ':');
    xlabel("Time (s)");
    ylabel("Mass fraction");
    l = legend({"H_2  ", "C_s  "});
    set(l, 'location', 'northwest');

    subplot(2,2,3);
    plot(t, Y(:,3:4), "linewidth", 4);
    grid();
    set(gca, 'GridLineStyle', ':');
    xlabel("Time (s)");
    ylabel("Mass fraction");
    l = legend({"C_2H_4  ", "CH_4 "});
    set(l, 'location', 'northwest');

    subplot(2,2,4);
    plot(t, Y(:,5:6), "linewidth", 4);
    grid();
    set(gca, 'GridLineStyle', ':');
    xlabel("Time (s)");
    ylabel("Mass fraction");
    l = legend({"C_4H_4  ", "C_6H_6  "});
    set(l, 'location', 'northwest');

    print(saveas, '-dpng', '-r300');
endfunction
