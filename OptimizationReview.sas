/* Practice problems created by Bolun Yang 2015.11.12*/ 
/* Provides Basic Examples for Linear, MILP, Goal and MC Optmizations */ 
/* Please freely distribute */ 


/*Linear Optimization*/
data LinearProblem;
	input Course $ Base GradePerHr GradePerBlock CourseMax;
	datalines;
		ML 80 2 10 100 
		OP 50 5 20 100
	;
run;

proc optmodel;

set <str> Course;
read data LinearProblem into Course = [Course];

num Base{Course};
num GradePerHr{Course};
num CourseMax{Course};
read data LinearProblem into [Course] Base = Base GradePerHr = GradePerHr CourseMax = CourseMax;

num TotalTime = 16;

var Hour{Course};
impvar Grades{C in Course} = Base[C] + GradePerHr[C] * Hour[C];

Max Grade = sum{C in Course}(Grades[C]);

Con Perfect{C in Course}: Grades[C] <= CourseMax[C];
Con Time: sum{C in Course}(Hour[C]) <= TotalTime;
Con NonZero{C in Course}: Hour[C]>=0;

solve objective Grade;

print Grade;
print Grades;
print Hour;

quit;


proc optmodel;

set <str> Course;
read data LinearProblem into Course = [Course];
set <str> Block = {'SatMorn', 'SatAfter', 'SunAfter'};

num Base{Course};
num GradePerHr{Course};
num CourseMax{Course};
read data LinearProblem into [Course] Base = Base GradePerHr = GradePerBlock CourseMax = CourseMax;

var StudyBlock{Course, Block} binary;

Max Grade= sum{C in Course}(Base[C] + sum{B in Block}(GradePerHr[C] * StudyBlock[C,B]));

Con Perfect{C in Course}: Base[C] + sum{B in Block}(GradePerHr[C]*StudyBlock[C,B]) <= CourseMax[C];
Con Time{B in Block}: sum{C in Course}(StudyBlock[C,B]) <= 1;

solve with MILP objective Grade;

print Grade;
print StudyBlock;

quit;
	

/*Goal Programming*/
proc optmodel;

set <str> Course;
read data LinearProblem into Course = [Course];

num Base{Course};
num GradePerHr{Course};
num CourseMax{Course};
read data LinearProblem into [Course] Base = Base GradePerHr = GradePerHr CourseMax = CourseMax;

num TotalTime = 16;
num Target = 85;

var Hour{Course};
var Penalty{Course};
impvar Grades{C in Course} = Base[C] + GradePerHr[C] * Hour[C];

Min Pen = sum{C in Course}(Penalty[C]);

Con Pen1{C in Course}: Penalty[C]>= Grades[C] - Target;
Con Pen2{C in Course}: Penalty[C]>= Target - Grades[C];
Con Perfect{C in Course}: [Grades[C] <= CourseMax[C];
Con Time: sum{C in Course}(Hour[C]) <= TotalTime;

solve objective Pen;

print Grades;
print Hour;

quit;

/*MC Programming*/

/*Iteration 1*/
proc optmodel;

set <str> Course;
read data LinearProblem into Course = [Course];

num Base{Course};
num GradePerHr{Course};
num CourseMax{Course};
read data LinearProblem into [Course] Base = Base GradePerHr = GradePerHr CourseMax = CourseMax;

num TotalTime = 16;
num CourseMin = 80;

var Hour{Course};
impvar Grades{C in Course} = Base[C] + GradePerHr[C] * Hour[C];

Max Grade = sum{C in Course}(Grades[C]);
/*Min Studytime = sum{C in Course}(Hour[C]);*/

Con MinGrade{C in Course}: Grades[C] >= CourseMin;
Con Perfect{C in Course}: Grades[C] <= CourseMax[C];
Con Time: sum{C in Course}(Hour[C]) <= TotalTime;

solve objective Grade;


print Grades;
print Hour;

quit;
/*Result - 6 Hours of optimization is good enough*/

/*Iteration 2*/
proc optmodel;

set <str> Course;
read data LinearProblem into Course = [Course];

num Base{Course};
num GradePerHr{Course};
num CourseMax{Course};
read data LinearProblem into [Course] Base = Base GradePerHr = GradePerHr CourseMax = CourseMax;

num TotalTime = 16;
num CourseMin = 80;

var Hour{Course};
impvar Grades{C in Course} = Base[C] + GradePerHr[C] * Hour[C];

Max Grade = sum{C in Course}(Grades[C]);
/*Min Studytime = sum{C in Course}(Hour[C]);*/

Con MinGrade{C in Course}: Grades[C] >= CourseMin;
Con Perfect{C in Course}: Grades[C] <= CourseMax[C];
Con Time: sum{C in Course}(Hour[C]) <= TotalTime;

/*New Constraint*/
Con MoveStudyTime: sum{C in Course}(Hour[C]) <= 15;

solve objective Grade;

print Grades;
print Hour;

quit;

/*rinse and repeat...*/

/*Iteration 3*/
proc optmodel;

set <str> Course;
read data LinearProblem into Course = [Course];

num Base{Course};
num GradePerHr{Course};
num CourseMax{Course};
read data LinearProblem into [Course] Base = Base GradePerHr = GradePerHr CourseMax = CourseMax;

num TotalTime = 16;
num CourseMin = 80;

var Hour{Course};
impvar Grades{C in Course} = Base[C] + GradePerHr[C] * Hour[C];

Max Grade = sum{C in Course}(Grades[C]);
/*Min Studytime = sum{C in Course}(Hour[C]);*/

Con MinGrade{C in Course}: Grades[C] >= CourseMin;
Con Perfect{C in Course}: Grades[C] <= CourseMax[C];
Con Time: sum{C in Course}(Hour[C]) <= TotalTime;

/*New Constraint*/
Con MoveStudyTime: sum{C in Course}(Hour[C]) <= 14;

solve objective Grade;

print Grades;
print Hour;

quit;

/*Continue....Every time you move your constraint, you find a new point on the pareto frontier*/
/*Here's the minimum solution*/ 
/*Iteration 3*/
proc optmodel;

set <str> Course;
read data LinearProblem into Course = [Course];

num Base{Course};
num GradePerHr{Course};
num CourseMax{Course};
read data LinearProblem into [Course] Base = Base GradePerHr = GradePerHr CourseMax = CourseMax;

num TotalTime = 16;
num CourseMin = 80;

var Hour{Course};
impvar Grades{C in Course} = Base[C] + GradePerHr[C] * Hour[C];

/*Max Grade = sum{C in Course}(Grades[C]);*/
Min Studytime = sum{C in Course}(Hour[C]);

Con MinGrade{C in Course}: Grades[C] >= CourseMin;
Con Perfect{C in Course}: Grades[C] <= CourseMax[C];
Con Time: sum{C in Course}(Hour[C]) <= TotalTime;

/*New Constraint*/
/*Con MoveStudyTime: sum{C in Course}(Hour[C]) <= 14;*/

solve objective StudyTime;

print Grades;
print Hour;

quit;
