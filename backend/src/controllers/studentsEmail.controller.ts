export { };
const bcrypt = require('bcryptjs');

const saltRounds = 10;

const con5 = require('../config/sql.config');

exports.getStudents = (req, res) => {
    const { id } = req.params;
    const sqlStmt = 'SELECT id,email FROM reviews where course_id = ?';
    con5.query(sqlStmt, [id], (err, result) => {
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
                message: 'List of students',
            });
        } else {
            res.json({
                results: result,
                status: 'Success',
                message: '0 students',
            });
        }
    });
};