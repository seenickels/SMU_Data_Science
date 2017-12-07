GOPTIONS RESET=ALL;                                                                                                                     
ODS GRAPHICS ON;                                                                                                                        
*ods pdf file="C:\SMU\STATISTICS\SAS FILES\HOMEWORK_OUTPUT.pdf"; *Sets up output in PDF form;   
ods rtf file="C:\SMU\MSDS 6371 STATISTICS 1\SAS FILES\HOMEWORK_OUTPUT.rtf"; * Sets up output in Word. Can edit reports;                             
                                                                                                                                       
DATA ADULT_DATA;
INFILE 'C:\SMU\MSDS 6372 STATISTICS 2\AdultData.csv' dlm = ','; *firstobs= 1;
INPUT AGE WORKCLASS $ FNLWGT EDU $ EDUNUM MARSTAT $ OCCU $ RELSHP $ RACE $ SEX $ CGAIN CLOSS HrWk CNTRY $;
RUN;
DATA ADULT_DATA2;
SET ADULT_DATA;
FNLWGT= log(FNLWGT);
HrWk= sqrt(HrWk);
run;
proc corresp data=ADULT_DATA2 observed short mca;   *This ran. Burt Table created
      title2 'MCA Burt Table';
      ods select burt;
      tables WORKCLASS EDU MARSTAT OCCU RELSHP RACE SEX CNTRY;
   run;
proc corresp mca observed data=ADULT_DATA2 PLOTS(FLIP)=(ALL) print=Both binary outc=Coor outf=freq;
      *tables RACE OCCU SEX;
	  *tables MARSTAT WORKCLASS;
	  tables EDU RELSHP CNTRY;
   run;

%PLOTIT(DATA=Coor,DATATYPE=MCA, HREF=0, VREF=0,
         PLOTVARS=Dim1 Dim2, COLOR=black); 
*%PLOTIT(DATA=freq,DATATYPE=MCA, HREF=0, VREF=0,
*         PLOTVARS=Dim1 Dim2, COLOR=black); 
 *  ods graphics off;
PROC PRINT DATA=ADULT_DATA (obs=50) NOOBS;  * NOOBS; 
VAR AGE WORKCLASS FNLWGT EDU EDUNUM MARSTAT OCCU RELSHP RACE SEX CGAIN CLOSS HrWk CNTRY;
TITLE1 'STATS 6372 PROJECT 3';  
TITLE2 'ADULT INCOME';
run;
PROC MEANS DATA=ADULT_DATA maxdec=2 mean std min max var median;  *PROC MEANS COMMAND.;
CLASS WORKCLASS;	
VAR AGE;
VAR FNLWGT; 
VAR CGAIN;
VAR CLOSS;
VAR HrWk;
VAR EDUNUM;
TITLE1 'STATS 6372 PROJECT 3';  
TITLE2 'ADULT INCOME';
RUN;
PROC UNIVARIATE DATA=ADULT_DATA2 cibasic alpha=0.05; *NOPRINT;   *PROC UNIVARIATE COMMAND.;
*CLASS LEADX;				*DECLARES "LEADX" TO BE THE VARIABLE IN THE DATASET.;
*CLASS RCYR;
*CLASS WORKCLASS;	
VAR AGE FNLWGT CGAIN CLOSS HrWk;
HISTOGRAM AGE FNLWGT CGAIN CLOSS HrWk / normal;    *CREATES A HISTOGRAM.;
QQPLOT AGE FNLWGT CGAIN CLOSS HrWk;;				*CREATES A QQPLOT.;
TITLE1 'STATS 6372 PROJECT 3';  
TITLE2 'XXXXXXX';
RUN;
PROC FACTOR DATA = ADULT_DATA2 CORR SCREE RESIDUALS METHOD = principal MINEIGEN=5;
VAR AGE FNLWGT CGAIN CLOSS HrWk EDUNUM;
RUN;QUIT;
PROC PRINCOMP DATA = ADULT_DATA2 N=10 STD  plots=all OUTSTAT = PRIN_COMPS OUT = PRINS; *plots = (Matrix PatternProfile) COV;
*Do not include the response variable in the analysis as it will get mixed into the results and complicate things. ;
VAR AGE FNLWGT CGAIN CLOSS HrWk EDUNUM;;  *Principle Components are output to datafile called PRINS for PROC REG below
RUN;QUIT;
ods rtf close;

PROC FORMAT;
Value WORKCLASS 1 = Private 2 = Fed-Gov 3 = State_Gov 4 = Local-Gov 5 = No-Work 6 = 7 = 8 =;
Value EDU 1 = BS 2 = MS 3 = PhD 4 = HS 5 = 6 = 7 = 8 = 9 = 10 = 11 = 12 = 13 = 14 =;
Value MARSTAT 1 = Married-civ-Spouse 2 = Divorced 3 = Never-Married 4 = Separated 5 = Widowed 6 = Married-Spouse-Absent 7 = Married-AF-Spouse;
Value OCCU 1 = 2 = 3 = 4 = 5 = 6 = 7 = 8 = 9 = 10 = 11 = 12 = 13 = 14 =;
Value RELSHP 1 = Wife 2 = Own-Child 3 = Husband 4 = Not-in-Family 5 = Other-Relative 6 = Unmarried ;
Value RACE 1 = White 2 = API 3 = AIE 4 = Other 5 = Black;
Value SEX 1 = MALE 2 = FEMALE;
run;
DATA ADULT_DATA2;
missing a;
input(AGE WORKCLASS $ FNLWGT EDU $ EDUNUM MARSTAT $ OCCU $ RELSHP $ RACE $ SEX $ CGAIN CLOSS HrWk CNTRY $)(1.)@@;
* Check for End of Line. Not sure how all this works yet.
   if n(of AGE -- Country $) eq 0 then do; input; return; end;
   *marital = 2 * (kids le 0) + marital;
   format AGE AGE. WORKCLASS WORKCLASS. FNLWGT FNLWGT. EDU EDU. EDUNUM EDUNUM. MARSTAT MARSTAT.
		  RELSHP RELSHP. RACE RACE. SEX SEX. CGAIN CGAIN. CLOSS CLOSS. HrWk HrWk. CNTRY CNTRY.;
   output;
   datalines;

PROC SORT DATA = ADULT_DATA OUT=sortedEDUNUM;
    BY EDUNUM;
run; quit;
*PROC PRINT DATA = sortedRCYR;
*    VAR YR RCYR CAUT RACELENGTH AVG_SPEED NUMCARS LEADX WinTime ;
*    TITLE1 'SORTED BY RACE NUMBER and LEAD LAPS';
*    TITLE2 'XXXXX';
*run;
*PROC PRINT DATA = sortedTYPE;
*    VAR YR TYPE CAUT RACE LENGTH NUMCARS RCYR LEADX AVG_SPEED;
*    TITLE1 'SORTED BY RACE NUMBER and LEAD LAPS';
*    TITLE2 'XXXXX';
*run;

PROC UNIVARIATE DATA=ADULT_DATA cibasic alpha=0.05; *NOPRINT;   *PROC UNIVARIATE COMMAND.;
*CLASS LEADX;				*DECLARES "LEADX" TO BE THE VARIABLE IN THE DATASET.;
*CLASS RCYR;
*CLASS WORKCLASS;	
VAR AGE FNLWGT CGAIN CLOSS HrWk;
HISTOGRAM AGE FNLWGT CGAIN CLOSS HrWk / normal;    *CREATES A HISTOGRAM.;
QQPLOT AGE FNLWGT CGAIN CLOSS HrWk;;				*CREATES A QQPLOT.;
TITLE1 'STATS 6372 PROJECT 2';  
TITLE2 'NASCAR ANALYSIS-NO MOD';
RUN;
PROC BOXPLOT DATA = sortedEDUNUM;
PLOT AGE * EDUNUM;  */ BOXCONNECT = MEAN; *  (NumCars CPIU SPEAR KEND RACELENGTH)*LEADX / BOXCONNECT=MEAN;
RUN;QUIT;

PROC ANOVA DATA= ADULT_DATA2;
CLASS RACE;
MODEL AGE FNLWGT CGAIN CLOSS HrWk EDUNUM = RACE;
*MEANS RACE/ CLDIFF; *TUKEY;
RUN; QUIT;
PROC SGSCATTER DATA=ADULT_DATA2;
PLOT AGE * HrWk;
PLOT AGE*EDUNUM;
TITLE1 'STATS 6372 PROJECT 3';  
TITLE2 'ADULT INCOME';
TITLE3 'SCATTER PLOTS';
RUN;

*%plotit(data=ADULT_DATA, labelvar= TYPE, 
*          plotvars= CAUT RACELENGTH LENGTH AVG_SPEED, color=black, colors=red);
PROC PLS DATA = ADULT_DATA2 DETAILS METHOD = PCR NFAC = 6 CV=1 CVTEST(STAT=PRESS) ; *try cv=split validation;
MODEL sqrtLEADX = RACELENGTH AVG_SPEED LENGTH NumCars sqrtCAUT TYPE;
RUN; QUIT;
*PROC GPLOT DATA=PRINS;
*PLOT PRIN1*PRIN2 = 1;
*RUN; *QUIT;
*%plotit(data=ADULT_DATA, datatype=mdpref 2);
                      
PROC GLM DATA = ADULT_DATA PLOTS = DIAGNOSTICS RESIDUALS ALPHA =0.05; *FULL MODEL;
*CLASS TYPE;
MODEL sqrtLEADX = NumCars LENGTH RACELENGTH AVG_SPEED TYPE sqrtCAUT/ SOLUTION;
TITLE1 'STATS 6372 PROJECT 3';  
TITLE2 'ADULT INCOME';
RUN;QUIT;
PROC REG DATA=PRINS;   *PRINCIPLE COMPONENTS IN THE REGRESSION;
*MODEL sqrtLEADX = PRIN1-PRIN6;
*MODEL sqrtLEADX = PRIN1-PRIN4;
*MODEL sqrtLEADX = PRIN1-PRIN4
     / VIF  PARTIAL ; *STB CLB TOL COLLIN INFLUENCE;
MODEL sqrtLEADX = PRIN1-PRIN4
    /STB CLB TOL VIF COLLIN PARTIAL INFLUENCE SCORR1 SCORR2 ACOV HCC R CORRB;
	 output out=PrinResids (keep= PRIN1 PRIN2 PRIN3 PRIN4 y_hat y_res r lev cd dffit dfbeta)
	 rstudent = r h = lev cookd=cd dffits = dffit p=Y_hat r=Y_res; 
TITLE1 'STATS 6372 PROJECT 3';  
TITLE2 'ADULT INCOME';
TITLE3 'XXXXX';
RUN;QUIT;
PROC PRINT DATA=PrinResids;
  where cd > (4/214);
  var Type Ri cd;
TITLE1 'STATS 6372 PROJECT 3';  
TITLE2 'ADULT INCOME';
TITLE3 'XXXXXXXXXXXX';
run;
PROC REG DATA=ADULT_DATA;   *FULL MODEL   LEFT OFF HERE;
MODEL sqrtLEADX = NumCars LENGTH RACELENGTH AVG_SPEED TYPE sqrtCAUT
     / VIF  PARTIAL ; *STB CLB TOL COLLIN INFLUENCE;

TITLE1 'STATS 6372 PROJECT 3';  
TITLE2 'ADULT INCOME';
TITLE3 'Full Model';
RUN;QUIT;
PROC CORR DATA=ADULT_DATA NOMISS PEARSON SPEARMAN PLOTS=MATRIX(HISTOGRAM);  *FULL MODEL;
*VAR LEADX NUM YR RCYR NumCars Purse CPIU SPEAR KEND LENGTH LAPWIN TYPE CAUT WinTime Road Oval;
VAR sqrtLEADX NumCars LENGTH RACELENGTH AVG_SPEED TYPE sqrtCAUT;

TITLE1 'STATS 6372 PROJECT 3';  
TITLE2 'ADULT INCOME';

RUN;





PROC CLUSTER DATA=ADULT_DATA METHOD=AVERAGE OUTTREE=TreeData; 
VAR NumCars RACELENGTH LENGTH TYPE CAUT AVG_SPEED;
PROC TREE DATA=TreeData; 
RUN; 
PROC PRINT DATA=ADULT_DATA; 
VAR Road CAUT TreeData; 
RUN;

PROC SGSCATTER DATA = ADULT_DATA;    *FULL MODEL RAW DATA;
*MATRIX LEADX TIME CARS CAUTION LENGTH LEADLAPS RY PURSE / DIAGONAL=(HISTOGRAM);
*MATRIX LEADX Road Oval LENGTH CAUTION CARS LEADLAPS TIME / DIAGONAL=(HISTOGRAM);
COMPARE Y = (LEADX RACELENGTH NUMCARS)
		X = (CAUT AVG_SPEED LENGTH)
		/ REG ELLIPSE=(TYPE=MEAN) SPACING = 4;

TITLE1 'STATS 6372 PROJECT 3';  
TITLE2 'ADULT INCOME';
TITLE3 'RAW DATA - FULL';
RUN;
PROC GLMSELECT DATA=ADULT_DATA;   *FULL MODEL;

MODEL LEADX = RCYR NumCars SPEAR KEND RACELENGTH LENGTH TYPE CAUT
    / SELECTION=STEPWISE (STOP=CV) CVMETHOD=RANDOM(5) STATS=ADJRSQ;
*MODEL LEADX = D1 D2 TIME RY PURSE CARS CAUTION LENGTH LEADLAPS
*	/ SELECTION=BACKWARD (STOP=CV) CVMETHOD=RANDOM(5) STATS=ADJRSQ;
*MODEL LEADX = RCYR NumCars Purse SPEAR KEND RACELENGTH LENGTH TYPE CAUT
    / SELECTION=FORWARD (STOP=CV) CVMETHOD=RANDOM(5) STATS=ADJRSQ;
TITLE1 'STATS 6372 PROJECT 3';  
TITLE2 'ADULT INCOME';
TITLE2 'AUTO SELECT FUNCTION - FULL';
RUN;QUIT;
PROC GLMSELECT DATA=ADULT_DATA;   *REDUCED MODEL;

MODEL LEADX = D1 D2 LENGTH CAUTION
    / SELECTION=STEPWISE (STOP=CV) CVMETHOD=RANDOM(5) STATS=ADJRSQ;
*MODEL LEADX = Road Oval LENGTH CAUTION TIME
*	/ SELECTION=BACKWARD (STOP=CV) CVMETHOD=RANDOM(5) STATS=ADJRSQ;
*MODEL LEADX = Road Oval LENGTH CAUTION TIME
*    / SELECTION=FORWARD (STOP=CV) CVMETHOD=RANDOM(5) STATS=ADJRSQ;
TITLE1 'STATS 6372 PROJECT 3';  
TITLE2 'ADULT INCOME';
TITLE2 'AUTO SELECT FUNCTION - REDUCED';
RUN;QUIT;





*//////////////////////////////////////////////////////////////////////////////////////////////////////////////////;
*/////////////////////////////////////////////////////////////////////////////////////////////////////////////////;

*ODS RTF CLOSE;

DATA POLLUTION2;                                   *The name of the data set being studied goes here.;                                         
SET POLLUTION;
LOGNONWHITE = log(NONWHITE);                                                                                               
LOGSO2 = log(SO2);
LOGNOX = log(NOX);
LOGHC = log(HC);
LOGHUM= LOG(HUMIDITY);
LOGPOOR = log(POOR);
AIR = LOGNOX*LOGHC;
*IF _n_ = 8 THEN DELETE;
*IF _n_ = 19 THEN DELETE;
*IF _n_ = 26 THEN DELETE;
*IF _n_ = 13 THEN DELETE;
*IF _n_ = 20 THEN DELETE;
*IF _n_ = 58 THEN DELETE;
RUN; QUIT;
PROC SGSCATTER DATA = POLLUTION2;     *FULL MODEL;
MATRIX MORTALITY PRECIP HUMIDITY JANTEMP JULYTEMP OVER65 HOUSE EDUC SOUND DENSITY LOGNONWHITE WHITECOL LOGPOOR LOGHC LOGNOX LOGSO2 / DIAGONAL=(HISTOGRAM);
RUN;

PROC CORR DATA=POLLUTION2 NOMISS BEST=16 PEARSON SPEARMAN PLOTS=MATRIX(HISTOGRAM);  *FULL MODEL;
VAR MORTALITY PRECIP HUMIDITY JANTEMP JULYTEMP OVER65 HOUSE EDUC SOUND DENSITY NONWHITE WHITECOL POOR LOGSO2 LOGHC LOGNOX;
TITLE1 'STATS 6371 HW#12';  
TITLE2 'POLLUTION MLR ANALYSIS';
RUN;
ods rtf file="C:\SMU\STATISTICS\SAS FILES\HOMEWORK_OUTPUT.rtf"; * Sets up output in Word. Can edit reports;               
PROC CORR DATA=POLLUTION2 NOMISS BEST=4 PEARSON SPEARMAN PLOTS=MATRIX(HISTOGRAM); *REDUCED MODEL;
VAR MORTALITY PRECIP LOGNONWHITE LOGSO2;
TITLE1 'STATS 6371 HW#12';  
TITLE2 'POLLUTION MLR ANALYSIS';
TITLE3 'REDUCED MODEL';
RUN;
ods rtf close;
*********************************************************;
PROC SGSCATTER DATA=POLLUTION2;
PLOT MORTALITY*LOGSO2;
TITLE1 'STATS 6371 HW#12';  
TITLE2 'POLLUTION MLR ANALYSIS';
RUN;
PROC SGSCATTER DATA=POLLUTION;
PLOT MORTALITY*SO2;
TITLE1 'STATS 6371 HW#12';  
TITLE2 'POLLUTION MLR ANALYSIS';
RUN;

ods rtf file="C:\SMU\STATISTICS\SAS FILES\HOMEWORK_OUTPUT.rtf"; * Sets up output in Word. Can edit reports;                             


***************************************************************************************************************;
***************************************************************************************************************;

DATA POINTREMOVE;                                   *The name of the data set being studied goes here.;                                         
SET POLLUTION;
IF _n_ = 8 THEN DELETE;
IF _n_ = 19 THEN DELETE;
IF _n_ = 26 THEN DELETE;
IF _n_ = 13 THEN DELETE;
IF _n_ = 20 THEN DELETE;
IF _n_ = 58 THEN DELETE;
RUN; QUIT;
PROC PRINT DATA=POLLUTION;
TITLE1 'STATS 6371 HW#12';  
TITLE2 'POLLUTION MLR ANALYSIS';
run;
PROC REG DATA=POLLUTION2 PLOTS(LABEL)=(COOKSD);   *FULL MODEL   LEFT OFF HERE;
ID LOGSO2;
MODEL MORTALITY = PRECIP EDUC LOGNONWHITE LOGSO2 LOGHC
     / TOL VIF COLLIN PARTIAL;

TITLE1 'STATS 6371 HW#12';  
TITLE2 'POLLUTION MLR ANALYSIS';
RUN;QUIT;

PROC CORR DATA=POLLUTION2 BEST = 9 NOMISS PEARSON SPEARMAN PLOTS=MATRIX(HISTOGRAM);  *FULL MODEL     LEFT OFF HERE;
VAR MORTALITY PRECIP EDUC LOGNONWHITE LOGSO2 LOGHC;
TITLE1 'STATS 6371 HW#12';  
TITLE2 'POLLUTION MLR ANALYSIS';
RUN;
*NOT USING THESE BECAUSE LOG TRANSFORMED DATA IS BETTER
PROC CORR DATA=POINTREMOVE BEST = 6 NOMISS PEARSON SPEARMAN PLOTS=MATRIX(HISTOGRAM);  *FULL MODEL;
VAR MORTALITY PRECIP HUMIDITY JANTEMP JULYTEMP OVER65 HOUSE EDUC SOUND DENSITY NONWHITE WHITECOL POOR HC NOX SO2;
TITLE1 'STATS 6371 HW#12';  
TITLE2 'POLLUTION MLR ANALYSIS';
RUN;
*NOT USING THESE BECAUSE LOG TRANSFORMED DATA IS BETTER;
PROC REG DATA=POINTREMOVE PLOTS(LABEL)=(COOKSD);   *FULL MODEL;
*PROC REG DATA=POLLUTION PLOTS(LABEL)=(COOKSD);   *FULL MODEL;
ID SO2;
MODEL MORTALITY = PRECIP HUMIDITY JANTEMP JULYTEMP OVER65 HOUSE EDUC SOUND DENSITY NONWHITE WHITECOL POOR HC NOX SO2
	/ TOL VIF COLLIN PARTIAL;

TITLE1 'STATS 6371 HW#12';  
TITLE2 'POLLUTION MLR ANALYSIS';
RUN;QUIT;






***************************************************************************************************************;
***************************************************************************************************************;




PROC REG DATA=POLLUTION2 PLOTS(LABEL)=(COOKSD);   *REDUCED MODEL;
ID MORTALITY;
MODEL MORTALITY = LOGNONWHITE LOGSO2 PRECIP  / TOL VIF COLLIN clb;

TITLE1 'STATS 6371 HW#12';  
TITLE2 'POLLUTION MLR ANALYSIS';
TITLE3 'REDUCED MODEL';
RUN;QUIT;
ODS RTF CLOSE;

PROC REG DATA=POLLUTION2 PLOTS(LABEL)=(COOKSD);   *FULL MODEL;
ID LOGSO2;
MODEL MORTALITY = LOGHC LOGNOX LOGSO2 / TOL VIF COLLIN;

TITLE1 'STATS 6371 HW#12';  
TITLE2 'POLLUTION MLR ANALYSIS';
RUN;QUIT;

PROC REG DATA=POLLUTION; * PLOTS(LABEL)=(COOKSD); * COOKSD CP QQ RSTUDENTBYLEVERAGE RIDGE(UNPACK));  
*ID SO2 EDUC PRECIP NONWHITE;				    *REDUCED MODEL;
MODEL MORTALITY = PRECIP NONWHITE SO2; *EDUC; *TOL VIF COLLIN INFLUENCE PARTIAL;

TITLE1 'STATS 6371 HW#12';  
TITLE2 'POLLUTION MLR ANALYSIS';
RUN;QUIT;
