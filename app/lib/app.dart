import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class MoneyApp extends StatelessWidget {
  const MoneyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'app.title'.tr(),
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      home: Scaffold(
        body: Center(
          child: Text('app.title'.tr()),
        ),
      ),
    );
  }
}
