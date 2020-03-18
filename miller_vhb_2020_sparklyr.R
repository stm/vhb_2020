
# Code accompanying the session "Tools for Generating and Disseminating Quantiative Research"
# Contributed Session to the Annual Conference of the German Association of Business Research 
# March 17-19, 2020, Goethe University Frankfurt

# Author: Klaus Miller, Goethe University Frankfurt
# March 2020

# Example: Cluster Analysis
# Goal: Using Spark.ML to predict cluster membership with the iris dataset
# Slightly adapted from source: https://spark.rstudio.com/

# install packages
install.packages(tidyverse)
install.packages("sparklyr")

# Upgrade to latest sparklyr version
devtools::install_github("rstudio/sparklyr")

# load packages
library(tidyverse)
library(sparklyr)

# connecting to spark
sc <- spark_connect(master = "local")

# copy data from R into Spark Cluster
iris_tbl <- copy_to(sc, iris, "iris", overwrite = TRUE)
iris_tbl

# inspect Data Set
glimpse(iris_tbl)

# simple filtering example using Dplyr
iris_tbl %>% filter(Sepal_Length < 5.0)

# use Spark K-Means Clustering
kmeans_model <- iris_tbl %>%
  select(Petal_Width, Petal_Length) %>%
  ml_kmeans(formula= ~ Petal_Width + Petal_Length, k = 3)

# print our model fit
kmeans_model

# predict the associated class
predicted <- ml_predict(kmeans_model, iris_tbl) %>%
  collect

table(predicted$Species, predicted$prediction)

# plot cluster membership
ml_predict(kmeans_model) %>%
  collect() %>%
  ggplot(aes(Petal_Length, Petal_Width)) +
  geom_point(aes(Petal_Width, Petal_Length, col = factor(prediction + 1)),
             size = 2, alpha = 0.5) + 
  geom_point(data = kmeans_model$centers, aes(Petal_Width, Petal_Length),
             col = scales::muted(c("red", "green", "blue")),
             pch = 'x', size = 12) +
  scale_color_discrete(name = "Predicted Cluster",
                       labels = paste("Cluster", 1:3)) +
  labs(
    x = "Petal Length",
    y = "Petal Width",
    title = "K-Means Clustering",
    subtitle = "Use Spark.ML to predict cluster membership with the iris dataset."
  )

