import 'package:real_project/core/constants/app_imports.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String? loginErrorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(route: SplashScreen()),
      backgroundColor: AppColors.whiteGrey2,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Container(
            height: 0.22.sh,
            decoration: BoxDecoration(color: AppColors.primaryColor),
          ),

          Padding(
            padding: EdgeInsets.only(top: 100.h),
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15),
              padding: EdgeInsets.all(24.r),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30.r),
              ),
              child: Form(
                key: _formKey,
                child: BlocConsumer<AuthLoginBloc, AuthLoginState>(
                  listener: (context, state) {
                    if (state is AuthLoginSucces) {
                      loginErrorMessage = null;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => OtpPage(
                                phone: phoneNumberController.text.trim(),
                                otpType: "login",
                              ),
                        ),
                      );
                    } else if (state is AuthLoginError) {
                      setState(() {
                        loginErrorMessage = " Telefon raqam yoki Parol noto'g'ri";
                      });
                      _formKey.currentState!.validate();
                    }
                  },
                  builder: (context, state) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: 40.h),
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
                          validator: (value) {
                            if (value?.number.isEmpty ?? true) {
                              return "Telefon raqamini kiriting";
                            }
                            if (value!.number.length <= 9) {
                              return "Telefon raqamini 9 ta belgidan iborat bo'lishi shart";
                            }
                            return null;
                          },
                          onChanged: (phone) {
                            phoneNumberController.text = phone.number;
                          },
                        ),
                        SizedBox(height: 18.h),
                        CustomTextField(
                          iconColor: AppColors.whiteGrey1,
                          color: AppColors.whiteGrey2,
                          textInputType: TextInputType.visiblePassword,
                          labelText: "Parolingiz",
                          hintText: "Parolingiz",
                          icon: Icons.lock,
                          controller: passwordController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Parolni kiriting";
                            } else if (value.length < 8) {
                              return "Parol 8 ta belgidan iborat bo'lishi shart";
                            } else if (loginErrorMessage != null) {
                              return loginErrorMessage;
                            }
                            return null;
                          },

                          obscureText: true,
                        ),
                        SizedBox(height: 10.h),

                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ResetPasswordEmail(),
                                ),
                              );
                            },
                            child: Text(
                              "Parolni unutdingizmi?",
                              style: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w400,
                                color: AppColors.primaryColor,
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 30.h),
                        ElevatedButton(
                          onPressed:
                              state is AuthLoginLoading
                                  ? null
                                  : () {
                                    setState(() {
                                      loginErrorMessage = null;
                                    });
                                    if (_formKey.currentState!.validate()) {
                                      BlocProvider.of<AuthLoginBloc>(
                                        context,
                                      ).add(
                                        LoginEvent(
                                          phone_number:
                                              "998${phoneNumberController.text.trim()}",
                                          password:
                                              passwordController.text.trim(),
                                        ),
                                      );
                                    }
                                  },

                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.r),
                            ),
                            minimumSize: Size(0.8.sw, 55.h),
                          ),
                          child:
                              state is AuthLoginLoading
                                  ? SizedBox(
                                    height: 24.h,
                                    width: 24.h,
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        AppColors.white1,
                                      ),
                                      strokeWidth: 3,
                                    ),
                                  )
                                  : Text(
                                    "Hisobga kirish",
                                    style: TextStyle(
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.white1,
                                    ),
                                  ),
                        ),

                        SizedBox(height: 20.h),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
