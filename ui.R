shinyUI(
    navbarPage("2012 GDP",
               tabPanel("App",
                        sidebarPanel(
                            sliderInput('Range', 
                                    'GDP',
                                    min = 0, 
                                    max = 16300000, 
                                    value=c(0, 16300000))
                            )
                        
               ,
                        mainPanel(
                            tabsetPanel(
                                tabPanel(
                                    "Total by Income Group",
                                    plotOutput('TotalByIncomeGroup')),
                                tabPanel(
                                    "Total by Region",
                                    plotOutput('TotalByRegion')),
                                tabPanel(
                                    "Ranking",
                                    dataTableOutput('Ranking'))
                                )
                            )
               ),
               tabPanel("About",
                        h4("This app uses 2012 GDP data"),
                        h4("You can use the slider to select the range of each country GDP"),
                        h4("By alternating into tabs, you can check a summarization by Region, by Income Group or check the table itself")
               )
    )
)