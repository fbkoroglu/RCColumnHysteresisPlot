%%
clear all
clc
%%

numfiles = 100;

%% Import Data
for k = 1:numfiles
    myfilename = sprintf('TestData/ID-%d.csv', k);
    DispForce{k} = importdata(myfilename);
end

spanData = sprintf('ShearSpans.xlsx');
spanList = importdata(spanData);

%% Find extremums of each hysteresis
HystExt = HysteresisExtremums(numfiles, DispForce);

%% Drift Ratio & Force Percentage
for k=1:numfiles
    driftRatios{k} = (DispForce{k}(:,1)/spanList(k))*100;
    [maxVal(k), locMax(k)] = max(DispForce{k}(:,2));
    [minVal(k), locMin(k)] = min(DispForce{k}(:,2));
end

%% Plot
for k=1:numfiles
    h=figure(k);
    
    % Figure size
    x0=10;
    y0=10;
    width=1000;
    height=650;
    set(gcf,'position',[x0,y0,width,height])
    h.Visible = 'off';
        
    % Plot data
    plot(DispForce{k}(:,1),DispForce{k}(:,2), 'LineWidth',0.75, 'Color', '#808080');
    hold on    
    
    plot(HystExt(k,6),HystExt(k,5), 'o', 'MarkerFaceColor', '#000000', 'MarkerEdgeColor', '#000000', 'MarkerSize',6, 'LineWidth', 2);
    plot(HystExt(k,2),HystExt(k,1), 's', 'MarkerFaceColor', '#000000', 'MarkerEdgeColor', '#000000', 'MarkerSize',6, 'LineWidth', 2);
    
    plot(HystExt(k,4),HystExt(k,3), 's', 'MarkerFaceColor', '#000000', 'MarkerEdgeColor', '#000000', 'MarkerSize',6, 'LineWidth', 2);     
    plot(HystExt(k,8),HystExt(k,7), 'o', 'MarkerFaceColor', '#000000', 'MarkerEdgeColor', '#000000', 'MarkerSize',6, 'LineWidth', 2);
    
    plot([floor(-1.1*max(abs(DispForce{k}(:,1)))/10)*10, ceil(1.1*max(abs(DispForce{k}(:,1)))/10)*10], [zeros(2)], 'Color', 'black');
    plot([zeros(2)],[floor(-1.1*max(abs(DispForce{k}(:,2)))/10)*10 ceil(1.1*max(abs(DispForce{k}(:,2)))/10)*10], 'Color', 'black');
    
    % Legend and axis limits
    lgd = legend({sprintf('Test Data\n'),sprintf('Lateral Load Capacity\n'), sprintf('Ultimate Displacement Capacity')},...
        'Location', 'northeastoutside', 'interpreter','latex', 'FontSize', 10);
    lgd.NumColumns = 1;
    
    
    xlim([floor(-1.1*max(abs(DispForce{k}(:,1)))/10)*10 ceil(1.1*max(abs(DispForce{k}(:,1)))/10)*10])
    ylim([floor(-1.1*max(abs(DispForce{k}(:,2)))/10)*10 ceil(1.1*max(abs(DispForce{k}(:,2)))/10)*10])
    
    % Create text box
    ax = gca; 
    ax.Position(3) = 0.55;
    
    str = {['\underline{Test Data Extremums:}'],...
        [],...
        ['$$V_{max}$$ = ',num2str(round(HystExt(k,5),2),'%4.2f'), ' $$kN$$', ' ','\quad $$\Delta_{V_{max}}$$ = ',num2str(round(HystExt(k,6),2),'%4.2f'),' $$mm$$'],...        
        ['$$V_{min}$$ = ',num2str(round(HystExt(k,7),2),'%4.2f'), ' $$kN$$', '\quad $$\Delta_{V_{min}}$$ = ',num2str(round(HystExt(k,8),2),'%4.2f'),' $$mm$$'],...
        [],...
        ['$$V_{\Delta_{ult_{max}}}$$ = ',num2str(round(HystExt(k,1),2),'%4.2f'),' $$kN$$',' ','\quad $$\Delta_{ult_{max}}$$ = ',num2str(round(HystExt(k,2),2),'%4.2f'),' $$mm$$'],...
        ['$$V_{\Delta_{ult_{min}}}$$ = ',num2str(round(HystExt(k,3),2),'%4.2f'),' $$kN$$','\quad $$\Delta_{ult_{min}}$$ = ',num2str(round(HystExt(k,4),2),'%4.2f'),' $$mm$$'],...
        [],...
        ['\underline{Drift Ratio (DR) at Extremums:}'],...
        [],...
        ['$$DR_{max} $$ = ',num2str(round(max(driftRatios{k}),2),'%4.2f'),' \%',' ','\quad $$DR_{V_{max}} $$ = ',num2str(round(driftRatios{k}(locMax(k)),2),'%4.2f'),' \%'],...
        ['$$DR_{min} $$ = ',num2str(round(min(driftRatios{k}),2),'%4.2f'),' \%','\quad $$DR_{V_{min}} $$ = ',num2str(round(driftRatios{k}(locMin(k)),2),'%4.2f'),' \%'],...
        [],...
        ['$$Note: DR=\frac{\Delta}{h_{ShearSpan}}\times100$$']};  
    
    annotation('textbox', [0.6578, 0.45, 0.275, 0.36], 'String', str, 'Interpreter', 'latex', 'FitBoxToText', 'off', 'FontSize', 10, 'FontName', 'FixedWidth');
    
    % Axis labels and the title
    xlabel('Displacement (mm)', 'Interpreter', 'latex', 'FontSize', 10);
    ylabel('Lateral Load (kN)', 'Interpreter', 'latex', 'FontSize', 10);
    
    xaxisproperties= get(gca, 'XAxis');
    xaxisproperties.TickLabelInterpreter = 'latex'; % latex for x-axis
    
    yaxisproperties= get(gca, 'YAxis');
    yaxisproperties.TickLabelInterpreter = 'latex';   % tex for y-axis

    title(['\textbf{Circular Column, ID: ', num2str(k), '}'], ...
      'Interpreter', 'latex', 'FontSize', 12);
  
    % Grids
    grid on
    grid minor

    % Save the plots   
    h.PaperOrientation = 'landscape';
    print(h, sprintf('HysteresisPlots-PDF-C/FIG%d.pdf', k), '-dpdf', '-bestfit');
    clf(h)
    
end

%% Write Excels
% sz = [numfiles 13];
% varTypes = ["single","double","double","double","double","double","double","double","double","double","double","double","double"];
% varNames = ["ID","Vmax [kN]","dVmax [mm]","Vmin [kN]","dVmin [mm]","Vdultmax [kN]","dultmax [mm]","Vdultmin [kN]","dultmin [mm]","DRmax [%]","DRVmax [%]","DRmin [%]","DRVmin [%]"];
% DataExtremums = table('Size',sz,'VariableTypes',varTypes,'VariableNames',varNames);
% 
% for k=1:numfiles
%     DataExtremums(k,1) = table(round(k));
%     DataExtremums(k,2) = table(round(HystExt(k,5),4));
%     DataExtremums(k,3) = table(round(HystExt(k,6),4));
%     DataExtremums(k,4) = table(round(HystExt(k,7),4));
%     DataExtremums(k,5) = table(round(HystExt(k,8),4));
%     DataExtremums(k,6) = table(round(HystExt(k,1),4));
%     DataExtremums(k,7) = table(round(HystExt(k,2),4));
%     DataExtremums(k,8) = table(round(HystExt(k,3),4));
%     DataExtremums(k,9) = table(round(HystExt(k,4),4));
%     DataExtremums(k,10) = table(round(max(driftRatios{k}),4));
%     DataExtremums(k,11) = table(round(driftRatios{k}(locMax(k)),4));
%     DataExtremums(k,12) = table(round(min(driftRatios{k}),4));
%     DataExtremums(k,13) = table(round(driftRatios{k}(locMin(k)),4));
% end
% 
% filename = 'TestDataExtremums-C.xlsx';
% writetable(DataExtremums,filename,'Sheet',1,'Range','A1')