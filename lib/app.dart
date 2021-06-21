import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:subagent/src/provider/board_provider.dart';
import 'package:subagent/src/provider/court_provider.dart';
import 'package:subagent/src/provider/employee_provider.dart';
import 'package:subagent/src/provider/reply_provider.dart';
import 'package:subagent/src/provider/subagent_image_provider.dart';
import 'package:subagent/src/provider/subagent_provider.dart';
import 'package:subagent/src/provider/user_provider.dart';
import 'package:subagent/src/root_page.dart';
import 'package:subagent/src/utils/store.dart' as store;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  UserProvider _userProvider;
  CourtProvider _courtProvider;

  Future<bool> init() async {

    await store.initPref();

    _userProvider = UserProvider();

    await _userProvider.init();

    _courtProvider = CourtProvider();
    await _courtProvider.init();

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SubAgentProvider()),
        ChangeNotifierProvider(create: (_) => BoardProvider()),
        ChangeNotifierProvider(create: (_) => SubAgentImageProvider()),
        ChangeNotifierProvider(create: (_) => ReplyProvider()),
        ChangeNotifierProvider(create: (_) => _userProvider),
        ChangeNotifierProvider(create: (_) => EmployeeProvider()),
        ChangeNotifierProvider(create: (_) => _courtProvider),
      ],
      child: MaterialApp(
        title: 'Flutter',
        theme: ThemeData(
          primaryColor: Colors.white,
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: SafeArea(
          child: FutureBuilder(
            future: init(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return RootPage();
              } else {
                return CupertinoActivityIndicator();
              }
            },
          ),
        ),
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale('en', 'US'),
          const Locale('ko', 'KO'),
        ],
      ),
    );
  }
}
