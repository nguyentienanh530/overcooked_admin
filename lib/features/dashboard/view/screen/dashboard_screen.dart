import 'package:overcooked_admin/common/widget/responsive.dart';
import 'package:overcooked_admin/core/utils/extensions.dart';
import 'package:overcooked_admin/features/dashboard/cubit/daily_revenue_cubit.dart';
import 'package:overcooked_admin/features/dashboard/cubit/data_chart_revenua.dart';
import 'package:overcooked_admin/features/dashboard/cubit/total_price_yesterday_cubit.dart';
import 'package:overcooked_admin/features/order/bloc/order_bloc.dart';
import 'package:overcooked_admin/features/table/bloc/table_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../home/cubit/home_cubit.dart';
import '../../../home/view/screen/home_screen.dart';
import 'dashboard_view.dart';

class DashboardScreen extends StatelessWidget {
  DashboardScreen({super.key});
  final _key = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => OrderBloc()),
          BlocProvider(create: (context) => TableBloc()),
          BlocProvider(create: (context) => DailyRevenueCubit()),
          BlocProvider(create: (context) => TotalPriceYesterday()),
          BlocProvider(create: (context) => DataChartRevenueCubit())
        ],
        child: Scaffold(
            drawer: SideMenu(
                scafoldKey: _key,
                onPageSelected: (page) {
                  _key.currentState!.closeDrawer();
                  context.read<PageHomeCubit>().pageChanged(page);
                }),
            key: _key,
            appBar: _buildAppbar(context),
            body: const SafeArea(child: DashboardView())));
  }

  _buildAppbar(BuildContext context) => AppBar(
      title: Text('Quản lý', style: context.titleStyleMedium),
      centerTitle: true,
      automaticallyImplyLeading: Responsive.isDesktop(context) ? false : true);
}
