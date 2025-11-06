import 'package:real_project/core/utils/value_notifier.dart';

import '../../../../core/constants/app_imports.dart';

class ExpenseHistoryScreen extends StatefulWidget {
  const ExpenseHistoryScreen({super.key});

  @override
  State<ExpenseHistoryScreen> createState() => _ExpenseHistoryScreenState();
}

class _ExpenseHistoryScreenState extends State<ExpenseHistoryScreen> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<GetExpenseBloc>(context).add(GetExpenseListEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<GetExpenseBloc, GetExpenseState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is GetExpenseSuccessState) {
            return ListView.builder(
              itemCount: state.expenseList.length,
              itemBuilder: (context, index) {
                final expense = state.expenseList[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(
                      expense.categoryName,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    trailing: Text(
                      expense.amount.toString(),
                      style: TextStyle(
                        color: AppColors.red,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    leading: Text(
                      expense.date,
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
          } else if (state is GetExpenseErrorState) {
            return Center(child: Text("${state.message}"));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
