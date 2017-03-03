library(shiny)
library(ggplot2)
library(dplyr)

shinyServer(function(input, output) {
    output$plot <- renderPlot({
        d <- diamonds %>%
            filter(grepl(input$cut,     cut), 
                   grepl(input$color,   color), 
                   grepl(input$clarity, clarity))
        
        fit <- lm(price ~ carat + I(carat^2), d)
        
        pred <- predict(fit, newdata = data.frame(carat   = input$carat,
                                                  cut     = input$cut,
                                                  color   = input$color,
                                                  clarity = input$clarity))

        g <- ggplot(data = d, aes(x = carat, y = price)) +
            geom_point(alpha = .3)+
            geom_smooth(method = "lm", formula = y ~ x + I(x^2)) +
            geom_vline(xintercept = input$carat, color = "blue") +
            geom_hline(yintercept = pred, color = "blue")
        g
    })
    output$result <- renderText({
        # renders the text for the prediction below the graph
        d <- filter(diamonds, grepl(input$cut, cut), grepl(input$color, color), grepl(input$clarity, clarity))
        fit <- lm(price ~ carat + I(carat^2), d)
        pred <- predict(fit, newdata = data.frame(carat = input$carat,
                                                  cut = input$cut,
                                                  color = input$color,
                                                  clarity = input$clarity))
        res <- paste0("You can gain about $", round(pred, 0), " for that one!")
        res
    })
    
})
