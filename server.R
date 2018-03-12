#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  output$distPlot <- renderPlot({
    poly_ord <- input$ord
    predictor <- input$predict
    # generate random data to be fit with polynomial
    set.seed(123)
    q <- seq(from = 0, to = 25, by = 0.1)
    # generate y-axis data to predict
    y <- 100 + 0.4 * (q - 10)^3
    # add some noise
    noise <- rnorm(length(q), mean = 10, sd = 80)
    ynoise <- y + noise
    # model
    model <- lm(ynoise ~ poly(q, poly_ord, raw = TRUE))
    # format model output for display on UI
    df <- data.frame(summary(model)$coefficients)
    coeff_names <- c("intercept (a0)")
    counter <- ""
    for(ii in 1:poly_ord) {
      counter <- as.character(ii)
      coeff_names <- c(coeff_names,paste0("a",counter))
    }
    rownames(df) <- coeff_names
    df$Estimate <- round(df$Estimate,2)
    df$Std..Error <- round(df$Std..Error,2)
    df$t.value <- round(df$t.value,2)
    df$Pr...t.. <- formatC(df$Pr...t.., format = "e", digits = 2)

    modelpred <- reactive({
      predict(model, newdata = data.frame(q = predictor))
    })
    # plot
    plot(q, ynoise, col = 'deepskyblue4', xlab = 'index', ylab = "output variable", main = 'Random data')
    # Predicted values and confidence intervals
    predicted.intervals <- predict(model, data.frame(x = q),interval = 'confidence', level=0.95)
    # add lines to the plot
    lines(q,predicted.intervals[,1],col = 'green',lwd = 3)
    lines(q,predicted.intervals[,2],col = 'black',lwd = 1)
    lines(q,predicted.intervals[,3],col = 'black',lwd = 1)
    # prediction point
    points(predictor, modelpred(), col = "red", pch = 16, cex = 2)
    # legend
    legend("bottomright",
           c("Observ.","Predicted"),
           col = c("deepskyblue4","green"),
           pch = c(1,NA),
           lty = c(NA,1),
           lwd = c(1,3) )
    output$pred1 <- renderText({
      round(modelpred(),2)
    })
    output$Rsqd <- renderText({
      round(summary(model)$r.squared,6)
    })
    output$myTable <- DT::renderDataTable({
      DT::datatable(df)
    })
  })
})
