import 'package:auto_route/auto_route.dart';
import 'package:clean_architecture/features/auth/presentation/cubits/login/login_cubit.dart';
import 'package:clean_architecture/features/auth/presentation/pages/login/widgets/login_button.dart';
import 'package:clean_architecture/features/auth/presentation/pages/login/widgets/login_form.dart';
import 'package:clean_architecture/features/auth/presentation/widgets/welcome_logo.dart';
import 'package:clean_architecture/shared_ui/cubits/screen_observer/screen_observer_cubit.dart';
import 'package:clean_architecture/shared_ui/ui/base/base_scaffold.dart';
import 'package:clean_architecture/shared_ui/utils/screen_util/screen_util.dart';
import 'package:clean_architecture/shared_ui/utils/ui_helpers.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get_it/get_it.dart';

@RoutePage()
class LoginPage extends HookWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final usernameController = useTextEditingController();
    final passwordController = useTextEditingController();
    final formKey = useMemoized(() => GlobalKey<FormState>());

    return BlocProvider(
      create: (context) => GetIt.I<LoginCubit>(),
      child: BlocBuilder<ScreenObserverCubit, ScreenObserverState>(
        buildWhen: (previous, current) =>
            previous.screenTypeChanges != current.screenTypeChanges,
        builder: (context, state) {
          return BaseScaffold(
            padding: _getHorizontalPadding(),
            showAnnotatedRegion: true,
            body: Column(
              children: [
                UIHelpers.spaceV24,
                const WelcomeLogo(title: "Login"),
                Container(
                  margin: UIHelpers.paddingT12B40,
                  child: Form(
                    key: formKey,
                    child: LoginForm(
                      usernameController: usernameController,
                      passwordController: passwordController,
                    ),
                  ),
                ),
                LoginButton(
                  formKey: formKey,
                  usernameController: usernameController,
                  passwordController: passwordController,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  EdgeInsets _getHorizontalPadding() => EdgeInsets.symmetric(
    horizontal: ScreenUtil.I.getResponsiveValue(
      base: 24,
      screens: {
        {.largeTablet}: 22.widthPart(),
        {.desktop}: kIsWeb ? 32.5.widthPart() : 27.widthPart(),
      },
    ),
  );
}
