import 'package:real_project/core/utils/value_notifier.dart';

import '../../../core/constants/app_imports.dart';

class IncomeHistoryScreen extends StatefulWidget {
  const IncomeHistoryScreen({super.key});

  @override
  State<IncomeHistoryScreen> createState() => _IncomeHistoryScreenState();
}

class _IncomeHistoryScreenState extends State<IncomeHistoryScreen> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<GetIncomeListBloc>(context).add(GetIncomeEvent());
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<GetIncomeListBloc, GetIncomeListState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is GetIncomeListSuccess) {

            return ListView.builder(
              itemCount: state.incomeList.length,
              itemBuilder: (context, index) {
                final income = state.incomeList[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(
                      income.categoryName,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    trailing: Text(
                      income.amount.toString(),
                      style: TextStyle(
                        color: AppColors.primaryColor,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    leading: Text(
                      income.date,
                      style: TextStyle(
                        color: AppColors.black,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                );
              },
            );
          } else if (state is GetIncomeListError) {
            return Center(child: Text("${state.message}"));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
