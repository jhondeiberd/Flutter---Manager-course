import { text } from 'body-parser';

// eslint-disable-next-line import/no-unresolved
const connectionrender = require('../config/sql.config');

exports.courseDetails = (req, res) => {
  const { id } = req.params;
  const sql = 'select cr.id as criId,cr.question, cr.course_id,co.* from criteria as cr join courses co on cr.course_id=co.id where cr.course_id=?';
  connectionrender.query(sql, [id], (err, result) => {
    if (err) {
      res.status(403).json({
        status: 'Failed',
        message: 'DB Error',
        error: err,
      });
    } else {
      res.status(200);
      res.json({
        results: result,
        status: 'Success',
      });
    }
  });
};

exports.addReview = (req, res) => {
  const result = req.body;
  for (let pos = 0; pos < result.length; pos++) {
    const sqlStmt = 'Insert into reviews(course_id,email) VALUES(?)';
    connectionrender.query(
      sqlStmt,
      [[result[pos].courseID, result[pos].studentEmail]],
      (err, resultstmt) => {
        if (err) {
          res.status(400);
          console.log(err);
        } else {
          console.log(result[pos].answer);
          console.log(resultstmt.insertId);
          const statement = 'Insert into review_ratings (review_id,criterion_id,comment,rating) Values(?) ';
          connectionrender.query(
            statement,
            [[resultstmt.insertId, result[pos].criterId,
            result[pos].answer, result[pos].defaultRating]],
            (err3, result2) => {
              if (err3) {
                res.status(400);
              } else {
                console.log(result2);
              }
            },
          );
        }
      },
    );
  }

  res.status(200);
  res.json({
    status: 'Success',
  });
};

exports.getReviewRating = (req, res) => {
  const { id } = req.params;
  const sqlStmt = 'SELECT question, comment, rating FROM review_ratings JOIN criteria on criteria.id = review_ratings.criterion_id where review_id = ?';
  connectionrender.query(sqlStmt, [id], (err, result) => {
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
        message: 'List of ratings',
      });
    } else {
      res.json({
        results: result,
        status: 'Success',
        message: '0 ratings',
      });
    }
  });
};