// eslint-disable-next-line import/no-unresolved
const nodemailer = require('nodemailer');
const con4 = require('../config/sql.config');

// generates OTP of the specified number of digits
function generate(n) {
  const add = 1; let
    max = 12 - add;

  if (n > max) {
    return generate(max) + generate(n - max);
  }

  max = 10 ** (n + add);
  const min = max / 10; // Math.pow(10, n) basically
  const number = Math.floor(Math.random() * (max - min + 1)) + min;

  return (`${number}`).substring(add);
}

function sendEmail(email, otp) {
  const transporter = nodemailer.createTransport({
    service: 'gmail',
    auth: {
      user: 'courseratingauthservice@gmail.com',
      pass: 'Admin@123',
    },
  });

  const mailOptions = {
    from: 'courseratingauthservice@gmail.com',
    to: email,
    subject: 'OTP for Email Verification',
    html: '<div style="font-family: Helvetica,Arial,sans-serif;min-width:1000px;overflow:auto;line-height:2">\n'
      + '  <div style="margin:50px auto;width:70%;padding:20px 0">\n'
      + '    <div style="border-bottom:1px solid #eee">\n'
      + '      <a href="" style="font-size:1.4em;color: #AB000D;text-decoration:none;font-weight:600">Course Rating App</a>\n'
      + '    </div>\n'
      + '    <p style="font-size:1.1em">Hi,</p>\n'
      + '    <p>Use the following OTP to verify your Email for the Course Rating App. OTP is valid for 3 minutes</p>\n'
      + `    <h2 style="background: #AB000D;margin: 0 auto;width: max-content;padding: 0 10px;color: #fff;border-radius: 4px;">${otp
      }     </h2>\n`
      + '    <p style="font-size:0.9em;">Regards,<br />Course Rating App</p>\n'
      + '    <hr style="border:none;border-top:1px solid #eee" />\n'
      + '  </div>\n'
      + '</div>',
  };

  transporter.sendMail(mailOptions, (error, info) => {
    if (error) {
      console.log(error);
    } else {
      console.log(`Email sent: ${info.response}`);
    }
  });
}

exports.verifyOTP = (req, res) => {
  const { id } = req.params;
  const { code } = req.body;

  const sql = `SELECT * FROM one_time_passwords WHERE id = ? AND code = ${code} AND expires_at > current_timestamp()`;
  con4.query(sql, [id], (err, result) => {
    if (err) {
      res.json({
        status: 'Failed',
        message: 'DB Error',
        error: err,
      });
    } else if (result.length > 0) {
      res.json({
        status: 'Success',
        message: 'Verification Success',
      });
    } else {
      res.json({
        status: 'Success',
        message: 'Verification Failed',
      });
    }
  });
};

exports.sendOTP = (req, res) => {
  const { student_email } = req.body;

  const oneTimePassword = generate(6);

  sendEmail(student_email, oneTimePassword);

  const sql = 'INSERT INTO one_time_passwords(code,expires_at) values( ?, CURRENT_TIMESTAMP() + 180)';
  con4.query(sql, [oneTimePassword], (err, result) => {
    if (err) {
      res.json({
        status: 'Failed',
        message: 'DB Error',
        error: err,
      });
    } else {
      res.json(
        {
          status: 'Successful',
          message: 'email with otp sent',
          id: result.insertId,
        },
      );
    }
  });
};
