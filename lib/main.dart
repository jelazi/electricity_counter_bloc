import 'dart:io';

import 'package:desktop_window/desktop_window.dart';
import 'package:electricity_counter/models/entry.dart';
import 'package:electricity_counter/models/user.dart';
import 'package:electricity_counter/repositories/invoices_repository.dart';
import 'package:electricity_counter/repositories/users_repository.dart';
import 'package:electricity_counter/services/my_logger.dart';
import 'package:electricity_counter/view/desktop/pages/home_page.dart';
import 'package:f_logs/f_logs.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'blogs/bloc_export.dart';
import 'firebase_options.dart';
import 'models/invoice.dart';
import 'repositories/settings_repository.dart';
import 'view/mobile/pages/home_page.dart';
import 'package:path_provider/path_provider.dart' as pathProvider;
import 'package:easy_localization/easy_localization.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await EasyLocalization.ensureInitialized();
  bool isDesktop = Platform.isWindows || Platform.isMacOS || Platform.isLinux;
  if (isDesktop) {
    await DesktopWindow.setMinWindowSize(const Size(800, 600));
  }
  MyLogger();
  // FLog.debug(text: 'start App');
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
    EasyLocalization(
      startLocale: const Locale('cs'),
      supportedLocales: const [Locale('cs'), Locale('en')],
      path: 'assets/lang',
      fallbackLocale: const Locale('cs'),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => NotificationBloc(
                usersRepository: usersRepository,
                invoicesRepository: invoicesRepository),
          ),
          BlocProvider(
              create: ((context) => InvoicesBloc(
                    isDesktop: isDesktop,
                    usersRepository: usersRepository,
                    settingsRepository: settingsRepository,
                    invoicesRepository: invoicesRepository,
                  ))),
          BlocProvider(
            create: (context) => UsersBloc(
                isDesktop: isDesktop,
                usersRepository: usersRepository,
                settingsRepository: settingsRepository),
          ),
        ],
        child: BlocBuilder<UsersBloc, UsersState>(
          builder: (context, state) {
            return MaterialApp(
              title: 'Flutter Demo',
              theme: ThemeData(
                primarySwatch: Colors.blue,
              ),
              debugShowCheckedModeBanner: false,
              supportedLocales: context.supportedLocales,
              localizationsDelegates: context.localizationDelegates,
              locale: context.locale,
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
        ),
      ),
    ),
  );
}

Future<void> initHiveFunction() async {
  Directory directory = await pathProvider.getApplicationDocumentsDirectory();
  Hive.init(directory.path);
  Hive.registerAdapter(EntryAdapter());
  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(InvoiceAdapter());
}
