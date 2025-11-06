import 'package:real_project/presentation/view_models/bloc/bloc/bloc/dashboard_help_bloc.dart';
import 'package:real_project/presentation/view_models/bloc/bloc/get_offerta_bloc.dart';
import 'package:real_project/presentation/view_models/bloc/bloc/get_questions_bloc.dart';
import 'package:real_project/presentation/view_models/bloc/get_categories/get_categories_bloc.dart';
import 'package:real_project/presentation/view_models/bloc/set_new_password/set_new_password_bloc.dart';

import 'core/constants/app_imports.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String? token;

  @override
  void initState() {
    super.initState();
    getToken();
  }

  Future<void> getToken() async {
    token = SharedPreferencesHelper().getString("access");
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthLoginBloc()),
        BlocProvider(create: (context) => AuthRegistrBloc()),
        BlocProvider(create: (context) => ResetPasswordBloc()),
        BlocProvider(create: (context) => ComfirmSmscodeBloc()),
        BlocProvider(create: (context) => GetProfileBloc()),
        BlocProvider(create: (context) => GetIncomeListBloc()),
        BlocProvider(create: (context) => CreateIncomeBloc()),
        BlocProvider(create: (context) => GetExpenseBloc()),
        BlocProvider(create: (context) => CreateExpenseBloc()),
        BlocProvider(create: (context) => VerifyOtpBloc()),
        BlocProvider(create: (context) => SetNewPasswordBloc()),
        BlocProvider(create: (context) => GetCategoriesBloc()),
        BlocProvider(create: (context) => GetOffertaBloc()),
        BlocProvider(create: (context) => GetQuestionsBloc()),
        BlocProvider(create: (context) => DashboardHelpBloc()),
      ],
      child: MaterialApp(
        navigatorKey: navigatorKey,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),

        debugShowCheckedModeBanner: false,
        home: token == null ? SplashScreen() : SetPassword(),
      ),
    );
  }
}
