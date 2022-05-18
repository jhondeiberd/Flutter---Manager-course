// @ts-ignore
// eslint-disable-next-line import/no-unresolved
const con10 = require('../config/sql.config');

exports.addCriteria = (req, res) => {
  const data = req.body;

  const { question } = data;
  const courseId = Number(data.course_id);
  const values = [[question, courseId]];

  const sqlStmt = 'SELECT * FROM criteria where course_id = ? and question = ? and is_deleted=0';
  con10.query(sqlStmt, [courseId, question], (err, result) => {
    if (err) {
      res.json({
        status: 'Failed',
        message: 'DB Error',
        error: err,
      });
    } else if (result.length > 0) {
      res.json({
        status: 'Failed',
        message: 'Criteria already exits for the course',
      });
    } else {
      const sql = 'INSERT INTO criteria (question, course_id ) VALUES ?';
      con10.query(sql, [values], (err1, result1) => {
        if (err) {
          res.json({
            status: 'Failed',
            message: 'DB Error',
            error: err1,
          });
        }
        res.json({
          criteria_id: result1.insertId,
          status: 'Success',
          message: 'Criteria Inserted Successfully.',
        });
      });
    }
  });
};

exports.updateCriteria = (req, res) => {
  const data = req.body;
  const { id } = req.params;
  const { question } = data;

  const sqlStmt = 'SELECT * FROM criteria where id = ?';
  con10.query(sqlStmt, [id], (err, result) => {
    if (err) {
      res.json({
        status: 'Failed',
        message: 'DB Error',
        error: err,
      });
    } else if (result.length <= 0) {
      res.json({
        status: 'Failed',
        message: 'Criteria is not available',
      });
    } else {
      const sql = 'UPDATE criteria SET question = ? WHERE id = ?';
      con10.query(sql, [question, id], (err1) => {
        if (err) {
          res.json({
            status: 'Failed',
            message: 'DB Error',
            error: err1,
          });
        } else {
          res.json({
            status: 'Success',
            message: 'Criteria updated Successfully.',
          });
        }
      });
    }
  });
};

exports.deleteCriteria = (req, res) => {
  const { id } = req.params;
  const sqlStmt = 'SELECT * FROM criteria where id = ?';
  con10.query(sqlStmt, [id], (err, result) => {
    if (err) {
      res.json({
        status: 'Failed',
        message: 'DB Error',
        error: err,
      });
    } else if (result.length <= 0) {
      res.json({
        status: 'Failed',
        message: 'criteria is not available',
      });
    } else {
      const sql = 'UPDATE criteria set is_deleted=1 WHERE id = ?';
      con10.query(sql, [id], (err1) => {
        if (err) {
          res.json({
            status: 'Failed',
            message: 'DB Error',
            error: err1,
          });
        } else {
          res.json({
            status: 'Success',
            message: 'criteria deleted Successfully.',
          });
        }
      });
    }
  });
};
exports.unDeleteCriteria = (req, res) => {
  const { id } = req.params;
  const sqlStmt = 'SELECT * FROM criteria where id = ?';
  con10.query(sqlStmt, [id], (err, result) => {
    if (err) {
      res.json({
        status: 'Failed',
        message: 'DB Error',
        error: err,
      });
    } else if (result.length <= 0) {
      res.json({
        status: 'Failed',
        message: 'criteria is not available',
      });
    } else {
      const sql = 'UPDATE criteria set is_deleted=0 WHERE id = ?';
      con10.query(sql, [id], (err1) => {
        if (err) {
          res.json({
            status: 'Failed',
            message: 'DB Error',
            error: err1,
          });
        } else {
          res.json({
            status: 'Success',
            message: 'criteria undeleted Successfully.',
            criteria: result[0],
          });
        }
      });
    }
  });
};

exports.getAllCriteriaOfCourse = (req, res) => {
  const { id } = req.params;
  const sqlStmt = 'SELECT * FROM criteria WHERE course_id = ? and is_deleted=0';
  con10.query(sqlStmt, [id], (err, result) => {
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
        message: 'list of criteria added for the course',
      });
    }
  });
};
