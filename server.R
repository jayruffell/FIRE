
server <- function(input, output) {
  
  #________________________________________________________________________
  
  # calculations ----
  #________________________________________________________________________
  
  # specify after-tax savings per mo until retiring - to invest, if stocks_inflation_rate is =! 0 # ASSUMES PAYING MORTGAGE RIGHT UP TO RETIREMENT AGE
  savings_per_mo_pre_ret = 
    # take home pay
    reactive({monthly_take_home_pay(input$income_e, input$ks_e) + 
        monthly_take_home_pay(input$income_j, input$ks_j) +
        # kiwisaver post-tax
        kiwisaver_monthly(input$income_e, input$ks_e) +
        kiwisaver_monthly(input$income_j, input$ks_j) -
        # expenses
        input$mortgage - input$expenses})

  # Specify expenses per mo in retirement. THIS ASSUMES NO MORTGAGE BY RETIREMENT AGE, ALSO PENSION IMMEDIATELY. BUT THIS IS INCORRECT IF WE RETIRE EARLY ENOUGH!
  expenses_per_mo_post_ret =
    reactive({input$expenses*(input$retirement_spend_rate/100) - input$pension})

  # specify tot assets required to provide retirement expenses perpetually
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
  
  # # model the above df to be able to predict when we can retire
  # years2 = reactive({
  #   # nothing fits well - so use AIC to build a really flexible model
  #   expSeq = seq(1, 3, by=0.01)
  #   aicVec = vector()
  #   for(i in 1:length(expSeq)) {
  #    mod_i =  lm(investment_value ~ year^expSeq, data=investments_over_time())
  #   }
  #   # mymod = lm(investment_value ~ log(year), data=investments_over_time())
  #   # updated = investments_over_time() %>%
  #     mutate(preds = predict(mymod))
  #   # filter down to predicted year closest to 
  #   
  #   return(updated)
  # })

  # years to achieve savings target
  years = reactive({
    
    # first check if we never reach target, and if so use 10000yrs as a flag 
    if(max(investments_over_time()$investment_value) <
       assets_target()) {
      return(Inf)
    } else {
      closestYear = investments_over_time() %>%
        mutate(target = assets_target()) %>%
        mutate(diff = investment_value-target) %>%     
        filter(abs(diff)==min(abs(diff)))
      return(closestYear$year)
    }
  })
  
  #________________________________________________________________________
  
  # Structure outputs ----
  #________________________________________________________________________
  
  output$sav_per_mo = renderText(comma(savings_per_mo_pre_ret()))
  output$exp_per_mo = renderText(comma(expenses_per_mo_post_ret()))
  output$ass_reqd = renderText(comma(assets_target()))
  output$years = renderText(years())
  output$plot = renderPlot({
    investments_over_time() %>%
      ggplot(aes(year, investment_value)) + geom_line() +
      geom_abline(slope=0, intercept=assets_target()) +
      ylim(min(investments_over_time()$investment_value),
           assets_target()*1.5)
  })
}
