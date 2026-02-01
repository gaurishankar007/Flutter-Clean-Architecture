import 'package:bloc_test/bloc_test.dart';
import 'package:clean_architecture/core/data/states/data_state.dart';
import 'package:clean_architecture/core/domain/entities/user.dart';
import 'package:clean_architecture/core/domain/entities/user_data.dart';
import 'package:clean_architecture/features/auth/domain/entities/authentication.dart';
import 'package:clean_architecture/features/auth/domain/repositories/session_repository.dart';
import 'package:clean_architecture/features/auth/domain/use_cases/log_out_use_case.dart';
import 'package:clean_architecture/features/auth/domain/use_cases/login_use_case.dart';
import 'package:clean_architecture/features/auth/domain/use_cases/save_user_data_use_case.dart';
import 'package:clean_architecture/features/auth/domain/use_cases/set_session_use_case.dart';
import 'package:clean_architecture/features/auth/presentation/cubits/login/login_cubit.dart';
import 'package:clean_architecture/features/auth/presentation/cubits/login/login_cubit_use_cases.dart';
import 'package:clean_architecture/features/auth/presentation/pages/login/login_page.dart';
import 'package:clean_architecture/routing/helper/navigation_client.dart';
import 'package:clean_architecture/shared_ui/cubits/screen_observer/screen_observer_cubit.dart';
import 'package:clean_architecture/shared_ui/themes/theme.dart';
import 'package:clean_architecture/shared_ui/utils/screen_util/screen_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:patrol/patrol.dart';

import '../../../../../testing/mocks/client_mocks.dart';
import '../../../../../testing/mocks/external/router_mocks.dart';
import '../../../../../testing/mocks/repository_mocks.dart';
import '../../../../../testing/mocks/use_case_mocks.dart';

final locator = GetIt.I;

class MockScreenObserverCubit extends MockCubit<ScreenObserverState>
    implements ScreenObserverCubit {}

void main() {
  late MockLoginUseCase mockLoginUseCase;
  late MockSaveUserDataUseCase mockSaveUserDataUseCase;
  late MockSetSessionUseCase mockSetSessionUseCase;
  late MockLogOutUseCase mockLogOutUseCase;
  late MockSessionRepository mockSessionRepository;
  late MockNavigationClient mockNavigationClient;
  late UserData userData;

  setUpAll(() {
    userData = const UserData(
      user: User(
        id: 0,
        firstName: '',
        lastName: '',
        username: '',
        email: '',
        isActive: true,
      ),
      accessToken: '',
      refreshToken: '',
    );
    registerFallbackValue(const Authentication(username: '', password: ''));
    registerFallbackValue(const MockPageRouteInfo());
    registerFallbackValue(userData);
  });

  setUp(() {
    mockLoginUseCase = MockLoginUseCase();
    mockSaveUserDataUseCase = MockSaveUserDataUseCase();
    mockSetSessionUseCase = MockSetSessionUseCase();
    mockLogOutUseCase = MockLogOutUseCase();
    mockSessionRepository = MockSessionRepository();
    mockNavigationClient = MockNavigationClient();

    locator
      ..registerSingleton<LoginUseCase>(mockLoginUseCase)
      ..registerSingleton<SaveUserDataUseCase>(mockSaveUserDataUseCase)
      ..registerSingleton<SetSessionUseCase>(mockSetSessionUseCase)
      ..registerSingleton<LogOutUseCase>(mockLogOutUseCase)
      ..registerSingleton<SessionRepository>(mockSessionRepository)
      ..registerSingleton<NavigationClient>(mockNavigationClient)
      ..registerFactory<LoginCubit>(
        () => LoginCubit(
          useCases: LoginCubitUseCases(
            login: mockLoginUseCase,
            saveUserData: mockSaveUserDataUseCase,
            setSession: mockSetSessionUseCase,
            logOut: mockLogOutUseCase,
          ),
        ),
      );

    const screenDetails = ScreenDetails(
      logicalSize: Size(1920, 1280),
      physicalSize: Size(1920, 1280),
      devicePixelRatio: 1,
    );
    ScreenUtil.I.configureScreen(screenDetails);
  });

  tearDown(locator.reset);

  patrolWidgetTest('Login and save the user credential', ($) async {
    // Arrange
    when(() => mockLogOutUseCase.call()).thenAnswer((_) {});
    when(() => mockSetSessionUseCase.call(userData)).thenAnswer((_) {});
    when(
      () => mockNavigationClient.replaceAllRoute(any()),
    ).thenAnswer((_) async {});
    when(
      () => mockLoginUseCase.call(any()),
    ).thenAnswer((_) async => SuccessState(data: userData));
    when(
      () => mockSaveUserDataUseCase.call(any()),
    ).thenAnswer((_) async => const SuccessState(data: true));

    final mockScreenObserverCubit = MockScreenObserverCubit();
    when(
      () => mockScreenObserverCubit.state,
    ).thenReturn(ScreenObserverState.initial());
    when(
      () => mockScreenObserverCubit.stream,
    ).thenAnswer((_) => const Stream.empty());

    // Set the test binding surface size to match our screen configuration
    // This ensures widgets are within the render tree bounds
    await $.tester.binding.setSurfaceSize(const Size(1920, 1280));

    // Render the view
    await $.pumpWidget(
      BlocProvider<ScreenObserverCubit>(
        create: (_) => mockScreenObserverCubit,
        child: MaterialApp(theme: lightTheme, home: const LoginPage()),
      ),
    );

    // Wait for all animations and async operations to complete
    await $.pumpAndSettle();

    // Expect the login button to be enabled initially
    expect($('Login'), findsOne);
    expect($('Password'), findsOne);
    final enabledButton = $(
      ElevatedButton,
    ).which<ElevatedButton>((b) => b.enabled);
    expect(enabledButton, findsOneWidget);
    expect($(TextButton), findsOneWidget);
    expect($(InkWell).$(Icons.visibility_off_outlined), findsOneWidget);

    // Enter email and password using standard Flutter test approach
    // This avoids hit-testability issues with Patrol's enterText in scrollable content
    await $.tester.enterText(find.byType(TextField).first, 'username');
    await $.tester.enterText(find.byType(TextField).at(1), 'password');
    await $.pumpAndSettle();

    // Tap checkbox using standard Flutter test
    await $.tester.tap(find.byType(Checkbox));
    await $.pumpAndSettle();

    // Use the login cubit's login method in the login_button widget.
    // Tap the login button using standard Flutter test
    await $.tester.tap(find.byType(ElevatedButton));
    await $.pumpAndSettle();

    verify(() => mockLoginUseCase.call(any())).called(1);
    verify(() => mockSetSessionUseCase.call(any())).called(1);
    verify(() => mockNavigationClient.replaceAllRoute(any())).called(1);
  });
}
