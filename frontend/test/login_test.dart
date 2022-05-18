
import 'package:flutter_test/flutter_test.dart';


import '../lib/pages/login.dart';

void main() {
  test('Checks if email is valid or not', () {
    bool valid = validateEmail("h@gmail.com");
    bool withoutAt = validateEmail("hgmail.com");
    bool withoutDot = validateEmail("h@gmailcom");
    expect(valid, true);
    expect(withoutAt, false);
    expect(withoutDot, false);

  });
}

