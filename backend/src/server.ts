import express from 'express';

const app = express();
const cors = require('cors');
const path = require('path');
const bodyParser = require('body-parser');

const port = 3001;
// eslint-disable-next-line import/no-unresolved
const con = require('./config/sql.config');

// controllers
// eslint-disable-next-line import/no-unresolved
const authController = require('./controllers/auth.controller');
// eslint-disable-next-line import/no-unresolved
const courseController = require('./controllers/course.controller');
// eslint-disable-next-line import/no-unresolved
const teacherController = require('./controllers/teacher.controller');
// eslint-disable-next-line import/no-unresolved
const reviewdata = require('./controllers/review.controller');
// eslint-disable-next-line import/no-unresolved
const studentController = require('./controllers/student.controller');
// eslint-disable-next-line import/no-unresolved
const criteriaController = require('./controllers/criteria.controller');
// eslint-disable-next-line import/no-unresolved
const studentsController = require('./controllers/studentsEmail.controller');

// eslint-disable-next-line import/extensions,import/no-unresolved
const authJwt = require('./middleware/authJwt');

// eslint-disable-next-line import/extensions,import/no-unresolved
const packageJson = require('../package.json');

con.connect((err) => {
  if (err) throw err;
  console.log('DB Connected!');
});

app.use(cors());
// parse application/x-www-form-urlencoded
app.use(bodyParser.urlencoded({ extended: false }));

// parse application/json
app.use(bodyParser.json());

app.use(express.static(path.join(__dirname, 'public')));

app.get('/', (req, res) => {
  res.send(`This is course rating app backend,code verion-: ${packageJson.version}`);
});
app.post('/api/login', authController.login);
app.post('/api/course', [authJwt.verifyToken], courseController.addCourse);
app.put('/api/course/:id', [authJwt.verifyToken], courseController.updateCourse);
app.put('/api/updateDeadline/:id', [authJwt.verifyToken], courseController.updateDeadline);
app.delete('/api/course/:id', [authJwt.verifyToken], courseController.deleteCourse);
app.delete('/api/course/:id/undo', [authJwt.verifyToken], courseController.unDeleteCourse);
app.get('/api/course', [authJwt.verifyToken], courseController.getAllCourses);
app.get('/api/course/:id', [authJwt.verifyToken], courseController.getCourse);
app.get('/api/students/:id', [authJwt.verifyToken], studentsController.getStudents);
app.get('/api/rating/:id', [authJwt.verifyToken], reviewdata.getReviewRating);


app.get('/api/teacher/:id/courses', [authJwt.verifyToken], courseController.getAllCoursesByTeacher);
app.put('/api/criteria/:id', [authJwt.verifyToken], criteriaController.updateCriteria);
app.delete('/api/criteria/:id', [authJwt.verifyToken], criteriaController.deleteCriteria);
app.delete('/api/criteria/:id/undo', [authJwt.verifyToken], criteriaController.unDeleteCriteria);
app.post('/api/criteria', [authJwt.verifyToken], criteriaController.addCriteria);
app.get('/api/course/:id/criteria', [authJwt.verifyToken], criteriaController.getAllCriteriaOfCourse);

app.post('/api/teacher', [authJwt.verifyToken], teacherController.addTeacher);
app.get('/api/teacher', [authJwt.verifyToken], teacherController.getAllTeachers);
app.delete('/api/teacher/:id', [authJwt.verifyToken], teacherController.deleteTeacher);
app.delete('/api/teacher/:id/undo', [authJwt.verifyToken], teacherController.unDeleteTeacher);
app.put('/api/teacher/:id', [authJwt.verifyToken], teacherController.updateTeacher);
app.get('/api/teacher/:id', [authJwt.verifyToken], teacherController.getTeacher);

app.get('/api/sendQuestions/:id', reviewdata.courseDetails);
app.post('/api/sendFeedBackFromStudent', reviewdata.addReview);

app.post('/api/otp', studentController.sendOTP);

app.post('/api/otp/:id', studentController.verifyOTP);

app.listen(port, () => console.log(`Express is listening at http://localhost:${port}`));
