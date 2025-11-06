import 'package:real_project/core/constants/app_imports.dart';
import 'package:real_project/core/utils/value_notifier.dart';
import 'package:real_project/data/models/category_model.dart';
import 'package:real_project/presentation/view_models/bloc/get_categories/get_categories_bloc.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  String? selectedCategory;
  String? selectedDay;
  String? selectedMonth;
  String? selectedYear;

  TextEditingController amountController = TextEditingController();
  String day = "";
  String month = "";
  String year = "";

  @override
  void initState() {
    super.initState();
    BlocProvider.of<GetCategoriesBloc>(context).add(GetCategoriesListEvent());
  }

  List<CategoryModel> categories = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white2,
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(height: 30.h),

              /// Kategoriya va summa
              Row(
                children: [
                  BlocConsumer<GetCategoriesBloc, GetCategoriesState>(
                    listener: (context, state) {
                      if (state is GetCategoriesSuccess) {
                        categories = state.categories;
                      }
                    },
                    builder: (context, state) {
                      return Flexible(
                        flex: 7,
                        child:
                            state is GetCategoriesSuccess
                                ? DropdownButtonFormField<String>(
                                  value: selectedCategory,

                                  decoration: const InputDecoration(
                                    hintText: 'Kategoriyani tanlang',
                                    border: UnderlineInputBorder(),
                                  ),
                                  items:
                                      [
                                        state.categories[1].categoryTypeDisplay
                                            .toString(),
                                      ].map((category) {
                                        return DropdownMenuItem(
                                          value: category,
                                          child: Text(category),
                                        );
                                      }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      selectedCategory = value;
                                    });
                                  },
                                )
                                : const SizedBox(),
                      );
                    },
                  ),
                  const SizedBox(width: 10),
                  Flexible(
                    flex: 3,
                    child: TextField(
                      controller: amountController,
                      decoration: const InputDecoration(
                        hintText: '0 \$',
                        border: UnderlineInputBorder(),
                      ),
                      keyboardType: TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'^\d+\.?\d{0,2}'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(height: 40.h),

              /// Sana tanlash
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  DropdownButton<String>(
                    value: selectedDay,
                    hint: const Text("Kun"),
                    items:
                        List.generate(31, (index) => "${index + 1}")
                            .map(
                              (day) => DropdownMenuItem(
                                value: day,
                                child: Text(day),
                              ),
                            )
                            .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedDay = value;
                      });
                    },
                  ),

                  DropdownButton<String>(
                    value: selectedMonth,
                    hint: const Text("Oy"),
                    items:
                        [
                              'Yan',
                              'Fev',
                              'Mar',
                              'Apr',
                              'May',
                              'Iyun',
                              'Iyul',
                              'Avg',
                              'Sen',
                              'Okt',
                              'Noy',
                              'Dek',
                            ]
                            .map(
                              (month) => DropdownMenuItem(
                                value: month,
                                child: Text(month),
                              ),
                            )
                            .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedMonth = value;
                      });
                    },
                  ),

                  DropdownButton<String>(
                    value: selectedYear,
                    hint: const Text("Yil"),
                    items:
                        List.generate(
                          4,
                          (index) => "${DateTime.now().year - index}",
                        ).map((year) {
                          return DropdownMenuItem(
                            value: year,
                            child: Text(year),
                          );
                        }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedYear = value;
                      });
                    },
                  ),
                ],
              ),

              SizedBox(height: 50.h),

              CustomButton(
                onPressed: () {
                  final formattedDate =
                      selectedDay != null &&
                              selectedMonth != null &&
                              selectedYear != null
                          ? '${selectedYear!}-${_getMonthNumber(selectedMonth!)}-${selectedDay!.padLeft(2, '0')}'
                          : '';

                  BlocProvider.of<CreateExpenseBloc>(context).add(
                    GenerateExpenseEvent(
                      amount: amountController.text,
                      date: formattedDate,
                      category: categories.last.id,
                    ),
                  );

                  Navigator.pop(context);
                },

                title: "Qo'shish",
                bacColor: AppColors.red,
                textColor: AppColors.white2,
                fontWeight: FontWeight.w500,
                fontSize: 12.sp,
                borderRadius: 20.r,
                width: 180.w,
                height: 36.h,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getMonthNumber(String monthName) {
    const months = {
      'Yan': '01',
      'Fev': '02',
      'Mar': '03',
      'Apr': '04',
      'May': '05',
      'Iyun': '06',
      'Iyul': '07',
      'Avg': '08',
      'Sen': '09',
      'Okt': '10',
      'Noy': '11',
      'Dek': '12',
    };
    return months[monthName] ?? '00';
  }
}
