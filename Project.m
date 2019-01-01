clear all, close all;
% Software Engineering
% University of Sankt Gallen

%% Load the data 
filename='DATA.xlsx'
[num,txt]=xlsread(filename);

name      = txt(2:length(txt),1:2); %name and abbreviation of stocks
Index     = num(:,1);               %index for indentifiying stock names when ranked 
P         = num(:,4);               %stock price
PE_ratio  = num(:,5);               %price earnings ratio
ROA       = num(:,6);               %return on asset
ROE       = num(:,7);               %return on equity
PB_ratio  = num(:,8);               %price book ratio
G         = num(:,9);               %5 year prediction of growth rate 

%% Calculating a portfolio from the Magic Formula (suggested from Joel Greenblatt)
%1.Calculation of earnings yield (reciprocal of P/E ratio)

for i=1:length(PE_ratio)
    Ey(i,1)=1/PE_ratio(i,1);   %earnings yield 
end 

A=[Index , Ey];  %new matrix containing the index and the earnings yield

%1.1 Ranking the earnings yield, the higher the earnings yield the better
A_sorted=sortrows(A,2, 'descend');

rank_vector=[1:100]';  %vector used for ranking

Rank_A=[A_sorted, rank_vector]; 
%creates new vector, containing index, the sorted earnings yield and a rank
%for each earnings yield. The lagrest earnings yield gets the best rank

%2. Use return on capital for second ranking
%   Here: We use the Return on assets (ROA) to rank the companies
%         The lager the ROA the better

B=[Index, ROA];   %combine index with ROA for indentification 
B_sorted = sortrows (B,2, 'descend');   %sort B from highest number to lowest 
Rank_B=[B_sorted, rank_vector];           %combine sorted matrix with rank matrix 


%3. Combine the two seperate rankings to get final ranking 
%   use best 30 ranked stock for portfolio desicions

%first sort Rank_A and Rank_B according to the index
Rank_A = sortrows (Rank_A,1);
Rank_B = sortrows (Rank_B,1);

%add the ranking of Rank_A and Rank_B
Rank_final=[Rank_A(:,1), (Rank_A(:,3)+ Rank_B(:,3))];

%Sort Rank_final to get the best ranked portfolio
Rank_final=sortrows(Rank_final,2);

%The Magic Formula suggests the following portofolio
Rank_final=Rank_final(1:30,1)   %Displays only the index 

%% Using the formula from Banjamin Graham to get a portfolio of 30 stocks
%  Formula: Value expected = EPS*(8,5+2*G)
%           RIC(relative intrinsic value)=V/P

%1.Calculate Earning per share (EPS)
for i=1:length(P)
    EPS(i,1)=Ey(i,1)*P(i,1);
end 

%2. Calculate the value expected from the growth formula
for i=1:length(P)
    V(i,1)=EPS(i,1)*(8.5+2*G(i,1));
end 

%3. Calculate the relative intrinsic value
for i=1:length(P)
    RIV(i,1)=V(i,1)/P(i,1);
end 

%4. Do the ranking
C=[Index , RIV];  %new matrix containing the index and the RIV

C_sorted=sortrows(C,2, 'descend');%sorting the values from highest number to lowest

Rank_C=[C_sorted, rank_vector]; 

Rank_final_BG=C_sorted(1:30,1)  %Displays index of chosen portfolio 

%% Other method to choose a portfolio of 30 stocks (ERP-method)
% Based on Earnings yield, the ROE and the Price to Book ratio.
% Same procedure as before, rank each seperatly, then combine ranks and
% choose best ranked ones

%1.Earnings yield as before: use Rank_A

%2. Rank return on equity (ROE)
D=[Index, ROE];   %combine index with ROE for indentification 
D_sorted = sortrows (D,2, 'descend');     %sort D from highest number to lowest 
Rank_D=[D_sorted, rank_vector];           %combine sorted matrix with rank matrix 

Rank_D=sortrows (Rank_D,1); %sort according to index

%3. Price to Book ratio
E=[Index, PB_ratio];   %combine index with Price for indentification 
E_sorted = sortrows (E,2);     %sort E from highest number to lowest 
Rank_E=[D_sorted, rank_vector];           %combine sorted matrix with rank matrix 

Rank_E=sortrows (Rank_E,1); %sort according to index

%4. Combine rankings to get best portfolio
Rank_final_ERP=[Rank_A(:,1), (Rank_A(:,3)+ Rank_D(:,3)+Rank_E(:,3))];

%Sort Rank_final_ERP
Rank_final_ERP=sortrows(Rank_final_ERP,2);

%The ERP-method suggests the following portofolio
Rank_final_ERP=Rank_final_ERP(1:30,1)


%% Plotting the historical values for the first choice of each suggested portfolio 
% Load the data for STX
filename='STX.xlsx'
[num, txt]=xlsread(filename);
Vol_STX   = num(:,6);
Close_STX = num(:,4);

% Load the data for URI
filename='URI.xlsx'
[num, txt]=xlsread(filename);
Vol_URI   = num(:,6);
Close_URI = num(:,4);


% Load the data for CAR
filename='CAR.xlsx'
[num, txt]=xlsread(filename);
Vol_CAR   = num(:,6);
Close_CAR = num(:,4);

%Plotting the Volume
figure(1)
plot(Vol_STX)
hold on 
plot(Vol_URI)
hold on 
plot(Vol_CAR)
legend('STX','URI','CAR')
ylabel('Volume')
xlabel('Year 2018')
title('Volume of top-ranked companies')
xlim([1 251]);   %setting the x-asis as time 
xticks([1 40 80 120 160 200 240]);
xticklabels({'02.01','28.02','26.04','22.06','20.08','15.10', '13.12'});


%plotting the Closing Price 
figure(2)
plot(Close_STX)
hold on 
plot(Close_URI)
hold on 
plot(Close_CAR)
legend('STX','URI','CAR')
ylabel('Closing price')
xlabel('Year 2018')
title('Closing price of top-ranked companies')
xlim([1 251]);
xticks([1 40 80 120 160 200 240]);
xticklabels({'02.01','28.02','26.04','22.06','20.08','15.10', '13.12'});
