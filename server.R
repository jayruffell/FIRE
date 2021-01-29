
server <- function(input, output) {
  
  #________________________________________________________________________
  
  # calculations ----
  #________________________________________________________________________
  # specify after-tax savings per mo until retiring - to invest, if stocks_inflation_rate is >1 # ASSUMES PAYING MORTGAGE RIGHT UP TO RETIREMENT AGE
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

  # specify total amount to save to hit assets target
  savings_target =
    reactive({assets_target() - input$kiwisaver - input$house_downsizing_payoff})

  # years to achieve savings target
  years = reactive({
    if(savings_per_mo_pre_ret() > 0) {
      round(savings_target() / (savings_per_mo_pre_ret() * 12), 0)
    } else {
      'NEVER :('
    }
  })
  
  #________________________________________________________________________
  
  # Structure outputs ----
  #________________________________________________________________________
  
  output$sav_per_mo = renderText(comma(savings_per_mo_pre_ret()))
  output$exp_per_mo = renderText(comma(expenses_per_mo_post_ret()))
  output$ass_reqd = renderText(comma(assets_target()))
  output$sav_reqd = renderText(comma(savings_target()))
  output$years = renderText(years())
  
}
