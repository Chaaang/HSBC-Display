import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:hsbc_display/features/auth/data/api_auth_repo.dart';
import 'package:hsbc_display/features/auth/presentation/cubit/auth_state.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';
import 'features/auth/presentation/screens/login_screen.dart';
import 'features/event/data/api_event_repo.dart';
import 'features/event/presentation/cubit/event_cubit.dart';
import 'features/event/presentation/screens/event_screen.dart';
import 'features/home/data/api_home_repo.dart';
import 'features/home/presentation/cubit/sign_cubit.dart';
import 'features/shared/components/loading_screen.dart';
import 'features/shared/theme.dart/light_mode.dart';
import 'features/signatures/data/api_signature_repo.dart';
import 'features/signatures/presentation/cubit/signature_cubit.dart';

class MyApp extends StatelessWidget {
  final _authCubit = ApiAuthRepo();
  final _signCubit = ApiHomeRepo();
  final _eventCubit = ApiEventRepo();
  final _signatureCubit = ApiSignatureRepo();
  MyApp({super.key});

  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthCubit(authRepo: _authCubit)..checkAuth(),
        ),

        BlocProvider(create: (context) => EventCubit(eventRepo: _eventCubit)),
        BlocProvider(create: (context) => SignCubit(signRepo: _signCubit)),
        BlocProvider(
          create: (context) => SignatureCubit(signatureRepo: _signatureCubit),
        ),
      ],
      child: MaterialApp(
        theme: lightMode,
        title: 'HSBC',
        home: BlocConsumer<AuthCubit, AuthState>(
          builder: (context, authstate) {
            if (authstate is AuthInitial || authstate is AuthLoading) {
              return LoadingScreen();
            }
            if (authstate is UnAuthenticated) {
              return LoginScreen();
            }

            if (authstate is Authenticated) {
              return EventScreen();
            }

            return Center(child: Text('Error'));
          },
          listener: (context, authstate) {
            if (authstate is AuthError) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(authstate.error)));
            }
          },
        ),
      ),
    );
  }
}
