
server <- function(input, output) {
  
  #________________________________________________________________________
  
  # calculations ----
  #________________________________________________________________________
  
  #++++++++++++
  # specify after-tax savings per mo until retiring # ASSUMES PAYING MORTGAGE RIGHT UP TO RETIREMENT AGE
  #++++++++++++
  
  savings_per_mo_pre_ret = 
    # take home pay
    reactive({monthly_take_home_pay(input$income_e, 3) + 
        monthly_take_home_pay(input$income_j, 3) +
        # kiwisaver post-tax
        kiwisaver_monthly(input$income_e, 3) +
        kiwisaver_monthly(input$income_j, 3) -
        # expenses
        input$mortgage - input$expenses})

  #++++++++++++
  # Specify expenses per mo in retirement. THIS ASSUMES NO MORTGAGE BY RETIREMENT AGE, ALSO PENSION IMMEDIATELY. BUT THIS IS INCORRECT IF WE RETIRE EARLY ENOUGH!
  #++++++++++++
  
  expenses_per_mo_post_ret =
    reactive({input$expenses*(input$retirement_spend_rate/100) - input$pension})

  #++++++++++++
  # specify tot assets required to provide retirement expenses perpetually
  #++++++++++++
  
  assets_target = reactive({
    (1/(input$withdrawal_rate/100)) * 12 * expenses_per_mo_post_ret()
  })
  
  #++++++++++++
  # calculate value of investments over 30yr time horizon
  #++++++++++++
  
  # create discrete points using a loop & equations
  investments_over_time =
    reactive({
      finaldf = data.frame(year = 1:30, investment_value=NA)
  for(i in 1:nrow(finaldf)){
    finaldf$investment_value[i] =
      investment_value_after_n_yrs(initial = input$kiwisaver_current,
                                   annual_payments = (savings_per_mo_pre_ret()*12),
                                   percent_growth = input$stocks_inflation_rate,
                                   yrs = finaldf$year[i])
  }
      return(finaldf)
    })
  
  #++++++++++++
  # years to achieve savings target
  #++++++++++++
  
  years = reactive({
    
    if(max(investments_over_time()$investment_value) <
       assets_target()) {
      # first check if we never reach target, and if so use 10000yrs as a flag 
      return(Inf)
    } else {
      closestYear = investments_over_time() %>%
        mutate(target = assets_target()) %>%
        mutate(diff = investment_value-target) %>%     
        filter(abs(diff)==min(abs(diff)))
      return(closestYear$year)
    }
  })
  
  #++++++++++++
  # amount owing on mortgage at time of retirement
  #++++++++++++
  
  # ----------------------------------------------------------
  # up to here - need to add the below params to ui, plus the final output!
  # in testing, 10% inflation rate, 1.1mill house, 11 years to ret, 4% mort rate(?) we would have 80% prop left. check that is still case in dash.
  mortgagedf = reactive({
    
    # params
    current_homeloan = input$homeloan
    mortage_rate = input$mortgage_rate
    mortgage_payments = input$mortgage
    house_inflation = input$house_inflation_rate
    house_current_val = input$house_value
    years_til_ret = years()
    
    # initialise numbers
    months = 1:360
    balance = numeric()
    balance[1] = current_homeloan
    
    # each month, pay mortgage and calculate new balance after interest
    for(i in 2:length(months)) {
      balance[i] = balance[i-1] + 
        # add interest (converted to mnthly)
        balance[i-1]*(mortage_rate/100)/12 -
        # subtract repayments
        mortgage_payments
    }
    mortgagedf = data.frame(months, balance) %>%
      mutate(years = months/12)
    
    # find amount owing at time of retirement
    final_balance = mortgagedf %>%
      filter(abs(years-years_til_ret)==min(abs(years-years_til_ret))) %>%
      pull(balance)
    
    # find out what proportion of house value we could keep after paying off mortgage
    house_val = house_current_val*(1 + house_inflation/100)^years_til_ret
    house_prop = ((house_val - final_balance)/house_val)*100  
    return(data.frame(final_balance, house_prop))
    })
  
  #________________________________________________________________________
  
  # Structure outputs ----
  #________________________________________________________________________
  
  # # test output for viewing intermediate restuls
  # output$testing = renderText(investments_over_time()$investment_value[1])
  
  # main outptus
  output$sav_per_mo = renderText(comma(savings_per_mo_pre_ret()))
  output$exp_per_mo = renderText(comma(expenses_per_mo_post_ret()))
  output$ass_reqd = renderText(comma(assets_target()))
  output$years = renderText(years())
  output$homeloan = renderText(comma(mortgagedf()$final_balance))
  output$house_val = renderText(round(mortgagedf()$house_prop, 0))
  output$plot = renderPlot({
    investments_over_time() %>%
      ggplot(aes(year, investment_value)) + geom_line() + 
      geom_abline(slope=0, intercept=assets_target()) +
      ylim(min(investments_over_time()$investment_value),
           assets_target()*1.5) +
      scale_y_continuous(labels=scales::dollar_format()) +
      ylab('Value of investments') + xlab('Years hence')
  })
}
