# Tax notes:
# - KS is deducted pre-tax, but your PAYE is calcd on all earnings
# - KS earnings taxed at PIR of 28% if income <48K. Note PIR for other investments may be much lower once retired? If investments < 48K then 10.5%; if <70K then 17.5%. Also things get complicated as to whether you pay tax on *dividends* vs *capital gains* of shares, see here for deets https://moneykingnz.com/what-taxes-do-you-need-to-pay-on-your-investments-in-new-zealand/


#-------------------------------------------------------------------

# TO DO 
# add in annual salary increase
# figure out if I'm accounting for tax on investments when working out if they cover expenses? Does the 4% inc tax? See above for NZ PIR rates
# add in kiwisaver growth (3% of income)
# loan amont paid off, possibly converting to % value of current house after additional input for house inflation. amortisation rate could come from here - mortgage: at a given no. of periods, interest rate, and principal value, how much will be left on loan? possibly here for rearranging?  n=−log(1−rPVPMT)log(1+r) from https://math.stackexchange.com/questions/2265192/solve-for-n-for-loan-amortization?
# nice rounding
# allow for reverse mortgage
# factor in Deflation of savings per Ec Explained

# -------------------------------------------------------------------

# Define UI for dataset viewer app ----
ui <- fluidPage(
  
  # App title ----
  titlePanel("Jemily on FIRE"),
  
  # Sidebar layout with a input and output definitions ----
  sidebarLayout(
    
    #________________________________________________________________________
    
    # Inputs ----
    #________________________________________________________________________

    sidebarPanel(
      
      #++++++++++++++
      # initial values
      #++++++++++++++
      
      numericInput(inputId = "income_e",
                   label = "Emily's salary:",
                   value = 80000),

      numericInput(inputId = "ks_e",
                   label = "Emily's Kiwisaver rate (%):",
                   value = 3),
      numericInput(inputId = "income_j",
                   label = "Jay's salary:",
                   value = 120000),
      numericInput(inputId = "ks_j",
                   label = "Jay's Kiwisaver rate (%):",
                   value = 3),
      numericInput(inputId = "mortgage",
                   label = "Monthly expenses - mortgage:",
                   value = 2900),
      numericInput(inputId = "expenses",
                   label = "Monthly expenses - other:",
                   value = 7000),
      numericInput(inputId = "withdrawal_rate",
                   label = "Annual withdrawal rate (%):",
                   value = 3), # 4% often advocated for US, 2.5-3% for UK. See  https://moneyed.co.uk/blog/intro_to_fire. Also, from https://en.wikipedia.org/wiki/Trinity_study see criticicms, e.g.: Laurence Kotlikoff, advocate of the consumption smoothing theory of retirement planning, is even less kind to the 4% rule, saying that it "has no connection to economics.... economic theory says you need to adjust your spending based on the portfolio of assets you're holding. If you invest aggressively, you need to spend defensively. Notice that the 4 percent rule has no connection to the other rule—to target 85 percent of your preretirement income. The whole thing is made up out of the blue."[7]
      numericInput(inputId = "retirement_spend_rate",
                   label = "Retirement spend rate (%):",
                   value = 85),
      numericInput(inputId = "pension",
                   label = "Monthly after-tax pension:",
                   value = 2600),
      
      #++++++++++++++
      # current assets
      #++++++++++++++
      
      numericInput(inputId = "kiwisaver",
                   label = "Current kiwisaver amount:",
                   value = 30000),
      numericInput(inputId = "house_downsizing_payoff",
                   label = "downsizing:",
                   value = 0)
    ),
    
    #________________________________________________________________________
    
    # Outputs ----
    #________________________________________________________________________
    
    mainPanel(
      
      hr('Savings per month until retirement:'), 
      textOutput('sav_per_mo', inline=T),
      br(),
      hr('Expenses per month in retirement:'), 
      textOutput('exp_per_mo', inline=T),
      br(),
      hr('Assets required to provide retirement expenses perpetually:'),
      textOutput('ass_reqd', inline=T),
      br(),
      hr('Total amount to save:'),
      textOutput('sav_reqd', inline=T),
      br(),
      hr('Years to achieve:'),
      textOutput('years', inline=T),
    )
  )
)