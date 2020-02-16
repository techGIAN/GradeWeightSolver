# GradeWeightSolver
A short tutorial of performing Linear Regression in R by determining the weights of grade requirements of students towards the overall grade

## The Scenario
I have thought of beginning a series, writing blogs for my <a href="http://galix.me/tech-blogz/tech.html" target="_blank">Tech-Blogz</a>, particularly on anything Machine Learning, Data Science, Analytics, etc. It could be tutorials, tricks, tips, thoughts and experiences or basically anything in between. So today I have thought of writing a basic tutorial for performing simple linear regression in R.

As a TA, I easily have connections with different professors and faculty members in our Computer Science department at our university at York. I was able to connect with one of my closest professors, and I asked for a little help from him, to provide his students' grades for a particular course. I would not be mentioning which professor is this and for what course and which academic session it is, but we will be using the <b>grades.xlsx</b> dataset, credits to the anonymous professor who has provided the dataset (does not wish to be named). Also names, student IDs and emails of students were removed for privacy reasons.

## The Dataset
The <b>grades.xlsx</b> dataset is an Excel file, which is composed of 636 observations (i.e. 636 students and each row correspoonds to their grades in the semester) and has 18 columns:
<ul>
  <li><b>s_id</b> - the student ID, labelled 0001 to 0636; the original student IDs are removed</li>
  <li>Columns 2 to 17 are the predictors, these are the grading requirements that will make up the final grade; each component weighted differently</li>
  <li><b>final_grade</b> - the response variable; basically, the percentage of the requirement is multiplied by its grade; this is done to all variables and then summed altogether</li>
 </ul>
In terms of values, notice that only column 1 is an integer (iDs) but we will find out soon enough that we don't really care about the column. Columns 2-18 are reals with minimum value of 0 and a maximum value of 1, which represents the percentage (i.e. 0 for 0% and 1 for 100%, so 75% just means 0.75).

For the predictors, there are 9 labs, 2 tests, 1 midterm, 3 quizzes and 1 final exam. Note that I do not know what the weightings are for each requirement since the <b>grades</b> dataset was from a very old academic session, and I have not yet been born that time yet (lol). Hence, it is those weightings that we will try to predict using linear regression. There are some things that may skew our results, such as:
<ul>
  <li>Outliers: there would always will be, and so we will see how many of them are in our dataset and assess whether it is worth to remove the outliers</li>
  <li>Let us also decided on whether or not to remove the students who have missing exam grade or have several incomplete grades</li>
  <li>It is also unknown as to whether the final grades are as is or if they are curved (either bumped up or down). In certain universities, if a professor senses that the midterm grades turn out to be low, they tend to make the exam easier so that students can pull their averages up - and this can mess up our analyses. It may also be possible that midterms tend to be high and hence the professor makes exams harder to pull class averages down. Also, if by the end of the term and the professor finds out that his/her class has a low class average when it comes to final grades, they tend to curve. In that case, averages shift, and so do the student's grades. We do not know whether the response variable here is already adjusted or the original average.</li>
</ul>
<b>Where to Find the Dataset: </b> It is in this GitHub Repo, please download `grades.xlsx`

## Tutorial in Linear Regression
### Getting started
<p align="center">
  <img src="img/start.png" width=50% margin-left=auto margin-right=auto />
</p>
First download the dataset in this repository. Then launch R (click <a href="https://www.r-project.org/" target="_blank">here</a> if you have not installed R/RStudio yet or if you need technical help with R/RStudio) and start a new project. Once the R window opens, you would see a small square window on the upper right corner of the screen. Click on the "Import Dataset" button, then click on "From Excel" option since we know that the dataset comes from an Excel sheet. Navigate on to the downloaded `grades.xlsx` file. Make sure that we keep the headings on. Then keep all defaults and then import. Alternatively, you can type in this R code in the console to import the dataset:

```
> library(readxl)
> grades <- read_excel("~/Google Drive/linear_reg_R/grades.xlsx")
> View(grades)
```

Notice that the first line allows us to import Excel files, the second line allows us to read our Excel file and import the dataset into a variable called `grades`. The third line simply allows us to view the dataset.

Examine the dataset if you will. Use the the third line of the R code above to view the dataset upon import. Alternatively, ensure that the "Environment" tab is enabled in the small window on the upper right hand corner and you will see a list of available variables in the current environment. Click (or double click "grades") to view the dataset. Compare if we have the same; below shows the first 10 observations that you would find in the dataset:
<p align="center">
  <img src="img/ds.png" width=75% margin-left=auto margin-right=auto />
</p>
