import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:get_storage/src/storage_impl.dart';
import 'package:horoflutter/business_loc/auth_controller.dart';
import 'package:horoflutter/business_loc/create_user_dto.dart';
import 'package:horoflutter/business_loc/nestjs_connect.dart';
import 'package:horoflutter/uis/login_or_register_page.dart';
import 'package:mockito/mockito.dart';

class _MockNestJsConnect extends NestJsConnect with Mock {
  final bool isRespondingOk;
  _MockNestJsConnect({required super.ip, this.isRespondingOk = true});

  @override
  void handleError(Response res) {}

  @override
  Future<Response<T>> post<T>(String? url, body,
          {String? contentType,
          Map<String, String>? headers,
          Map<String, dynamic>? query,
          Decoder<T>? decoder,
          Progress? uploadProgress}) =>
      isRespondingOk
          ? Future<Response<T>>.value(
              Response<T>(
                statusCode: 201,
                body: {
                  'isOk': true,
                  'data': {
                    'accessToken': 'accessToken',
                    'refreshToken': 'refreshToken'
                  }
                } as T,
              ),
            )
          : Future<Response<T>>.value(
              Response<T>(
                statusCode: 401,
                body: {
                  'isOk': false,
                  'errorCode': 2004,
                  'message': 'Invalid username, email or password',
                } as T,
              ),
            );
}

class _MockAuthController extends AuthController with Mock {
  @override
  GetStorage initStorage() => _MockGetStorage();
}

class _MockGetStorage extends Mock implements GetStorage {
  @override
  Future<void> write(String key, value) => Future<void>.value();
}

void main() {
  final CreateUserDto createUserDto = CreateUserDto(
    username: 'username',
    email: 'email',
    password: 'password',
  );

  setUp(() {
    Get.put<NestJsConnect>(NestJsConnect(ip: 'localhost'));
    Get.put<AuthController>(_MockAuthController());
  });

  group('NestjsConnect: Registration', () {
    testWidgets('enter invalid email and expect error message',
        (WidgetTester tester) async {
      await tester.pumpWidget(GetMaterialApp(home: LoginRegisterPage()));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('RegisterSwitch')));
      await tester.pumpAndSettle();

      await tester.enterText(find.byKey(const Key('emailtec')), 'test@');
      expect(find.text('test@'), findsOneWidget);
      await tester.pumpAndSettle();
      expect(find.text('Email is invalid'), findsOneWidget);
    });

    testWidgets('enter valid email and expect no error message',
        (WidgetTester tester) async {
      await tester.pumpWidget(GetMaterialApp(home: LoginRegisterPage()));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('RegisterSwitch')));
      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(const Key('emailtec')), 'test@test.id');
      expect(find.text('test@test.id'), findsOneWidget);
      await tester.pumpAndSettle();
      expect(find.text('Email is invalid'), findsNothing);
    });

    testWidgets('enter valid email and expect no error message',
        (WidgetTester tester) async {
      await tester.pumpWidget(GetMaterialApp(home: LoginRegisterPage()));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('RegisterSwitch')));
      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(const Key('emailtec')), 'test@test.id');
      expect(find.text('test@test.id'), findsOneWidget);
      await tester.pumpAndSettle();
      expect(find.text('Email is invalid'), findsNothing);
    });

    testWidgets('validate password and confirm password',
        (WidgetTester tester) async {
      await tester.pumpWidget(GetMaterialApp(home: LoginRegisterPage()));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('RegisterSwitch')));
      await tester.pumpAndSettle();

      await tester.enterText(find.byKey(const Key('passwordtec')), '11aa');
      expect(find.text('11aa'), findsOneWidget);
      await tester.pumpAndSettle();
      expect(find.text('Password must be at least 6 characters'), findsOneWidget);

      await tester.enterText(find.byKey(const Key('passwordtec')), '11aa11');
      expect(find.text('11aa11'), findsOneWidget);
      await tester.pumpAndSettle();
      expect(find.text('Password must be numeric only'), findsOneWidget);

      await tester.enterText(find.byKey(const Key('passwordtec')), '110011');
      expect(find.text('110011'), findsOneWidget);
      await tester.pumpAndSettle();
      expect(find.text('Password must be numeric only'), findsNothing);
      expect(find.text('Password must be at least 6 characters'), findsNothing);

      await tester.enterText(find.byKey(const Key('confirmpasswordtec')), '110055');
      expect(find.text('110055'), findsOneWidget);
      await tester.pumpAndSettle();
      expect(find.text('Confirm password does not match'), findsOneWidget);

      await tester.enterText(find.byKey(const Key('confirmpasswordtec')), '110011');
      expect(find.text('110011'),findsNWidgets(2));
      await tester.pumpAndSettle();
      expect(find.text('Confirm password does not match'), findsNothing);
    });
  });

  tearDown(() => Get.reset());
}
