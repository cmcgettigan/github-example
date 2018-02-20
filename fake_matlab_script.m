%% 2017 E.K. --> Elise.Kanber@rhul.ac.uk
% This script aims to:
% 1. Read in data from Excel & define variables
% 2. Find the mean F0 & aVTL for 10 sound conditions. 
% 3. Calculate the difference in pitch (semitones) from baseline using the
    % mean F0 per condition
% 4. Calculate the aVTL length difference (cm) from baseline (BEAD/BARD5)
    % using the mean aVTL per condition 
% 5. Create a figure containing: 2 bar graphs plotting Normed pitch and aVTL
    % change per sound condition; and 2 scatterplots displaying Normed pitch
    % change against aVTL change at each sound condition. 
% 6. Repeat steps 1-5 for all data listed under subs
%% STEP 1: Read in the data
% Set up a list of subject IDs - each one corresponds to a Sheet in the
% Excel file

%% Here I'm just going to add some redundant text so I can make a new commit. In this I'm going to say that I'm trying out github for the first time.

subs = {
    '870417DW'
    '881212EW' 
    '910109JRA'
    '910508AJ' 
    '920819LC' 
    '930120EP' 
    '931115OM' 
    '940222JL' 
    '941021HP' 
    '941128JR' 
    '941224KN' 
    '950213PN' 
    '950917SG' 
    '951006LYN' 
    '951017RF' 
    '951017SM' 
    '951020CB' 
    '951223KS' 
    '960209AS' 
    '960508EB' 
    '960815NJ' 
    '960923LB' 
    '961016CH' 
    '961101MD' 
    '961126SO' 
    '961220LV' 
    '970128SC' 
    '970303ES'
    '970314JA'
    '970729EM'
    '971028PU'
    '731023AG'
    '791128RIA'
    '820427TA'
    '890728NMMG'
    '901231JL'
    '920910FT'
    '940318UM'
    '940604PA'
%     '941130SS' %Tracking to do
    '950405SRK' 
    '960214JB'
%     '960701DR' %Luke
%     '961210NF' %Luke
%     '890606EA' %Luke
    '800523AF'
    '890215RH'
    '921116EAG'
    '870223LA'
    '800805GB'
    '910810AG'
    '920221DAF'
    '780606BSW'
    '910521RT'
    '820430JGA'
    };
    
for j = 1:length(subs)
%Which datasheet?
Datasheet = subs{j}
    
%Read the data from Excel
Data = xlsread('fMRI_Data_Matlab.xls', Datasheet, 'A:Q'); %Reads Columns A to Q from the Excel spreadsheet fMRI_Data_MATLAB.xlsx

%Extract the data we need (condition, mean F0, aVTL)
SoundType = Data (:,1); % numbered 1-10
F0 = Data (:,5); 
aVTL = Data (:, 17); 

%Sound type list in order should be an 10x1 array. Works with ' ' for me,
%but others require single ' ' ?
Sound_Type_String_Array = {'BEAD1';'BEAD5'; 'BEAD9'; 'BEAD10'; 'BEAD17'; 'BARD1'; 'BARD5'; 'BARD9'; 'BARD10'; 'BARD17'};
Sound_Type_List_CAT = categorical (Sound_Type_String_Array); %This will make it a categorical array - but alphabeticised

%Reorders the categories as they are on spreadsheet
Sound_Type_List = reordercats (Sound_Type_List_CAT, {'BEAD1', 'BEAD5', 'BEAD9', 'BEAD10', 'BEAD17', 'BARD1', 'BARD5', 'BARD9', 'BARD10', 'BARD17'});

%Order of categories for bar graph - Probs an easier way to do this NOTE: Also need to reorder the
%Semitone_Change & Normed_aVTL - Not sure I need this anymore
% BEAD_List_BarGraph = ['BEAD1'; 'BEAD3'; 'BEAD7'; 'BEAD9'; 'BEAD10'; 'BEAD12'; 'BEAD15'; 'BEAD17'];
% BEAD_List_BarGraph = categorical (BEAD_List_BarGraph);
% BARD_List_BarGraph = ['BARD1'; 'BARD3'; 'BARD7'; 'BARD9'; 'BARD10'; 'BARD12'; 'BARD15'; 'BARD17'];
% BARD_List_BarGraph = categorical (BARD_List_BarGraph);

%% Step 2: finds the mean F0 & aVTL for each sound type, the normed pitch change (Semitones), and the normed aVTL change (cm) 
for n = 1:10
M_F0(n)= nanmean(F0(SoundType == n)); %mean F0 for each sound type (e.g. BEAD1, BEAD3 etc.)
end 

M_F0 = M_F0(:) %Rearranges everything into a column

for m = 1:10
    Mean_aVTL(m) = nanmean(aVTL(SoundType == m));
end

Mean_aVTL = Mean_aVTL(:) %Rearranges everything into a column

%Works out the normed pitch change (Semitones)
Semitone_Change_BEAD = log2(M_F0 (1:5)/M_F0(2))*12;
  Semitone_Change_BARD = log2(M_F0 (6:10)/ M_F0(7))*12;
  Semitone_Change = [Semitone_Change_BEAD; Semitone_Change_BARD]

%Works out the normed aVTL change in cm
aVTL_Normed_BEAD = Mean_aVTL(1:5) - Mean_aVTL(2);
  aVTL_Normed_BARD = Mean_aVTL(6:10) - Mean_aVTL(7);
  aVTL_Normed = [aVTL_Normed_BEAD; aVTL_Normed_BARD]
%% Step 3: Create a table containing Mean F0, Mean aVTL, Normed F0 aVTL change per condition (e.g. BEAD1, BEAD3... etc.)
Table1 = table(Sound_Type_List, M_F0, Mean_aVTL, Semitone_Change, aVTL_Normed)
writetable(Table1, 'fMRI_Output_Matlab.xls', 'sheet', subs{j})

% --> Make sure to use subs{k} somewhere in the savename of the table (i.e.
% the destination worksheet name)
%Figure out how to write table to file ---> use the subs variable to define
%the name of the new sheet in the exports to the Excel document

%% STEP 4: Create two bar graphs (one for BEADs, one for BARDs) including Normed pitch change (semitones) and normed aVTL change from baseline (cm).
% Create two scatterplots displaying Normed pitch change from baseline
% (Semitones) against Normed aVTL change from baseline (cm).
%Ordered Semitone_Change & Normed_aVTL for BAR graph

Pad = [NaN;NaN;NaN;NaN]; %So the bars don't overlap

ST_BEAD_Bar = Semitone_Change_BEAD;
ST_BEAD_Bar(2) = [];
ST_BEAD_Bar (:, 2) = Pad;
ST_BARD_Bar = Semitone_Change_BARD;
ST_BARD_Bar(2) = [];
ST_BARD_Bar (:, 2) = Pad;


aVTL_Normed_BEAD_Bar = aVTL_Normed_BEAD;
aVTL_Normed_BEAD_Bar(2) = [];
aVTL_Normed_BEAD_Bar(:, 2) = Pad
aVTL_Normed_BEAD_Bar (:, [1 2]) = aVTL_Normed_BEAD_Bar (:, [2 1]);
aVTL_Normed_BARD_Bar = aVTL_Normed_BARD;
aVTL_Normed_BARD_Bar(2) = [];
aVTL_Normed_BARD_Bar (:, 2) = Pad;
aVTL_Normed_BARD_Bar (:, [1 2]) = aVTL_Normed_BARD_Bar (:, [2 1]);

OrderBars = categorical ([1;2;3;4]);



%Another way: make the ST_change and Normed_aVTL into a matrix (i.e.
%bar_BEAD = [ST_BEAD_Bar, aVTL_Normed_BEAD_Bar]) Then: bar(BEAD_List_BarGraph, bar_BEAD, 'k') - how
%to change the colour of only one of the variables not all??? BUT this only
%gives one y axis?

% Try to do grouped bar graphs and index the .CData for even numbers bar to
% have a different colour?
%% Subplot 1:
Figure{j} = figure; %changed to {j} because when it was 1 it used the data from the previous pp to plot
left_colour  = [0 0 0];
right_colour = [0 0 0];
set (Figure{j}, 'defaultAxesColorOrder', [left_colour; right_colour]);

subplot(2, 2, 1);
p1 = bar (OrderBars, ST_BEAD_Bar, 'FaceColor', [0.55 0.55 0.55]);
   ylim ([-6.00, 6.00]); %Sets axis limits
   yticks([-6.00 -5.50 -5.00 -4.50 -4.00 -3.50 -3.00 -2.50 -2.00 -1.50 -1.00 -0.50 0.00 0.50 1.00 1.50 2.00 2.50 3.00 3.50 4.00 4.50 5.00 5.50 6.00]);
   ylabel ('Normed difference from baseline F0 (Semitones)');
   hold on
   set(gca,'yticklabel',num2str(get(gca,'ytick')','%.1f'))
yyaxis right %Creates another y axis on the right
p2 = bar (OrderBars, aVTL_Normed_BEAD_Bar, 'FaceColor', [0.95 0.95 0.95]); % NOTE: [0 0 0] = k, [1 1 1] = w
   ylim ([-6.00, 6.00]);
    yticks([-6.00 -5.50 -5.00 -4.50 -4.00 -3.50 -3.00 -2.50 -2.00 -1.50 -1.00 -0.50 0.00 0.50 1.00 1.50 2.00 2.50 3.00 3.50 4.00 4.50 5.00 5.50 6.00]);
   ylabel ('Normed difference from baseline aVTL (cm)');
   xlabel ('Sound Type');
  legend ([p1(1) p2(2)], 'Normed F0 Change', 'Normed aVTL Change', 'location', 'southeast')
ax = gca;
 set (ax, 'FontSize', 8);
 ax.XAxis.Color = 'k';
 lgd = legend('show')
 lgd.FontSize = 4;
 legend('boxoff')
 set(ax,'yticklabel',num2str(get(gca,'ytick')','%.1f'))
 set(ax, 'XTickLabel', {'BEAD1' 'BEAD9' 'BEAD10' 'BEAD17'})
xtickangle (45)
 hold off
 
%% Subplot 2:
subplot (2, 2, 2)
q1 = bar(OrderBars, ST_BARD_Bar,'FaceColor', [0.55 0.55 0.55])
   ylim ([-6, 6]) 
    yticks([-6.00 -5.50 -5.00 -4.50 -4.00 -3.50 -3.00 -2.50 -2.00 -1.50 -1.00 -0.50 0.00 0.50 1.00 1.50 2.00 2.50 3.00 3.50 4.00 4.50 5.00 5.50 6.00]);
   ylabel ('Normed difference from baseline F0 (Semitones)')
   set(gca,'yticklabel',num2str(get(gca,'ytick')','%.1f'))
yyaxis right 
q2 = bar(OrderBars, aVTL_Normed_BARD_Bar,'FaceColor', [0.95 0.95 0.95]); 
   ylim ([-6, 6]) 
    yticks([-6.00 -5.50 -5.00 -4.50 -4.00 -3.50 -3.00 -2.50 -2.00 -1.50 -1.00 -0.50 0.00 0.50 1.00 1.50 2.00 2.50 3.00 3.50 4.00 4.50 5.00 5.50 6.00]);
   ylabel ('Normed difference from baseline aVTL (cm)')
   xlabel ('Sound Type')
   legend ([q1(1) q2(2)], 'Normed F0 Change', 'Normed aVTL Change','location', 'southeast')
ax = gca;
set(ax, 'XTickLabel', {'BARD1' 'BARD9' 'BARD10' 'BARD17'})
xtickangle(45)
set(ax,'yticklabel',num2str(get(gca,'ytick')','%.1f'))
set (ax, 'FontSize', 8);
 ax.XAxis.Color = 'k';
 lgd = legend('show')
 lgd.FontSize = 4;
 legend('boxoff');
hold off

%% Subplot 3:
%Creates a scatterplot for BEAD and BARD, with Semitone change & Normed aVTL
subplot (2, 2, 3)
scatter(Semitone_Change_BEAD, aVTL_Normed_BEAD, 'k') %How to change the axes so that (0,0) is at the origin?
xlabel ('Normed change from baseline F0 (Semitones)')
xlim ([-5.00, 5.00])
xticks([-5.00 -4.00 -3.00 -2.00 -1.00 0.00 1.00 2.00 3.00 4.00 5.00])
ylabel ('Normed change from baseline aVTL (cm)')
ylim ([-5.00, 5.00]) 
yticks ([-5.00 -4.00 -3.00 -2.00 -1.00 0.00 1.00 2.00 3.00 4.00 5.00])

ax = gca;
set (ax, 'FontSize', 8);
ax.XAxis.Color = 'k';
ax.YAxis.Color = 'k';
hold on
scatter(Semitone_Change_BEAD(1), aVTL_Normed_BEAD(1), 'r', 'Filled');
scatter(Semitone_Change_BEAD(2), aVTL_Normed_BEAD(2), 'k', 'Filled');
scatter(Semitone_Change_BEAD(3), aVTL_Normed_BEAD(3), 'g', 'Filled');
scatter(Semitone_Change_BEAD(4), aVTL_Normed_BEAD(4), 'c', 'Filled');
scatter(Semitone_Change_BEAD(5), aVTL_Normed_BEAD(5), 'm', 'Filled');
legend('BEAD', '1', '5', '9', '10', '17', 'location', 'eastoutside');
hold off

%% Subplot 4:
subplot (2, 2, 4)
scatter(Semitone_Change_BARD, aVTL_Normed_BARD, 'k')
xlabel ('Normed change from baseline F0 (Semitones)')
xlim ([-5, 5])
xticks([-5 -4 -3 -2 -1 0 1 2 3 4 5])
ylabel ('Normed change from baseline aVTL(cm)')
ylim ([-5, 5]) 
yticks ([-5 -4 -3 -2 -1 0 1 2 3 4 5])
ax = gca;
set (ax, 'FontSize', 8);
ax.XAxis.Color = 'k';
ax.YAxis.Color = 'k';
hold on
scatter(Semitone_Change_BARD(1), aVTL_Normed_BARD(1), 'r', 'Filled');
scatter(Semitone_Change_BARD(2), aVTL_Normed_BARD(2), 'k', 'Filled');
scatter(Semitone_Change_BARD(3), aVTL_Normed_BARD(3), 'g', 'Filled');
scatter(Semitone_Change_BARD(4), aVTL_Normed_BARD(4), 'c', 'Filled');
scatter(Semitone_Change_BARD(5), aVTL_Normed_BARD(5), 'm', 'Filled');
legend('BARD', '1', '5', '9', '10','17', 'location', 'eastoutside')
hold off
saveas(gcf, subs{j}, 'jpeg') %Saves the figure to a .jpg file


% for h = 1: length(subs)
% BEAD = cell (5, 1, h)
% BEAD(:, :, h) = {Sound_Type_List(1:9); M_F0(1:9); Mean_aVTL(1:9); Semitone_Change_BEAD; aVTL_Normed_BEAD}
% end

% BEAD{j}= {Sound_Type_List(1:9) M_F0(1:9) Mean_aVTL(1:9) Semitone_Change_BEAD aVTL_Normed_BEAD}
% BARD{j} = {Sound_Type_List(10:18) M_F0(10:18) Mean_aVTL(10:18) Semitone_Change_BARD aVTL_Normed_BARD}
% Sound{j} = {Sound_Type_List};



end






