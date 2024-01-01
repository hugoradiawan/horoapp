import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:horoflutter/business_loc/file_upload_controller.dart';
import 'package:horoflutter/business_loc/nestjs_connect.dart';
import 'package:horoflutter/horo_app.dart';
import 'package:horoflutter/ui_loc/profile_controller.dart';
import 'package:integration_test/integration_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:logger/logger.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  group('register and login user', () {
    setUpAll(() async {
      await Future.wait([
        GetStorage.init(),
        initializeDateFormatting('en'),
      ]);
      Get.lazyPut(() => NestJsConnect(ip: '192.168.1.100'));
      Get.lazyPut(() => FileUploader());
      Get.lazyPut(() => ProfileController(), fenix: true);
    });
    testWidgets('register and login user', (WidgetTester tester) async {
      final Finder registerSwitch = find.byKey(const Key('RegisterSwitch')),
          emailTec = find.byKey(const Key('emailtec')),
          usernameTec = find.byKey(const Key('usernametec')),
          passwordTec = find.byKey(const Key('passwordtec')),
          confirmPasswordTec = find.byKey(const Key('confirmpasswordtec')),
          registerBtn = find.byKey(const Key('registerbtn')),
          loginUsernameOrEmail = find.byKey(const Key('loginUsernameOrEmail')),
          loginPassword = find.byKey(const Key('loginPassword')),
          loginBtn = find.byKey(const Key('loginbtn'));
      final Random random = Random();
      final String rnd = random.nextInt(999).toString(),
          email = 'test$rnd@test.id',
          username = 'test$rnd',
          password = '112233';
      Logger().i('email: $email');

      await tester.pumpWidget(const HoroApp());

      await tester.tap(registerSwitch);
      await tester.pumpAndSettle();

      await tester.enterText(emailTec, email);
      await tester.enterText(usernameTec, username);
      await tester.enterText(passwordTec, password);
      await tester.enterText(confirmPasswordTec, password);
      await tester.pumpAndSettle();

      await tester.ensureVisible(registerBtn);
      await tester.pumpAndSettle();
      expect(registerBtn, findsOneWidget);
      await tester.tap(registerBtn, warnIfMissed: true);
      await tester.pumpAndSettle();

      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();

      await tester.ensureVisible(loginUsernameOrEmail);
      await tester.pumpAndSettle();
      await tester.enterText(loginUsernameOrEmail, username);
      await tester.enterText(loginPassword, password);
      await tester.pumpAndSettle();

      expect(loginBtn, findsOneWidget);
      await tester.ensureVisible(loginBtn);
      await tester.pumpAndSettle();
      await tester.tap(loginBtn, warnIfMissed: true);
      await tester.pumpAndSettle();

      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();
      expect(find.text('@$username'), findsNWidgets(2));
    });
  });
}
