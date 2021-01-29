
rm(list=ls())
options(scipen=1000)
#++++++++++++
# libs
#++++++++++++

library(scales)
library(dplyr)
library(ggplot2)

#++++++++++++
# function to calculate after-tax value of our investments, based on regular payments of a fixed amount + accruing interest annually 
#++++++++++++

investment_value_after_n_yrs = function(initial, # how much savings to start?
                                        annual_payments, # what will regular annual payments be
                                        percent_growth, # average growth rate
                                        yrs # no. of years
                                        ){
  # calc payments plus interest
  myrate = percent_growth/100
  if(percent_growth >0){
    payments_plus_interest = annual_payments*((1+myrate)^yrs-1)/myrate # just an online  
  } else {
    payments_plus_interest = annual_payments * yrs
  }
  # correct interest for tax - 28% PIR (note payments were taxed prior to becoming payments)
  payments_only = annual_payments * yrs
  taxed_interest = (payments_plus_interest - payments_only)*0.72
  payments_plus_interest = payments_only + taxed_interest
  
  # add in initial savings
  return(payments_plus_interest + initial)
}
# investment_value_after_n_yrs(1000, 2400, 0, 16)

#++++++++++++
# function to calculate what goes into KS monthly, after tax
#++++++++++++

kiwisaver_monthly = function(salary, 
                             ks_rate # ks is a percent
                             ) {
  # employee contirubtion - no taxing reqd cos already taxed via PAYE
  (salary*(ks_rate/100) +
     # employer contribution - have to tax separately - assuming 33% rate
     salary*0.03*.67) / 12
} 

#++++++++++++
# function to calculate take-home pay per month from income
#++++++++++++

monthly_take_home_pay = function(salary, 
                                 kiwisaver # ks is a percent
                                 ){
  
  # paye
  payedf = data.frame(bins_up=c(14000, 48000, 70000, Inf), 
                      bins_lo=c(0, 14000, 48000, 70000), 
                      rate=c(.105, .175, .3, .33))
  payedf = payedf %>%
    mutate(greater=ifelse(salary>bins_up, 1, 0)) %>%
    mutate(amount=ifelse(salary>bins_up, bins_up-bins_lo, salary-bins_lo)) %>%
    mutate(paye = amount*rate) %>%
    # define where to stop sumation below
    mutate(include=lag(greater)) %>%
    mutate(include = ifelse(greater==1, 1, include))
    #also sep handling for when no pay is greater thatn bins_up
    if(salary<=payedf$bins_up[1]) payedf$include[1] = 1
  paye = sum(payedf$paye[payedf$include ==1])
  
  # kiwisaver
  ks = salary * kiwisaver*0.01
  
  # calc acc levy - 1.39% of gross pay on first 131K, but these nubmers change slightly each year
  leviableSalary = ifelse(salary < 131000, salary, 131000)
  acc = leviableSalary * 0.0139
  
  # calc monthly take home pay
  take = (salary - paye - acc - ks)/12
  return(take)
}
# monthly_take_home_pay(120000, 3)
