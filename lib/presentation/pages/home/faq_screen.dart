import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:real_project/core/constants/app_imports.dart';
import 'package:real_project/presentation/view_models/bloc/bloc/get_questions_bloc.dart';

class FaqScreen extends StatefulWidget {
  const FaqScreen({super.key});

  @override
  State<FaqScreen> createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {
  @override
  void initState() {
    super.initState();
    // Savollarni olish
    BlocProvider.of<GetQuestionsBloc>(context).add(GetAllQuestionsForUserEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white2,
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppColors.white2, size: 24.sp),
        backgroundColor: AppColors.primaryColor,

        title: const Text("Savol-Javoblar",style: TextStyle(color: AppColors.white2),),
        centerTitle: true,
      ),
      body: BlocConsumer<GetQuestionsBloc, GetQuestionsState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is GetQuestionsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is GetQuestionsError) {
            return Center(
              child: Text(
                state.message,
                style: TextStyle(color: AppColors.red, fontSize: 14.sp),
              ),
            );
          } else if (state is GetQuestionsSuccess) {
            final questions = state.questions;

            if (questions.isEmpty) {
              return const Center(
                child: Text("Hozircha savollar mavjud emas"),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: questions.length,
              itemBuilder: (context, index) {
                final faq = questions[index];
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  child: ExpansionTile(
                    tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    title: Text(
                      faq.question,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        color: AppColors.whiteGrey1.withValues(alpha: 0.1),
                        child: Text(
                          faq.answer,
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: AppColors.black,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
