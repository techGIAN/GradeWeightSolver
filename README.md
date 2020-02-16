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
In terms of values, notice that only column 1 is an integer (iDs) but we will find out soon enough that we don't really care about the column. Columns 2-18 are reals with minimum value of 0 and a maximum value of 1, which represents the percentage (i.e. 0 for 0% and 1 for 100%, so 75% just means 0.75). <br> <br>

For the predictors, there are 9 labs, 2 tests, 1 midterm, 3 quizzes and 1 final exam. Note that I do not know what the weightings are for each requirement since the <b>grades</b> dataset was from a very old academic session, and I have not yet been born that time yet (lol). Hence, it is those weightings that we will try to predict using linear regression. There are some things that may skew our results, such as:
<ul>
  <li>Outliers: there would always will be, and so we will see how many of them are in our dataset and assess whether it is worth to remove the outliers</li>
  <li>Let us also decided on whether or not to remove the students who have missing exam grade or have several incomplete grades</li>
  <li>It is also unknown as to whether the final grades are as is or if they are curved (either bumped up or down). In certain universities, if a professor senses that the midterm grades turn out to be low, they tend to make the exam easier so that students can pull their averages up - and this can mess up our analyses. It may also be possible that midterms tend to be high and hence the professor makes exams harder to pull class averages down. Also, if by the end of the term and the professor finds out that his/her class has a low class average when it comes to final grades, they tend to curve. In that case, averages shift, and so do the student's grades. We do not know whether the response variable here is already adjusted or the original average.</li>
</ul>
<b>Where to Find the Dataset: </b> It is in this GitHub Repo, please download <b>grades.xlsx</b>

## Tutorial in Linear Regression
### Getting started
<p align="center">
  <img src="img/start.png" width=50% margin-left=auto margin-right=auto />
</p>
First download the dataset in this repository. Then launch R (click <a href="https://www.r-project.org/" target="_blank">here</a> if you have not installed R/RStudio yet or if you need technical help with R/RStudio) and start a new project. Once the R window opens, you would see a small square window on the upper right corner of the screen. Click on the "Import Dataset" button, then click on "From Excel" option since we know that the dataset comes from an Excel sheet. Navigate on to the downloaded <b>grades.xlsx</b> file. Make sure that we keep the headings on. Then keep all defaults and then import. Alternatively, you can type in this R code in the console to import the dataset:

``` r
> library(readxl)
> grades <- read_excel("~/Google Drive/linear_reg_R/grades.xlsx")
> View(grades)
```

<b><underline>WARNING</underline>!</b> <i>If you opt to use this code, ensure that the parameter inside the</i> `read_excel()` <i> contains the correct path to where you saved your downloaded dataset file. Update the above code if necessary!</i><br><br>

Notice that the first line allows us to import Excel files, the second line allows us to read our Excel file and import the dataset into a variable called `grades`. The third line simply allows us to view the dataset.

Examine the dataset if you will. Use the the third line of the R code above to view the dataset upon import. Alternatively, ensure that the "Environment" tab is enabled in the small window on the upper right hand corner and you will see a list of available variables in the current environment. Click (or double click "grades") to view the dataset. Compare if we have the same; below shows the first 10 observations that you would find in the dataset:
<p align="center">
  <img src="img/ds.png" width=75% margin-left=auto margin-right=auto />
</p>

### Playing Around With the Data (A Bit)
It is important to get to know your data, what you're dealing. Although I have given some preliminary information on what kind of dataset we will be working on and what attributes it has, it is also good to know what other things we can deduce from the dataset. But then for this simple demo, it is enough to know a couple of stuff, perhaps probably only the most pertinent ones. We would not want to waste too much time, it is important to get some exploratory analysis, but just a bit is fine for this case - since we are only looking into building a simple linear regression model. <br><br>

Supposedly that you do not know how many observations are there and how many attributes we are dealing with (i.e. you start fresh with the code). Thus, you need to determine the basic stuff first, such as the <b>dimensions</b> of the dataset - which simply refers to how many observations (denoted by rows) and how many attributes (denoted by columns) are there. We can use the R command, which you may type in the console:
``` r
> dim(grades)
[1] 636  18
```
What we can see here is that the `grades` dataset has 636 observations and 18 attributes. Of course, we already knew that but we just did it for good analysis practice. Trust me, do it habitually. Again, 636 observations or rows means there are 636 students in the professor's class and with 18 attributes, the first being simply the ID (which we would not really need in the regression), the next 16 are the predictors for determining a student's final grade, and the last column is the response variable, which is the student's final grade. Just to give some context, I know I have mentioned some terms such as <b>predictors</b> and <b>response variable</b> but haven't really defined (which I should have). Anyways, the former just means that it is a variable that is used to determine the value of the response variable (`final_grade` in our case) and the other predictors are the rest of the other attributes such as the `midterm` and `final_exam` (note that `s_id` is not a predictor). We only consider it a predictor if it will affect our response variable. As one can think about it, there could be many multiple (but at least 1) predictors but there should only be exactly one response variable (similar to independent and dependent variables respectively).

### Data Pre-Processing
After getting to know your data, it is critical that data be pre-processed before analyses can be performed or before any model can be constructed. (Big) data is noisy and the data that we get is not always perfect. Scenarios such as
<ul>
  <li>Missing data or information </li>
  <li>Inconsistent formatting </li>
  <li>Erroneous data </li>
  <li>Data mis-types</li>
</ul>
are common when working with data, that in fact many data scientists and statisticians spend almost up to 80% of the time on the project just simply to do any data pre-processing tasks (not necessarily 80% but most often than not, longer time than to actually perform their main analysis and tasks). There could be various reasons for why such mishaps happens, such as human error in data input, region discrepancies, data rendering issues, etc. One may solve these issues through data pre-processing techniques such as doing some data correction (eg. filling in missing data with 0s, deleting observations that have missing or incorrect information, taking out outliers, etc.). In detail, I would like to write a separate through in-depth article about data pre-processing and its techniques. But that's for a future blog. At least you know the basic picture.
```r
> df <- grades[!(grades$final_exam==0),]
> dim(df)
[1] 602  18
```
It's a good thing that the dataset that the professor has provided is free from noise (if not perfect, then almost perfect). Since we have some students who dropped the course in the middle of the term or who have not written the exam, then that means they receive a 0 grade for their exam, and because this skews our data - let us take them out. As a side warning though, if there is a significant number of instances of such case, it is not recommended to drop them since you are losing data; you are losing information and this is a trade-off between low good quality data vs high bad quality data. We try to get the balance of having good quality data and at the same time keeping them as much as we could. The more the merrier. But if we look at our dataset, notice that if we perfom the first line, which basically creating another dataset `df` and store there all observations from `grades` whose `final_exam` is not 0. We again use `dim()` function to determine how many instances are there in `df`, which is supposed to hold the students who did not write the exam. Because we have 602 now, and we initially have 636, then only 34 students did not write the exam and we can take it out because that is merely a 5% of the entire student population in the class (i.e. we only consider 95% of the student population which is still good). Another thing to note that just because a student gets a 0 in the exam does not mean that he/she dropped the course or did not write it. It could be that he/she actually wrote the exam and did not really receive a score (i.e. no correct answer). But we shall not worry about this for now; I re-assured that all students that we have in `df` have written the exam.

