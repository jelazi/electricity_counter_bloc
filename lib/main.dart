import 'dart:io';

import 'package:desktop_window/desktop_window.dart';
import 'package:electricity_counter/blogs/notification_bloc/notification_bloc.dart';
import 'package:electricity_counter/models/entry.dart';
import 'package:electricity_counter/models/user.dart';
import 'package:electricity_counter/repositories/invoices_repository.dart';
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
  if (Platform.isWindows || Platform.isMacOS) {
    await DesktopWindow.setMinWindowSize(const Size(800, 600));
  }
  MyLogger();
  FLog.debug(text: 'start App');
  await initHiveFunction();
  SettingsRepository settingsRepository = SettingsRepository();
  await settingsRepository.initBoxes();
  UsersRepository usersRepository =
      UsersRepository(settingsRepository: settingsRepository);
  await usersRepository.initListUsers();
  InvoicesRepository invoicesRepository =
      InvoicesRepository(settingsRepository: settingsRepository);
  await invoicesRepository.initInvoices();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => LocaleCubit(),
        ),
        BlocProvider(
          create: (context) =>
              NotificationBloc(usersRepository: usersRepository),
        ),
        BlocProvider(
            create: ((context) => InvoicesBloc(
                  usersRepository: usersRepository,
                  settingsRepository: settingsRepository,
                  invoicesRepository: invoicesRepository,
                ))),
        BlocProvider(
          create: (context) => UsersBloc(
              usersRepository: usersRepository,
              settingsRepository: settingsRepository),
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
                    if (supportedLocale.languageCode == locale!.languageCode &&
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
  );
}

Future<void> initHiveFunction() async {
  Directory directory = await pathProvider.getApplicationDocumentsDirectory();
  Hive.init(directory.path);
  Hive.registerAdapter(EntryAdapter());
  Hive.registerAdapter(UserAdapter());
}
