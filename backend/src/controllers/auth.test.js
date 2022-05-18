/* eslint-disable space-in-parens */
/* eslint-disable no-undef */
/* eslint-disable linebreak-style */
/* eslint-disable quotes */

const bcrypt = require('bcryptjs');

test("Password hash Test", () => {
  const Actualpassword = "123";
  const PasswordHash = "$2a$10$CAcqdA7uL2yZ1WoNuB2CsOWQbXET2//.pzGSb75w3xBrOR9azvkcW";
  expect(bcrypt.compareSync(Actualpassword, PasswordHash)).toBe(true);
});
