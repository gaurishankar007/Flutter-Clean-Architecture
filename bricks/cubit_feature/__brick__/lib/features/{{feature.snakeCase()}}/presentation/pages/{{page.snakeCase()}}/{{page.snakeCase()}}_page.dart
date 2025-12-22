import 'package:auto_route/auto_route.dart';
import 'package:clean_architecture/shared_ui/ui/base/app_bar/base_app_bar.dart';
import 'package:clean_architecture/shared_ui/ui/base/base_scaffold.dart';
import 'package:flutter/material.dart';

@RoutePage()
class {{page.pascalCase()}}Page extends StatelessWidget {
  const {{page.pascalCase()}}Page({super.key});

  @override
  Widget build(BuildContext context) {
    return const BaseScaffold(
      appBar: BaseAppBar(title: "{{page.pascalCase()}}"),
      body: SafeArea(
        child: Column(
          children: [],
        ),
      ),
    );
  }
}