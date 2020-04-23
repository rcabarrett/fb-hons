

function binned = basics(experiment, fixed, sumTable, targetTrial, limits)

    direc = strcat('/Users/16132/Documents/lab/KAT/', experiment, '/plots/');
    
    % calculate statistics by bin
    binned = grpstats(sumTable, {'Subject', 'Condition', 'TrialBin'}, {'mean', 'predci'}, 'datavars', {'Accuracy', 'rt2', 'dur2', 'fc2', 'irrelp2', 'rt4', 'dur4', 'fc4', 'irrelp4', 'Optimization', 'p4features', 'p4button'});
    subjects = unique(binned.Subject);
    
%% plots using gramm
% accuracy/learning curve
    g = gramm('x', binned.TrialBin, 'y', binned.mean_Accuracy, 'color', binned.Condition);
    
    g.stat_summary();   
    g.set_point_options('base_size',3);
    g.axe_property('YLim', [0 1]);
    g.axe_property('XLim', [1 15]);
    
    %title = strcat('Learning curve:  ', experiment);
    %g.set_title(title);
    g.set_names('x','Trial Bin','y','Mean accuracy', 'color', 'Condition');

    figure()
    g.draw();
    
    fnPlot = strcat(direc, 'accuracy.png');
    saveas(gca, char(fnPlot));
    close all
    clear g
    

% fix duration (p4)
    g = gramm('x', binned.TrialBin, 'y', binned.mean_dur4, 'color', binned.Condition);
    
    g.stat_summary();   
    g.set_point_options('base_size',3);
    g.axe_property('YLim', [0 800]);     

    g.axe_property('XLim', [1 15]);
    
    %title = strcat('Fixation duration during feedback:  ', experiment);
    %g.set_title(title);
    g.set_names('x','Trial Bin','y','Mean fixation duration', 'color', 'Condition');

    figure()
    g.draw();
    
    fnPlot = strcat(direc, 'dur4.png');
    saveas(gca, char(fnPlot));
    close all
    clear g

% response time
    g = gramm('x', binned.TrialBin, 'y', binned.mean_rt2, 'color', binned.Condition);
    
    g.stat_summary();   
    g.set_point_options('base_size',3);
    g.axe_property('YLim', [0 9000]);      
    g.axe_property('XLim', [1 15]);
    
    %title = strcat('Response time:  ', experiment);
    %g.set_title(title);
    g.set_names('x','Trial Bin','y','Mean response time', 'color', 'Condition');

    figure()
    g.draw();
    
    fnPlot = strcat(direc, 'rt2.png');
    saveas(gca, char(fnPlot));
    close all
    clear g
    
% opt p2
    g = gramm('x', binned.TrialBin, 'y', binned.mean_Optimization, 'color', binned.Condition);
    
    g.stat_summary();   
    g.set_point_options('base_size',3);
    g.axe_property('YLim', [-1 1]);        
    g.axe_property('XLim', [1 15]);
    
    %title = strcat('Gaze optimization:  ', experiment);
    %g.set_title(title);
    g.set_names('x','Trial Bin','y','Mean optimization', 'color', 'Condition');

    figure()
    g.draw();
    
    fnPlot = strcat(direc, 'opt.png');
    saveas(gca, char(fnPlot));
    close all
    clear g
    

% time irrel p2
    g = gramm('x', binned.TrialBin, 'y', binned.mean_irrelp2, 'color', binned.Condition);
    
    g.stat_summary();  
    g.set_point_options('base_size',3);
    g.axe_property('YLim', [0 800]);        
    g.axe_property('XLim', [1 15]);
    
    title = strcat('Time on irrelevant features pre-response:  ', experiment);
    g.set_title(title);
    g.set_names('x','Trial Bin','y','Mean time (per trial)', 'color', 'Condition');

    figure()
    g.draw();
    
    fnPlot = strcat(direc, 'irrel2.png');
    saveas(gca, char(fnPlot));
    close all
    clear g

% time irrel p4
    g = gramm('x', binned.TrialBin, 'y', binned.mean_irrelp4, 'color', binned.Condition);
    
    g.stat_summary();   
    g.set_point_options('base_size',3);
    g.axe_property('YLim', [0 800]);       
    g.axe_property('XLim', [1 15]);
    
    title = strcat('Time on irrelevant features during feedback:  ', experiment);
    g.set_title(title);
    g.set_names('x','Trial Bin','y','Mean time (per trial)', 'color', 'Condition');

    figure()
    g.draw();
    
    fnPlot = strcat(direc, 'irrel4.png');
    saveas(gca, char(fnPlot));
    close all
    clear g
    
    %% t-tests
    
    firstdur4 = [];
    cpdur4 = [];
    
    firstrt2 = [];
    cprt2 = [];
    
    firstopt2 = [];
    cpopt2 = [];
    
    
    % OK, I am taking the distribution of mean values for the first bin vs
    % the distribution of mean values for the CP bin. one value in each per
    % subject. 
    
    for i = 1:length(targetTrial)
        current = subjects(i);
        target = targetTrial(i);
        ind = find(limits > target);
        if isempty(ind)
            relevantBin = 15;
        else
            relevantBin = ind(1);
        end
        
        % ik I could do firstBin outside this loop, but this ensures that
        % first and cp bin are in the same order of subjects
        firstdur = binned.mean_dur4(binned.Subject == current & binned.TrialBin == 1);
        targdur = binned.mean_dur4(binned.Subject == current & binned.TrialBin == relevantBin);
        
        firstrt = binned.mean_rt2(binned.Subject == current & binned.TrialBin == 1);
        targrt = binned.mean_rt2(binned.Subject == current & binned.TrialBin == relevantBin);
        
        firstopt = binned.mean_Optimization(binned.Subject == current & binned.TrialBin == 1);
        targopt = binned.mean_Optimization(binned.Subject == current & binned.TrialBin == relevantBin);
        
        
        firstdur4 = [firstdur4; firstdur];
        cpdur4 = [cpdur4; targdur];
        firstrt2 = [firstrt2; firstrt];
        cprt2 = [cprt2; targrt];
        firstopt2 = [firstopt2; firstopt];
        cpopt2 = [cpopt2; targopt];
        
    end
    
    disp('fix duration p4')
    [h, p, ci, stats] = ttest(firstdur4, cpdur4)
    
    
    disp('response time')
    [h, p, ci, stats] = ttest(firstrt2, cprt2)
    
    
    disp('optimization')
    [h, p, ci, stats] = ttest(firstopt2, cpopt2)
    
    
    %% now by condition (for fb2/fb3. comment this section out for self-paced exps)
    disp('now BY CONDITION...these are independent samples')
    
    ninesec = sumTable(sumTable.Condition == 9000, :);
    onesec = sumTable(sumTable.Condition == 1000, :);
    
    % cp
    cpNine = [];
    subjects = unique(ninesec.Subject);
    for i = 1:length(subjects)
       filtered = ninesec.CP(ninesec.Subject == subjects(i));
       cpNine = [cpNine; filtered(1)];
    end
    
    cpOne = [];
    subjects = unique(onesec.Subject);
    for i = 1:length(subjects)
       filtered = onesec.CP(onesec.Subject == subjects(i));
       cpOne = [cpOne; filtered(1)];
    end
    
    disp('cp')
    [h, p, ci, stats] = ttest2(cpOne, cpNine)
    
    % dur p4
    disp('fixation duration p4')
    [h, p, ci, stats] = ttest2(onesec.dur4, ninesec.dur4)
    
    % dur p2
    disp('fixation duration p2')
    [h, p, ci, stats] = ttest2(onesec.dur2, ninesec.dur2)
    
    % optimization
    disp('optimization')
    [h, p, ci, stats] = ttest2(onesec.Optimization, ninesec.Optimization)
    
    % response time first bin
    disp('response time: bin 1')
    rtOne = onesec.rt2(onesec.TrialBin == 1);
    rtNine = ninesec.rt2(ninesec.TrialBin == 1);
    
    [h, p, ci, stats] = ttest2(rtOne, rtNine)
    
    
    


%% p4 duration FOR non-fixed
    if ~fixed
        g = gramm('x', binned.TrialBin, 'y', binned.mean_rt4);

        g.stat_summary();   
        g.set_point_options('base_size',3);
        g.axe_property('YLim', [0 7000]);        
        g.axe_property('XLim', [1 15]);

       % title = strcat('Time on feedback:  ', experiment);
       % g.set_title(title);
        g.set_names('x','Trial Bin','y','Mean feedback time', 'color', 'Condition');

        figure()
        g.draw();

        fnPlot = strcat(direc, 'rt4.png');
        saveas(gca, char(fnPlot));
        close all
        clear g
        
        % t-test
        firstBin = [];
        cpBin = [];
        
        % same process as above
        for i = 1:length(targetTrial)
            current = subjects(i);
            target = targetTrial(i);
            ind = find(limits > target);
            relevantBin = ind(1);

            first = binned.mean_rt4(binned.Subject == current & binned.TrialBin == 1);
            targ = binned.mean_rt4(binned.Subject == current & binned.TrialBin == relevantBin);
            
            firstBin = [firstBin; first];
            cpBin = [cpBin; targ];

        end
        
        disp('time on feedback')
        [h, p, ci, stats] = ttest(firstBin, cpBin)
        
    end
    

end