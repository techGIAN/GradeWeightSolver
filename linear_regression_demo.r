library(readxl)
grades <- read_excel("~/Google Drive/linear_reg_R/grades.xlsx")

df <- grades[!(grades$final_exam==0),]

pf <- function(model, term_grades) {
    y <- model$coefficients[1]
    for (i in 1:16) {
        y <- y+model$coefficients[i+1]*term_grades[i]
    }
    return(y)
}

sqe <- function(actual, pred) {
    squared_error <- (actual-pred)^2
    return (squared_error)
}

set.seed(1)
rnd_sample <- sample(1:dim(df)[1],dim(df)[1]*9/10)
model_matrix <- model.matrix(final_grade~., data=df)[,-1]

x_train <- model_matrix[rnd_sample,]
x_test <- model_matrix[-rnd_sample,]
y_train <- df$final_grade[rnd_sample]
y_test <- df$final_grade[-rnd_sample]

lin_model <- lm(final_grade~., data=df)
print(summary(lin_model))

pred_test <- predict(lin_model, newdata=data.frame(x_test), type="response")
compare_frame <- data.frame(y_test,pred_test)
compare_frame$sqe <- sqe(compare_frame$y_test, compare_frame$pred_test)
sse <- sum(compare_frame$sqe)
print(sse)

my_grades = c(0.917, 0.933, 1.00, 0.941, 0.974, 0.873, 0.984, 0.94, 0.699, 1.00, 1.00, 0.786, 0.875, 0.667, 0.82, 0.708)
print(pf(lin_model, my_grades))