import 'dart:io';

import 'package:electricity_counter/blogs/notification_bloc/notification_bloc.dart';
import 'package:electricity_counter/repositories/users_repository.dart';
import 'package:electricity_counter/services/my_logger.dart';
import 'package:electricity_counter/view/desktop/pages/home_page.dart';
import 'package:f_logs/f_logs.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'blogs/bloc_export.dart';
import 'localization/app_localizations_setup.dart';
import 'repositories/settings_repository.dart';
import 'view/mobile/pages/home_page.dart';
import 'package:path_provider/path_provider.dart' as pathProvider;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MyLogger();
  FLog.debug(text: 'start App');
  Directory directory = await pathProvider.getApplicationDocumentsDirectory();
  Hive.init(directory.path);
  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => SettingsRepository(),
        ),
        RepositoryProvider(
          create: (context) => UsersRepository(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => NotificationBloc(
                usersRepository: context.read<UsersRepository>()),
          ),
          BlocProvider(
            create: (context) =>
                UsersBloc(usersRepository: context.read<UsersRepository>()),
          ),
          BlocProvider(
            create: (context) => LocaleCubit(),
          ),
        ],
        child: BlocBuilder<UsersBloc, UsersState>(
          builder: (context, state) {
            return BlocBuilder<LocaleCubit, LocaleState>(
              buildWhen: (previousState, currentState) =>
                  previousState != currentState,
              builder: (_, localeState) {
                return MaterialApp(
                  title: 'Flutter Demo',
                  theme: ThemeData(
                    primarySwatch: Colors.blue,
                  ),
                  debugShowCheckedModeBanner: false,
                  supportedLocales: AppLocalizationsSetup.supportedLocales,
                  localizationsDelegates:
                      AppLocalizationsSetup.localizationsDelegates,
                  localeResolutionCallback: ((locale, supportedLocales) {
                    for (Locale supportedLocale in supportedLocales) {
                      if (supportedLocale.languageCode ==
                              locale!.languageCode &&
                          supportedLocale.countryCode == locale.countryCode) {
                        return supportedLocale;
                      }
                    }
                    return supportedLocales.last;
                  }),
                  locale: localeState.locale,
                  home: BlocListener<NotificationBloc, NotificationState>(
                    listener: (context, state) {
                      if (state.message.isNotEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(state.message.last)));
                      }
                    },
                    child: Container(
                      child: Platform.isAndroid || Platform.isIOS
                          ? const HomePageMobile()
                          : HomePageDesktop(),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    ),
  );
}
