import 'package:auto_route/auto_route.dart';
import 'package:clean_architecture/core/constants/app_colors.dart';
import 'package:clean_architecture/core/data/models/app_error_details.dart';
import 'package:clean_architecture/features/dashboard/presentation/cubits/app_error/app_error_cubit.dart';
import 'package:clean_architecture/shared_ui/cubits/base/base_cubit.dart';
import 'package:clean_architecture/shared_ui/ui/base/app_bar/base_app_bar.dart';
import 'package:clean_architecture/shared_ui/ui/base/base_scaffold.dart';
import 'package:clean_architecture/shared_ui/ui/base/text/base_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

@RoutePage()
class AppErrorPage extends StatelessWidget {
  const AppErrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetIt.I<AppErrorCubit>()..fetchErrors(),
      child: const AppErrorView(),
    );
  }
}

class AppErrorView extends StatelessWidget {
  const AppErrorView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: BaseAppBar(
        title: 'App Error Logs',
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep, color: AppColors.error),
            onPressed: () => context.read<AppErrorCubit>().clearAllErrors(),
          ),
        ],
      ),
      body: BlocBuilder<AppErrorCubit, AppErrorState>(
        builder: (context, state) {
          if (state.status == StateStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.errors.isEmpty) {
            return const Center(child: BaseText('No errors recorded.'));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: state.errors.length,
            separatorBuilder: (context, index) => const Divider(),
            itemBuilder: (context, index) {
              final error = state.errors[index];
              return ListTile(
                title: BaseText(
                  error.title,
                  fontWeight: FontWeight.bold,
                  color: AppColors.error,
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BaseText(error.message ?? 'No message'),
                    const SizedBox(height: 4),
                    BaseText('At: ${error.createdAt}', color: Colors.grey),
                  ],
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () =>
                      context.read<AppErrorCubit>().removeError(error.id),
                ),
                onTap: () => _showErrorDetails(context, error),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _showErrorDetails(
    BuildContext context,
    AppErrorDetails error,
  ) async {
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(error.title),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Error:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(error.error),
              const SizedBox(height: 16),
              const Text(
                'Stack Trace:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(error.stackTrace ?? 'No stack trace'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
