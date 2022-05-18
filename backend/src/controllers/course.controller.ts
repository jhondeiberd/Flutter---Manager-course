// eslint-disable-next-line import/no-unresolved
// @ts-ignore
// eslint-disable-next-line import/no-unresolved
const con2 = require('../config/sql.config');

exports.addCourse = (req, res) => {
  const data = req.body;

  const { title } = data;
  const { description } = data;
  const teacherId = Number(data.teacher_id);
  const values = [[title, description, teacherId]];

  const sqlStmt = 'SELECT * FROM courses where title = ? and teacher_id = ? and is_deleted=0';
  con2.query(sqlStmt, [title, teacherId], (err, result) => {
    if (err) {
      res.json({
        status: 'Failed',
        message: 'DB Error',
        error: err,
      });
    } else if (result.length > 0) {
      res.json({
        status: 'Failed',
        message: 'Course already exits',
      });
    } else {
      const sql = 'INSERT INTO courses (title, description, teacher_id) VALUES ?';
      con2.query(sql, [values], (err1, result1) => {
        if (err) {
          res.json({
            status: 'Failed',
            message: 'DB Error',
            error: err1,
          });
        }
        res.json({
          course_id: result1.insertId,
          status: 'Success',
          message: 'Course Inserted Successfully.',
        });
      });
    }
  });
};

exports.updateCourse = (req, res) => {
  const data = req.body;
  const { id } = req.params;
  const { title } = data;
  const { description } = data;

  const sqlStmt = 'SELECT * FROM courses where id = ?';
  con2.query(sqlStmt, [id], (err, result) => {
    if (err) {
      res.json({
        status: 'Failed',
        message: 'DB Error',
        error: err,
      });
    } else if (result.length <= 0) {
      res.json({
        status: 'Failed',
        message: 'Course is not available',
      });
    } else {
      const sql = 'UPDATE courses SET title = ?, description = ? WHERE id = ?';
      con2.query(sql, [title, description, id], (err1) => {
        if (err) {
          res.json({
            status: 'Failed',
            message: 'DB Error',
            error: err1,
          });
        } else {
          res.json({
            status: 'Success',
            message: 'Course updated Successfully.',
          });
        }
      });
    }
  });
};

exports.deleteCourse = (req, res) => {
  const { id } = req.params;
  const sqlStmt = 'SELECT * FROM courses where id = ?';
  con2.query(sqlStmt, [id], (err, result) => {
    if (err) {
      res.json({
        status: 'Failed',
        message: 'DB Error',
        error: err,
      });
    } else if (result.length <= 0) {
      res.json({
        status: 'Failed',
        message: 'Course is not available',
      });
    } else {
      const sql = 'UPDATE courses SET is_deleted=1 WHERE id = ?';
      con2.query(sql, [id], (err1) => {
        if (err) {
          res.json({
            status: 'Failed',
            message: 'DB Error',
            error: err1,
          });
        } else {
          res.json({
            status: 'Success',
            message: 'Course deleted Successfully.',
          });
        }
      });
    }
  });
};
exports.unDeleteCourse = (req, res) => {
  const { id } = req.params;
  const sqlStmt = 'SELECT * FROM courses where id = ?';
  con2.query(sqlStmt, [id], (err, result) => {
    if (err) {
      res.json({
        status: 'Failed',
        message: 'DB Error',
        error: err,
      });
    } else if (result.length <= 0) {
      res.json({
        status: 'Failed',
        message: 'Course is not available',
      });
    } else {
      const sql = 'UPDATE courses SET is_deleted=0 WHERE id = ?';
      con2.query(sql, [id], (err1) => {
        if (err) {
          res.json({
            status: 'Failed',
            message: 'DB Error',
            error: err1,
          });
        } else {
          res.json({
            status: 'Success',
            message: 'Course deleted Successfully.',
            course: result[0],
          });
        }
      });
    }
  });
};
exports.getAllCourses = (req, res) => {
  const sqlStmt = 'SELECT * FROM courses where is_deleted=0';
  con2.query(sqlStmt, (err, result) => {
    if (err) {
      res.json({
        status: 'Failed',
        message: 'DB Error',
        error: err,
      });
    } else {
      res.json({
        results: result,
        status: 'Success',
        message: 'List of all courses',
      });
    }
  });
};

exports.getCourse = (req, res) => {
  const { id } = req.params;
  const sqlStmt = 'SELECT * FROM courses WHERE id = ? and is_deleted=0';
  con2.query(sqlStmt, [id], (err, result) => {
    if (err) {
      res.json({
        status: 'Failed',
        message: 'DB Error',
        error: err,
      });
    } else if (result.length > 0) {
      res.json({
        results: result,
        status: 'Success',
        message: 'Course Details',
      });
    } else {
      res.json({
        status: 'Failed',
        message: 'Course Not Found',
      });
    }
  });
};

exports.getAllCoursesByTeacher = (req, res) => {
  const { id } = req.params;
  const sqlStmt = 'SELECT * FROM courses WHERE teacher_id = ? and is_deleted=0';
  con2.query(sqlStmt, [id], (err, result) => {
    if (err) {
      res.json({
        status: 'Failed',
        message: 'DB Error',
        error: err,
      });
    } else if (result.length > 0) {
      res.json({
        results: result,
        status: 'Success',
        message: 'List of courses added by Teachers',
      });
    } else {
      res.json({
        results: result,
        status: 'Success',
        message: 'No courses were added by teacher',
      });
    }
  });
};

exports.updateDeadline = (req, res) => {


  const data = req.body;
  const { id } = req.params;
  const  title  = data.title;
  const  poll_ends_at  = data.deadline;
  const date = new Date(data.deadline);
  const sqlStmt = 'SELECT * FROM courses where id = ?';
  con2.query(sqlStmt, [id], (err, result) => {
    if (err) {
      res.json({
        status: 'Failed',
        message: 'DB Error',
        error: err,
      });
    } else if (result.length <= 0) {
      res.json({
        status: 'Failed',
        message: 'Course is not available',
      });
    } else {
      const sql = 'UPDATE courses SET poll_ends_at = ? WHERE id = ?';
      con2.query(sql, [date, id], (err1) => {
        if (err) {
          res.json({
            status: 'Failed',
            message: 'DB Error',
            error: err1,
          });
        } else {
          res.json({
            status: 'Success',
            message: 'Course updated Successfully.',
          });
        }
      });
    }
  });
};

