import 'package:overcooked_admin/features/auth/bloc/auth_bloc.dart';
import 'package:overcooked_admin/features/category/bloc/category_bloc.dart';
import 'package:overcooked_admin/features/home/cubit/home_cubit.dart';
import 'package:overcooked_admin/features/order/bloc/order_bloc.dart';
import 'package:overcooked_admin/features/print/bloc/print_bloc.dart';
import 'package:overcooked_admin/features/print/cubit/is_use_print_cubit.dart';
import 'package:overcooked_admin/features/table/bloc/table_bloc.dart';
import 'package:overcooked_admin/features/user/bloc/user_bloc.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../features/food/bloc/food_bloc.dart';
import '../features/print/cubit/print_cubit.dart';
import '../features/search_food/cubit/text_search_cubit.dart';
import 'app_view.dart';

class MainApp extends StatelessWidget {
  const MainApp({
    required AuthenticationRepository authenticationRepository,
    super.key,
  }) : _authenticationRepository = authenticationRepository;

  final AuthenticationRepository _authenticationRepository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
        value: _authenticationRepository,
        child: MultiBlocProvider(providers: [
          BlocProvider(
              create: (_) => AuthBloc(
                  authenticationRepository: _authenticationRepository)),
          BlocProvider(create: (_) => PageHomeCubit()),
          BlocProvider(create: (_) => OrderBloc()),
          BlocProvider(create: (_) => FoodBloc()),
          BlocProvider(create: (_) => TableBloc()),
          BlocProvider(create: (_) => UserBloc()),
          BlocProvider(create: (_) => TextSearchCubit()),
          BlocProvider(create: (_) => IsUsePrintCubit()),
          BlocProvider(create: (_) => PrintCubit()),
          BlocProvider(create: (_) => PrintBloc()),
          BlocProvider(create: (_) => CategoryBloc()),
        ], child: const AppView()));
  }
}
