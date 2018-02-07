
 clear         
 
/**********************************************************************/
/*  SECTION 1: Install Freduse  			
    Notes: Most database can be access directely trought software*/ 
/**********************************************************************/

findit freduse
 
/*------------------------- 
	To Do:
		 1.select "st010"  
		 2."click here to install"
		 3. close the window   
-------------------------*/ 
/*------------------------------------ End of SECTION 1 ------------------------------------*/



/**********************************************************************/
/*  SECTION 2:   			
    Notes: */
/**********************************************************************/



/*------------------------------------ End of SECTION 2 ------------------------------------*/


/* [> You have to add your path between " " or delete this line if you don't want to use it <] */ 
/* [> For instance I use : local dir "/Users/Alais/PhD/TA/Macro_2/Session_1" <] */ 

 local dir ""


 freduse GDPC1

 generate time = q(1947q1) + _n -1
 format time %tq
 tsset time

 twoway tsline GDPC1

/* Infinite possibility to customise it, try it <] */
 twoway tsline GDPC1, title(United States : Real Gross Domestic Product) ytitle(Billions of Chained 2009 $) xtitle("") lcolor(red) ttext( 15000 1970q1 "Seasonlly Adjusted Annual Rate" ) ylab(, nogrid)

gen ln_gdp = ln(GDPC1*1000) if time >= tq(1970q1) & time < tq(2010q1)

tsfilter hp gdp_cycle = ln_gdp, trend(gdp_trend) smooth(1600)

gen Cyclical_Component = gdp_cycle  * 100

label var ln_gdp "log real GDP"
label var gdp_trend "Trend"

twoway tsline Cyclical_Component if time >= tq(1970q1) & time < tq(2010q1), title(Cyclical Component) ytitle(percentage dev from trend) xtitle("") ylabel(-5(2)5) yline(0)

twoway tsline ln_gdp gdp_trend  if time >= tq(1970q1) & time < tq(2010q1), title(Trend Component) ytitle(percentage dev from trend) xtitle("") 


/**********************************************************************/
/*  SECTION 3: Play with lambda  			
    Notes: */
/**********************************************************************/


tsfilter hp gdp_cycle_100 =ln_gdp, trend(gdp_trend_100) smooth(100)
tsfilter hp gdp_cycle_5000 =ln_gdp, trend(gdp_trend_5000) smooth(5000)


gen Cyclical_Component_100 = gdp_cycle_100  * 100
gen Cyclical_Component_5000 = gdp_cycle_5000  * 100



label var Cyclical_Component "lambda = 1600"
label var Cyclical_Component_100 "lambda = 100"
label var Cyclical_Component_5000 "lambda = 5000"


label var gdp_trend "lambda = 1600"
label var gdp_trend_5000 "lambda = 5000"
label var gdp_trend_100 "lambda =  100"

twoway tsline   gdp_trend  gdp_trend_5000 gdp_trend_100 if time >= tq(1980q1) & time < tq(1990q1), title(Trend) 
twoway tsline   Cyclical_Component  Cyclical_Component_5000 Cyclical_Component_100 if time >= tq(1970q1) & time < tq(2010q1), title("Cyclical Component") 


 save "`dir'/GDP.dta"

/*------------------------------------ End of SECTION 3 ------------------------------------*/


/**********************************************************************/
/*  SECTION 4: Procycal variable
/**********************************************************************/ */

/* [> You must start with an empty dataset to use freduse <] */ 

clear

/* [> Download  : Real Personal Consumption Expenditures  <] */ 

freduse PCECC96


 generate time = q(1947q1) + _n -1
 format time %tq
 tsset time


gen ln_consumption = ln(PCECC96*1000) if time >= tq(1970q1) & time < tq(2010q1)
tsfilter hp ln_consumption_cycle = ln_consumption, trend(ln_consumption_trend) smooth(1600)
gen Consumption_cycle = ln_consumption_cycle  * 100

/* [> We want to compare the cyclical component of the output and of the total consumption <] */ 

merge 1:1 time using "`dir'/GDP.dta"

rename Cyclical_Component GDP_cycle


twoway tsline Consumption_cycle GDP_cycle if time >= tq(1970q1) & time < tq(2010q1), title(Correlation) ytitle(percentage dev from trend) xtitle("") yline(0)

correlate  Consumption_cycle GDP_cycle 
correlate  L.Consumption_cycle GDP_cycle 
correlate  F.Consumption_cycle GDP_cycle 


/*------------------------------------ End of SECTION 4 ------------------------------------*/


/**********************************************************************/
/*  SECTION 5 : The  Baxter-King time-series filter  			
/**********************************************************************/ */

 tsfilter bk Consumption_cycle_bk GDP_cycle_bk = ln_consumption GDP_cycle

 tsfilter bk Consumption_cycle_bk  = ln_consumption 

label var GDP_cycle_bk "BK_filter" 
label var GDP_cycle "HP_filter" 

twoway tsline GDP_cycle_bk GDP_cycle if time >= tq(1970q1) & time < tq(2010q1), title(HP and BK filter (Output)) ytitle(percentage dev from trend) xtitle("") yline(0)
/*------------------------------------ End of SECTION number ------------------------------------*/





