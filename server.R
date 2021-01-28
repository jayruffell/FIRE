
library(scales)

server <- function(input, output) {
  
  #________________________________________________________________________
  
  # Prelim calculations ----
  #________________________________________________________________________
  
  # specify savings per mo until retiring # ASSUMES PAYING MORTGAGE RIGHT UP TO RETIREMENT AGE
  savings_per_mo_pre_ret = 
    reactive({input$income - input$mortgage - input$expenses})

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
    savings_target() / (savings_per_mo_pre_ret() * 12)
  })
  
  #________________________________________________________________________
  
  # Structure outputs ----
  #________________________________________________________________________
  
  output$sav_per_mo = renderText(comma(savings_per_mo_pre_ret()))
  output$exp_per_mo = renderText(comma(expenses_per_mo_post_ret()))
  output$ass_reqd = renderText(comma(assets_target()))
  output$sav_reqd = renderText(comma(savings_target()))
  output$years = renderText(comma(years()))
  
}
