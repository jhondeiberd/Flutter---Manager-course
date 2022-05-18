export { };
const jsonwebtoken = require('jsonwebtoken');
const bcrypt = require('bcryptjs');
// eslint-disable-next-line import/no-unresolved
const con = require('../config/sql.config');

// eslint-disable-next-line import/no-unresolved,import/extensions
const authJwt = require('../middleware/authJwt');

const login = (req, res) => {
  const { email } = req.body;
  const { password } = req.body;
  const sql = 'SELECT * FROM users WHERE email = ? and is_deleted=0';
  con.query(sql, [email], (err, result) => {
    if (err) {
      res.status(200).json({
        status: 'Failed',
        message: 'DB Error',
        error: err,
      });
      return;
    }
    console.log(err, result);
    if (result.length > 0) {
      const passwordIsValid = bcrypt.compareSync(password, result[0].password);
      if (passwordIsValid) {
        const user = result[0].id;
        const expiresIn = 86400;
        const token = jsonwebtoken.sign({ user }, authJwt.tokenSecret, {
          expiresIn, // 24 hours
        });
        res.json({
          status: 'Success',
          token,
          expiresIn,
          id: result[0].id,
          name: result[0].name,
          type: result[0].type,
          email: result[0].email,
        });
      } else {
        res.status(200).json({
          status: 'Failed',
          message: 'Invalid credentials',
        });
      }
      // }
    } else {
      res.status(200).json({
        status: 'Failed',
        message: 'Invalid credentials',
      });
    }
  });
};
module.exports = {
  login,
};
// # sourceMappingURL=auth.controller.js.map
