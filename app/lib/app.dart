import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

final class MoneyApp extends StatelessWidget {
  const MoneyApp({required this.home, super.key});

  final Widget home;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'app.title'.tr(),
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      home: home,
    );
  }
}
