const jwt = require('jsonwebtoken');

const tokenSecret = 'RatingAppSecret';
const verifyToken = (req, res, next) => {
  const token = req.headers['x-access-token']
    ? req.headers['x-access-token'].replaceAll('"', '')
    : '';
  if (!token) {
    res.status(403).send({
      message: 'No token provided!',
    });
  } else {
    jwt.verify(token, tokenSecret, (err) => {
      if (err) {
        res.status(401).send({
          message: 'Unauthorized!',
        });
      } else {
        next();
      }
    });
  }
};
const authJwt = {
  verifyToken,
  tokenSecret,
};
module.exports = authJwt;
