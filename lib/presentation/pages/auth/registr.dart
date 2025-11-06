import 'package:real_project/presentation/view_models/bloc/bloc/get_offerta_bloc.dart';

import '../../../core/constants/app_imports.dart';

class RegistrationForm extends StatefulWidget {
  const RegistrationForm({super.key});
  @override
  _RegistrationFormState createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final passwordController = TextEditingController();
  final rePasswordController = TextEditingController();
  bool isOfferAccepted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteGrey2,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Container(
            height: 0.33.sh,
            decoration: const BoxDecoration(color: Colors.blue),
          ),
          NavigateBefore(),
          Align(
            alignment: Alignment.center,
            child: SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 15.w),
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  color: AppColors.white2,
                  borderRadius: BorderRadius.circular(40.r),
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: 40.h),
                      CustomTextField(
                        iconColor: AppColors.whiteGrey1,
                        color: AppColors.whiteGrey2,
                        textInputType: TextInputType.name,
                        labelText: "Ismingiz",
                        hintText: "Ismingiz",
                        icon: Icons.person,
                        controller: nameController,
                        validator:
                            (value) =>
                                value == null || value.isEmpty
                                    ? "Ismni kiriting"
                                    : null,
                      ),
                      SizedBox(height: 18.h),
                      IntlPhoneField(
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          filled: true,

                          fillColor: AppColors.whiteGrey2,
                          labelText: 'Telefon raqamingiz',
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                        ),
                        initialCountryCode: 'UZ',
                        onChanged: (phone) {
                          phoneNumberController.text = phone.number;
                        },
                      ),
                      SizedBox(height: 18.h),
                      CustomTextField(
                        iconColor: AppColors.whiteGrey1,
                        color: AppColors.whiteGrey2,
                        textInputType: TextInputType.visiblePassword,
                        labelText: "Parol yarating",
                        hintText: "Parol yarating",
                        icon: Icons.lock,
                        controller: passwordController,
                        obscureText: true,
                        validator:
                            (value) =>
                                value == null || value.length < 8
                                    ? "Kamida 8 ta belgidan iborat parol kiriting"
                                    : null,
                      ),
                      SizedBox(height: 18.h),
                      CustomTextField(
                        iconColor: AppColors.whiteGrey1,
                        color: AppColors.whiteGrey2,
                        textInputType: TextInputType.visiblePassword,
                        labelText: "Parolni takrorlang",
                        hintText: "Parolni takrorlang",
                        icon: Icons.lock,
                        controller: rePasswordController,
                        obscureText: true,
                        validator:
                            (value) =>
                                value != passwordController.text
                                    ? "Parollar mos emas"
                                    : null,
                      ),
                      SizedBox(height: 15.h),

                      Row(
                        children: [
                          Checkbox(
                            checkColor: Colors.white,
                            fillColor: MaterialStateProperty.all(
                              AppColors.primaryColor,
                            ),
                            value: isOfferAccepted,
                            onChanged: (value) {
                              setState(() {
                                isOfferAccepted = value!;
                              });
                            },
                          ),
                          GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder:
                                    (_) { 
    BlocProvider.of<GetOffertaBloc>(context).add(GetOffertaForUserEvent());
                                      
                                 return     OfferDialog(
                                      
                                      onAccepted: () {
                                        setState(() {
                                          isOfferAccepted = true;
                                        });
                                        Navigator.pop(context);
                                      },
                                    ); }
                              );
                            },
                            child: Text(
                              "Ommaviy oferta shartlari",
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                color: Colors.blue,
                                fontSize: 16.sp,
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 20.h),
                      BlocConsumer<AuthRegistrBloc, AuthRegistrState>(
                        listener: (context, state) {
                          if (state is AuthRegistrSucces) {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (_) => OtpPage(
                                      otpType: "register",
                                      phone:
                                          "${phoneNumberController.text.trim()}",
                                    ),
                              ),
                              (route) => false,
                            );
                          } else if (state is AuthRegistrError) {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (_) =>
                                        NoconnectionScreen(error: state.error),
                              ),
                              (route) => false,
                            );
                          }
                        },
                        builder: (context, state) {
                          return ElevatedButton(
                            onPressed:
                                state is AuthRegistrLoading
                                    ? null
                                    : () {
                                      if (!_formKey.currentState!.validate())
                                        return;

                                      if (!isOfferAccepted) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              "Iltimos, ommaviy oferta shartlariga rozilik bildiring.",
                                            ),
                                            backgroundColor: Colors.red,
                                            behavior: SnackBarBehavior.floating,
                                          ),
                                        );
                                        return;
                                      }

                                      BlocProvider.of<AuthRegistrBloc>(
                                        context,
                                      ).add(
                                        RegistrEvent(
                                          name: nameController.text.trim(),
                                          phone_number:
                                              "998${phoneNumberController.text.trim()}",
                                          password:
                                              passwordController.text.trim(),
                                        ),
                                      );
                                    },

                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.r),
                              ),
                              minimumSize: Size(0.8.sw, 55.h),
                            ),
                            child:
                                state is AuthRegistrLoading
                                    ? SizedBox(
                                      height: 24.h,
                                      width: 24.h,
                                      child: const CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                              AppColors.white1,
                                            ),
                                        strokeWidth: 3,
                                      ),
                                    )
                                    : Text(
                                      "Ro'yhatdan o'tish",
                                      style: TextStyle(
                                        color: AppColors.white1,
                                        fontSize: 20.sp,
                                      ),
                                    ),
                          );
                        },
                      ),
                      SizedBox(height: 20.h),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
