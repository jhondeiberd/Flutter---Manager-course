const db = process.env.CONFIG_MYSQL_DATABASE || 'ratingdb';
const host = process.env.CONFIG_MYSQL_HOST || '127.0.0.1';
const password = process.env.CONFIG_MYSQL_PASSWORD || ''; // secret
const user = process.env.CONFIG_MYSQL_USER || 'root';
const mysqlPort = process.env.CONFIG_MYSQL_PORT || '3306'; // 13306

// eslint-disable-next-line import/no-unresolved
const mysql = require('mysql');

const connection = mysql.createConnection({
  host,
  user,
  password,
  database: db,
  connectionLimit: 100,
  port: mysqlPort,
});
module.exports = connection;
