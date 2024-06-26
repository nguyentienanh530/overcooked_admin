part of '../screen/dashboard_view.dart';

extension on DashboardViewState {
  Widget get _leftInfo => Card(
      elevation: 10,
      child: AutofillGroup(
          child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildOrderHistory(),
                    const SizedBox(height: 8),
                    _buildUserAccount(),
                    const SizedBox(height: 8),
                    _buildFoods(),
                    const SizedBox(height: 8),
                    _buildTableNumber()
                  ]))));

  Widget _buildUserAccount() {
    return BlocProvider(
        create: (context) => UserBloc()..add(UsersFetched()),
        child: BlocBuilder<UserBloc, GenericBlocState<UserModel>>(
            builder: (context, state) => switch (state.status) {
                  Status.loading => const LoadingScreen(),
                  Status.empty => const ItemChildOfOrderInfo(
                      icon: Icons.person, title: 'Tổng người dùng', value: '0'),
                  Status.failure =>
                    Text('Failure', style: context.textStyleSmall),
                  Status.success => ItemChildOfOrderInfo(
                      icon: Icons.person,
                      title: 'Tổng người dùng',
                      value: state.datas!.isEmpty
                          ? '0'
                          : state.datas!.length.toString())
                }));
  }

  Widget _buildFoods() {
    return BlocProvider(
        create: (context) =>
            FoodBloc()..add(const FoodsFetched(isShowFood: true)),
        child: BlocBuilder<FoodBloc, GenericBlocState<Food>>(
            builder: (context, state) {
          return (switch (state.status) {
            Status.loading => const LoadingScreen(),
            Status.empty => const ItemChildOfOrderInfo(
                icon: Icons.food_bank_rounded,
                title: 'Số lượng món ăn',
                value: '0'),
            Status.failure => Center(child: Text(state.error!)),
            Status.success => ItemChildOfOrderInfo(
                icon: Icons.food_bank_rounded,
                title: 'Số lượng món ăn',
                value:
                    state.datas!.isEmpty ? '0' : state.datas!.length.toString())
          });
        }));
  }

  Widget _buildTableNumber() {
    var tableState = context.watch<TableBloc>().state;
    return (switch (tableState.status) {
      Status.loading => const LoadingScreen(),
      Status.failure => Center(child: Text(tableState.error ?? '')),
      Status.success => ItemChildOfOrderInfo(
          icon: Icons.dining_rounded,
          title: 'Số lượng bàn ăn',
          value: tableState.datas!.isEmpty
              ? '0'
              : tableState.datas!.length.toString()),
      Status.empty => const ItemChildOfOrderInfo(
          icon: Icons.dining_rounded, title: 'Số lượng bàn ăn', value: '0')
    });
  }

  Widget _buildOrderHistory() {
    return BlocProvider(
        create: (context) => OrderBloc()..add(OrdersHistoryFecthed()),
        child: BlocBuilder<OrderBloc, GenericBlocState<Orders>>(
            builder: (context, state) => switch (state.status) {
                  Status.loading => const LoadingScreen(),
                  Status.empty => const ItemChildOfOrderInfo(
                      icon: Icons.restaurant_menu_rounded,
                      title: 'Tổng đơn hoàn thành',
                      value: '0'),
                  Status.failure =>
                    Text('Failure', style: context.textStyleSmall),
                  Status.success => ItemChildOfOrderInfo(
                      icon: Icons.restaurant_menu_rounded,
                      title: 'Tổng đơn hoàn thành',
                      value: state.datas!.isEmpty
                          ? '0'
                          : state.datas!.length.toString())
                }));
  }
}
