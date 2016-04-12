%*************************************************************************
% Project_Results.m
%
%  Program Description: Extracts head acceleration from excel file,
%   Calculates the resultant acceleration from ax, ay and az, plots
%   the resultant vector and caluclates the peak acceleration for a 
%   2015 Honda CRV, 2015 Ford F150 and 2015 Toyota Corolla.
%
%   A 1 var note is for Toyota Corolla
%   A 2 var note is for Honda CR V
%   A 3 var note is for Ford F 150
%
%   Written by Kyle Braasch
%              3/29/2016
%
%*************************************************************************
%
% Clear data
%
clc
clear variables
close all
%
% Data
%
data1=xlsread('toyota_corolla_data.xls'); % Gets matrix of corolla data
data2=xlsread('honda_cr_v_data.xls'); % gets matrix of CR V data
data3=xlsread('ford_f_150_data'); % gets matrix of F 150 data
[rows,columns]=size(data1); % sets var rows/columns to # rows/colums in matrix
%
% Calculations
%
for i=1:rows
    t_ms1(i)=1000*data1(i,1); % array of time in ms to plot vs g force Corolla
    t1(i)=data1(i,1); % array of time in s for later calculations Corolla
    ax1(i)=data1(i,2); % array of x dir acc for Corolla
    ay1(i)=data1(i,3); % array of y dir acc for Corolla
    az1(i)=data1(i,4); % array of z dir acc for Corolla
    a1(i)=sqrt(ax1(i)^2+ay1(i)^2+az1(i)^2); % calc for resultant acc Corola
    t_ms2(i)=1000*data2(i,1); % array of time in ms to plot vs g force CRV
    t2(i)=data2(i,1); % array of time in s for later calculations CRV
    ax2(i)=data2(i,2); % array of x dir acc for CRV
    ay2(i)=data2(i,3); % array of y dir acc for CRV
    az2(i)=data2(i,4); % array of z dir acc for CRV
    a2(i)=sqrt(ax2(i)^2+ay2(i)^2+az2(i)^2); % calc resultant acc CRV
    t_ms3(i)=1000*data3(i,1); % array of time in ms to plot vs g force F150
    t3(i)=data3(i,1); % array of time in s for later calculations F150
    ax3(i)=data3(i,2); % array of x dir acc for F150
    ay3(i)=data3(i,3); % array of y dir acc for F150
    az3(i)=data3(i,4); % array of z dir acc for F150
    a3(i)=sqrt(ax3(i)^2+ay3(i)^2+az3(i)^2); % calc resultant acc F150
    highest1=max(a1); % highest set to max acc in vector a Corolla
    highest2=max(a2); % highest set to max acc in vector a CRV
    highest3=max(a3); % highest set to max acc in vector a F150
end
%
% Plotting
%
subplot(3,1,1); % subplot 1
plot(t_ms1,a1,'k'); % plots resultant acceleration vs time (ms) Corolla
legend('2014 Toyota Corolla');
title('Resultant head acceleration for a frontal impact test');
xlabel('Time (ms)'); 
ylabel('Acceleration (g)');
subplot(3,1,2); % subplot 2
plot(t_ms2,a2,'k'); % plots resultant acceleration vs time (ms) CRV
legend('2015 Honda CR-V');
xlabel('Time (ms)');
ylabel('Acceleration (g)');
subplot(3,1,3); % subplot 3
plot(t_ms3,a3,'k'); % plots resultant acceleration vs time (ms) F150
legend('2016 Ford F-150');
xlabel('Time (ms)');
ylabel('Acceleration (g)');
%
% Printing Results
%
file=fopen('Peak_Acceleration.txt','wt');
fprintf(file,'Comparison of the peak resultant head acceleration experienced: \n');% prints data discription
fprintf(file,'Toyota Corolla: %5.2fg.\n',highest1); % prints results for Carolla
fprintf(file,'Honda CR V: %5.2fg.\n',highest2); % prints results for CR V
fprintf(file,'Ford F 150: %5.2fg.\n',highest3); % prints results for F 150
fclose(file);
%*************************************************************************
% Project1_Day2.m
%
%  Program Description: Calculate th HIC severity value for the data
%       collected from the Toyota Corolla, Honda CRV and Ford F150 crash
%       tests. The Hic is then plotted against the time window number and
%       the max HIC is printed to a file.
%
%   Written by Kyle Braasch
%              3/28/2016
%
%*************************************************************************
%
% Data
%
window=150; % window of integration is 150ms
start=1;  % start at t=0
count=1;
%
% Calculations
%
for i=start:1:rows-window % integrate from t=0 to max-window
    twin=t1(i+window)-t1(i); % will always be 150ms
    severitytot1=0; % resets severitytot for each window Corolla
    severitytot2=0; % resets severitytot for each window CRV
    severitytot3=0; % resets severitytot for each window F150
    for j=i:1:i+window-1 % goes from i to i+149, because trapezoidal, the last trapezoid ends at 149+1
        t_trap=t1(j+1)-t1(j); % will always be .1ms for intervals of trap integration
        severitysec1=(((a1(j)+a1(j+1))/2)*t_trap); % trap int for .1ms interval Corolla
        severitytot1=severitytot1+severitysec1; % accum integral for twin Corolla
        severitysec2=(((a2(j)+a2(j+1))/2)*t_trap); % trap int for .1ms interval CRV
        severitytot2=severitytot2+severitysec2; % accum integral for twin CRV
        severitysec3=(((a3(j)+a3(j+1))/2)*t_trap); % trap int for .1ms interval F150
        severitytot3=severitytot3+severitysec3; % accum integral for twin F150
    end
    severity1(count)=(((1/twin)*severitytot1)^2.5)*twin; % HIC calculation Corolla
    severity2(count)=(((1/twin)*severitytot2)^2.5)*twin; % HIC calculation CRV
    severity3(count)=(((1/twin)*severitytot3)^2.5)*twin; % HIC calculation F150
    winnum(count)=(i); % window number
    count=count+1; % counter
end
[max1,index1]=max(severity1); % sets max to max HIC and index to the index of the vector for Corolla
[max2,index2]=max(severity2); % sets max to max HIC and index to the index of the vector for CRV
[max3,index3]=max(severity3); % sets max to max HIC and index to the index of the vector for F150
%
% Plotting
%
subplot(3,1,1); % subplot 1
plot(winnum,severity1,'k',winnum(index1),max1,'k--o'); % plots HIC vs time window number Corolla
legend('2014 Toyota Corolla');
axis([0 3500 0 250]);
title('Variation in Severity for a Frontal Impact Test');
xlabel('Time Window Number'); 
ylabel('HIC');
subplot(3,1,2); % subplot 2
plot(winnum,severity2,'k',winnum(index2),max2,'k--o'); % plots HIC vs time window number CRV
legend('2015 Honda CR-V');
axis([0 3500 0 250]);
xlabel('Time Window Number');
ylabel('HIC');
subplot(3,1,3); % subplot 3
plot(winnum,severity3,'k',winnum(index3),max3,'k--o'); % plots HIC vs time window number F150
legend('2016 Ford F-150');
axis([0 3500 0 250]);
xlabel('Time Window Number');
ylabel('HIC');
%
% Printing Results
%
file2=fopen('HIC_Results.txt','wt');
fprintf(file,'Comparison of the calculated head injury criterion (HIC) values: \n');% prints data discription
fprintf(file,'Toyota Corolla: %5.2f.\n',max1); % prints results for Corolla
fprintf(file,'Honda CR V: %5.2f.\n',max2); % prints results for CRV
fprintf(file,'Ford F 150: %5.2f.\n',max3); % prints results for F150
fclose(file);