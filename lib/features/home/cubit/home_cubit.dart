import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:overcooked_admin/features/dashboard/view/screen/dashboard_screen.dart';

class PageHomeCubit extends Cubit<Widget> {
  PageHomeCubit() : super(DashboardScreen());

  void pageChanged(Widget widget) => emit(widget);
}
