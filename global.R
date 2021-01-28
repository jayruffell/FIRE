rm(list=ls())

# libs
library(scales)
library(dplyr)

# function to calculate take-home pay per month from income
monthly_take_home_pay = function(salary, kiwisaver){
  
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
