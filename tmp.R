
#_______________________________________________________________________

# params 
#_______________________________________________________________________

# h4('Income & expenses'), 
income_e = 80000
income_j = 120000
kiwisaver_current = 60000
stocks_inflation_rate = 4
expenses = 7000
# h4('House'),
homeloan = 560000
mortgage = 2900
mortgage_rate = 4
house_inflation_rate = 8
house_value = 1100000
# h4('Post-retirement'),
retirement_spend_rate = 85
pension = 2600
withdrawal_rate = 3
# new
age = 39
wage_inflation_rate = 2
inflation_rate = 2
life_expectancy = 100
income_post_ret_e = 40000
income_post_ret_j = 40000
yrs_worked_post_ret_e = 20
yrs_worked_post_ret_j = 20
pay_off_mortgage_in_ret = 'no'
yrs_til_mortage_paid_off = 25


# portfolio_volatility_paramter = ??? # TO DO

#_______________________________________________________________________

# functions (already in global.r)
#_______________________________________________________________________

monthly_take_home_pay
kiwisaver_monthly

# ----------------
# repeat below pre- and post- steps under differnt 'years til retirement' scenarios, then for given params find the 'yrs til ret' param where savings at death is smallest but still >0

# also chagne 'kiwisaver current' to 'investments current' in dash
# draw investment_growth_rate from distribution reflecting real numbers? cos not sure if normal dis is correct (esp for negative growth, which must be boudned at zero outcome vs infinite outcome). Do same for housing?
# based on drawing from dist, calc probability of running out of $
# gonna work with annual, not monthly, so change documentation to reflect. cos all interest rates - including home loan - are actual annualised
# currently not factoring in stock dividends vs capital gains, just lumping together as investments_inflation_rate
# update monthly_take_home_pay & kiwisaver_monthly functions to exclude KS if post-ret - currently doestn' matter except for employer contributions,  (cos KS coming out of salary goes into investments either way)
# convert yearly to monthly? more accurate, but also need to translate all rates to monthly version
# if investment value goes below zero, make zero (outside function)
# ----------------

# income, expenses, 

#++++++++++++++++
# Define function to update investment value each yr PRE retirement
#++++++++++++++++

update_investment_value_per_yr = function(
  income_e, # adjust for wage inflation outside function
  income_j,
  pension_per_mo, 
  investment_value, # * INITIALLY 'input$investments_current' [to update from input$kiwisaver_current] but then updates each yr
  investment_inflation_rate, # *draw from normal distribution outside function
  expenses_per_mo) {
  
  # update investment value based on inflation rate
  invest_plus_interest = investment_value * (1 + investment_inflation_rate/100)
  
  # calc take-home pay from income, subtract expenses, and add rest to investment. Then calc kiwisaver from income and add to investment, assuming it's pre-ret.
  invest_from_salary = 12*(monthly_take_home_pay(income_e, 3) + monthly_take_home_pay(income_j, 3) + pension_per_mo - expenses_per_mo)
  invest_from_kiwisaver = 12*(kiwisaver_monthly(income_e, 3) + kiwisaver_monthly(income_j, 3))
  
  # combine to give updated investment value
  return(invest_plus_interest + invest_from_salary + invest_from_kiwisaver)
}

# TESTING - postivive growth
update_investment_value_per_yr(income_e=70000,
                               income_j=120000,
                               pension=0,
                               investment_value=60000, # * INITIALLY 'input$investments_current' but then updates each yr
                               investment_inflation_rate=4, # *draw from normal distribution outside function
                               expenses_per_mo=2900)
# ************* UP TO HERE - NEED TO ADD IN OVER65 PARAM INTO FUNCTION *******************

#++++++++++++++++
# Define function to update house value each yr PRE retirement
#++++++++++++++++

update_investment_value_pre_ret = function(
  homeloan, # * INITIALLY 'input$homeloan' but then updates each yr
  mortgage,
  mortgage_rate, # *draw from normal distribution
  house_inflation_rate, # *draw from normal distribution
  house_value) { # * INITIALLY 'input$homeloan' but then updates each yr
  
  return(house_value)
} 
  
#++++++++++++++++
# Define function to update asset values each yr POST retirement
#++++++++++++++++

update_asset_values_post_ret = function(
# h4('Post-retirement'),
  retirement_spend_rate,
  pension,
  withdrawal_rate
) {
  return(asset_values)
}
  # new
  age = 39
  wage_inflation_rate = 2
  inflation_rate = 2
  life_expectancy = 100
  income_post_ret_e = 40000
  income_post_ret_j = 40000
  yrs_worked_post_ret_e = 20
  yrs_worked_post_ret_j = 20
  pay_off_mortgage_in_ret = 'no'
  yrs_til_mortage_paid_off = 25
  


# each month pre-retirement:
# - calc take home pay (after wage inflation)
# - calc amount into KS (after wage inflation)
# - calc expenses and savings (after inflation)
# - update portfolio size based on savings + inflation, minus tax (monthly?)
# - inflate house value

# each month post-retirement:
# - update expenses basd on inflation
# -- IF yrs_til_mortage_paid_off < simulation yrs AND pay_off_mortgage_in_ret == 'yes add mortgage to expenses
# -- IF age in sim < 65 add pension
# - update income after wage inflation:
# -- calc whether jay and/or e still getting income based on yrs_worked_post_ret params. If yes:
# --- calc take home pay (after wage inflation)
# - either add to or remove from portfolio value, based on income minus expenses
# - inflate house value

# others?
# then find balance at death



gc()

































