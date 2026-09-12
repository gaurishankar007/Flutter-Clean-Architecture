import 'package:clean_architecture/features/auth/presentation/cubits/login/login_cubit.dart';
import 'package:clean_architecture/routing/navigation_client.dart';
import 'package:clean_architecture/routing/routes.gr.dart';
import 'package:clean_architecture/shared_ui/ui/base/buttons/primary_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';

class LoginButton extends StatelessWidget {
  const LoginButton({
    super.key,
    required this.formKey,
    required this.usernameController,
    required this.passwordController,
  });
  final GlobalKey<FormState> formKey;
  final TextEditingController usernameController;
  final TextEditingController passwordController;

  @override
  Widget build(BuildContext context) {
    return PrimaryButton(
      loadableButton: true,
      expandWidth: true,
      onTap: () async {
        if (!formKey.currentState!.validate()) {
          return;
        }
        FocusManager.instance.primaryFocus?.unfocus();

        final success = await context.read<LoginCubit>().fakeLogin(
          username: usernameController.text,
          password: passwordController.text,
        );
        if (success) {
          await NavigationUtil.I.replaceAllRoute(const HomeRoute());
        }
      },
      text: 'LOGIN',
    );
  }
}
