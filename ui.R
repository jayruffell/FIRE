#___________________________________________________________________

# Main premise: all savings are invested, either in Kiwisaver or elsewhere. Rate of returns is specified in dash and assumed to be same for KS and other investments. For this reason KS rate (3 vs 8%) is irrelevant.

# see server.R for some assumptions that may be wrong!

# Tax notes:
# - KS employee contributions deducted pre-tax, but your PAYE is calcd on all earnings. KS employer contributions are post-tax. So for Jay employee contributions showing up in KS account might be $300 per month whereas employer would be $200 per month - cos theirs is getting taxed before going in, whereas mine already accounted for in PAYE.
# - KS earnings taxed at PIR of 28% if income <48K. Note PIR for other investments may be much lower once retired? If investments < 48K then 10.5%; if <70K then 17.5%. Also things get complicated as to whether you pay tax on *dividends* vs *capital gains* of shares, see here for deets https://moneykingnz.com/what-taxes-do-you-need-to-pay-on-your-investments-in-new-zealand/


#-------------------------------------------------------------------
# OTHER NOTES
# should i consider that any savings beyond buying house are earning interest? e.g. straight into ks?
#-------------------------------------------------------------------

# TO DO 
# add an 'assumptions' writeout at bottom
# allow for using up all savings + reverse mortgage
# factor in Deflation of savings per Ec Explained - or is this in 'withdrawal rate'?
# factor in that pension won't be paid pre-65 - also allow for post-retirment salary for x years? OR have printout 'you will need to earn salary of $xxx until 65 to cover mortgage payments + pension, assuming mortgage paid off at 65  (cos mortgage is due to be paid off right when we retire)'
# think about whether investment interest needs to be monthly - currently added annually. make a difference?
# think about whether i'm accurate enough on how i've calcd mortgage amount owing - based on flat 2900 payments c.f. varying with interested rate based on 30y term


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
      h4('Income & expenses'), 
      numericInput(inputId = "income_e",
                   label = "Emily's salary:",
                   value = 80000),
      numericInput(inputId = "income_j",
                   label = "Jay's salary:",
                   value = 120000),
      numericInput(inputId = "kiwisaver_current",
                   label = "Current kiwisaver amount:",
                   value = 60000),
      numericInput(inputId = "stocks_inflation_rate",
                   label = "Investment growth rate (%):",
                   value = 4), # need to factor in tax (28% on PIE earnings, e.g. KS), inflation? others? Or will inflation get built into total saving amount, e..g change to real dollar terms 
      numericInput(inputId = "expenses",
                   label = "Monthly expenses (ex mortgage):",
                   value = 7000),
      br(),
      h4('House'),
      numericInput(inputId = "homeloan",
                   label = "Current homeloan:",
                   value = 560000),
      numericInput(inputId = "mortgage",
                   label = "Mortgage payments per month:",
                   value = 2900),
      numericInput(inputId = "mortgage_rate",
                   label = "Mortgage rate:",
                   value = 4),
      numericInput(inputId = "house_inflation_rate",
                   label = "House appreciation rate:",
                   value = 8),
      numericInput(inputId = "house_value",
                   label = "Current house value:",
                   value = 1100000),
      br(),
      h4('Post-retirement'),
      numericInput(inputId = "retirement_spend_rate",
                   label = "Retirement spend rate (%):",
                   value = 85),
      numericInput(inputId = "pension",
                   label = "Monthly after-tax pension:",
                   value = 2600),
      numericInput(inputId = "withdrawal_rate",
                   label = "Annual withdrawal rate (%):",
                   value = 3) # 4% often advocated for US, 2.5-3% for UK. See  https://moneyed.co.uk/blog/intro_to_fire. Also, from https://en.wikipedia.org/wiki/Trinity_study see criticicms, e.g.: Laurence Kotlikoff, advocate of the consumption smoothing theory of retirement planning, is even less kind to the 4% rule, saying that it "has no connection to economics.... economic theory says you need to adjust your spending based on the portfolio of assets you're holding. If you invest aggressively, you need to spend defensively. Notice that the 4 percent rule has no connection to the other rule—to target 85 percent of your preretirement income. The whole thing is made up out of the blue."[7]
    ),
    
    #________________________________________________________________________
    
    # Outputs ----
    #________________________________________________________________________
    
    mainPanel(
      
      # # test output for viewing intermediate restuls
      # textOutput('testing'),
      
      # main outptus
      hr('Savings per month until retirement:'), 
      textOutput('sav_per_mo', inline=T),
      br(),
      hr('Expenses per month in retirement:'), 
      textOutput('exp_per_mo', inline=T),
      br(),
      hr('Assets required to provide retirement expenses perpetually:'),
      textOutput('ass_reqd', inline=T),
      br(),
      hr('Years to achieve:'),
      textOutput('years', inline=T),
      br(),
      hr('Homeloan owing at retirement:'),
      textOutput('homeloan', inline=T),
      br(),
      hr('$ available for post-retirement home after paying off homeloan (% of current home value:'),
      textOutput('house_val', inline=T),
      br(),
      hr('Investments over time:'),
      plotOutput('plot')
    )
  )
)