export { };
const bcrypt = require('bcryptjs');

const saltRounds = 10;

const con3 = require('../config/sql.config');

exports.addTeacher = (req, res) => {
  const data = req.body;

  const { name } = req.body;
  const { password } = req.body;
  const { email } = req.body;
  const values = [[name, password, email]];

  const salt = bcrypt.genSaltSync(saltRounds);
  const hash = bcrypt.hashSync(password, salt);

  const sqlStmt = 'SELECT * FROM users where email = ? and is_deleted=0';
  con3.query(sqlStmt, [email], (err, result) => {
    if (err) {
      res.status(200).json({
        status: 'Failed',
        message: 'DB Error',
        error: err,
      });
    } else if (result.length > 0) {
      res.status(200).json({
        status: 'Failed',
        message: 'Teacher already exits',
      });
    } else {
      const sql = 'INSERT INTO users (name, email, password) VALUES (?)';
      con3.query(sql, [[name, email, hash]], (err1, result1) => {
        if (err) {
          res.status(400).json({
            status: 'Failed',
            message: 'DB Error, all fields should be full',
            error: err1,
          });
        }
        res.status(200).json({
          status: 'Success',
          teacher_id: result1.insertId,
          successCode: 1,
          message: 'Teacher inserted successfully.',
        });
      });
    }
  });
};

exports.getAllTeachers = (req, res) => {
  const { type } = req.params;
  const sqlStmt = 'SELECT * FROM users where type = 0 and is_deleted=0';
  con3.query(sqlStmt, [type], (err, result) => {
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
        message: 'List of all teachers',
      });
    }
  });
};

exports.updateTeacher = (req, res) => {
  const data = req.body;
  const { id } = req.params;
  const { name } = req.body;
  const { email } = req.body;
  const { password } = req.body;

  const sqlStmt = 'SELECT * FROM users where id = ? and type = 0';
  con3.query(sqlStmt, [id], (err, result) => {
    if (err) {
      res.json({
        status: 'Failed',
        message: 'DB Error',
        error: err,
      });
    } else if (result.length <= 0) {
      res.json({
        status: 'Failed',
        message: 'Teacher is not available',
      });
    } else {
      const salt = bcrypt.genSaltSync(saltRounds);
      const hash = bcrypt.hashSync(password, salt);
      let sql = 'UPDATE users SET name = ?, email = ?, password = ? WHERE id = ? and type = 0';
      let sqlArgs = [name, email, hash, id];
      if (password == "") {
        sql = 'UPDATE users SET name = ?, email = ? WHERE id = ? and type = 0';
        sqlArgs = [name, email, id];
      }
      con3.query(sql, sqlArgs, (err1) => {
        if (err) {
          res.json({
            status: 'Failed',
            message: 'DB Error',
            error: err1,
          });
        } else {
          res.status(200).json({
            status: 'Success',
            teacher_id: id,
            message: 'Teacher updated Successfully.',
          });
        }
      });
    }
  });
};

exports.deleteTeacher = (req, res) => {
  const { id } = req.params;
  const sqlStmt = 'SELECT * FROM users where id = ? and type = 0';
  con3.query(sqlStmt, [id], (err, result) => {
    if (err) {
      res.json({
        status: 'Failed',
        message: 'DB Error',
        error: err,
      });
    } else if (result.length <= 0) {
      res.json({
        status: 'Failed',
        message: 'Teacher is not available',
      });
    } else {
      const sql = 'UPDATE users SET is_deleted=1 WHERE id = ? and type = 0';
      con3.query(sql, [id], (err1) => {
        if (err) {
          res.json({
            status: 'Failed',
            message: 'DB Error',
            error: err1,
          });
        } else {
          res.status(200).json({
            status: 'Success',
            teacher_id: id,
            message: 'Teacher deleted Successfully.',
          });
        }
      });
    }
  });
};
exports.unDeleteTeacher = (req, res) => {
  const { id } = req.params;
  const sqlStmt = 'SELECT * FROM users where id = ? and type = 0';
  con3.query(sqlStmt, [id], (err, result) => {
    if (err) {
      res.json({
        status: 'Failed',
        message: 'DB Error',
        error: err,
      });
    } else if (result.length <= 0) {
      res.json({
        status: 'Failed',
        message: 'Teacher is not available',
      });
    } else {
      const sql = 'UPDATE users SET is_deleted=0 WHERE id = ? and type = 0';
      con3.query(sql, [id], (err1) => {
        if (err) {
          res.json({
            status: 'Failed',
            message: 'DB Error',
            error: err1,
          });
        } else {
          res.status(200).json({
            status: 'Success',
            teacher: result[0],
            message: 'Teacher deleted Successfully.',
          });
        }
      });
    }
  });
};

exports.getTeacher = (req, res) => {
  const { id } = req.params;
  const sqlStmt = 'SELECT * FROM users WHERE id = ? and type =0 and is_deleted=0';
  con3.query(sqlStmt, [id], (err, result) => {
    if (err) {
      res.json({
        status: 'Failed',
        message: 'DB Error',
        error: err,
      });
    } else if (result.length > 0) {
      res.status(200).json({
        results: result,
        status: 'Success',
        teacher_id: id,
        message: 'Teacher Details',
      });
    } else {
      res.json({
        status: 'Failed',
        message: 'Teacher Not Found',
      });
    }
  });
};
