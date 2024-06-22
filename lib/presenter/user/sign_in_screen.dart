import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:orre/provider/userinfo/user_info_state_notifier.dart';
import 'package:orre/widget/appbar/static_app_bar_widget.dart';
import 'package:orre/widget/background/waveform_background_widget.dart';
import 'package:orre/widget/button/text_button_widget.dart';
import 'package:go_router/go_router.dart';
import 'package:orre/widget/popup/awesome_dialog_widget.dart';

import 'package:orre/widget/text_field/text_input_widget.dart';
import 'package:orre/widget/button/big_button_widget.dart';

import 'package:orre/model/user_info_model.dart';

import '../../services/debug_services.dart';

final isObscureProvider = StateProvider<bool>((ref) => true);
final formKeyProvider = Provider((ref) => GlobalKey<FormState>());

class SignInScreen extends ConsumerWidget {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();

  final FocusNode phoneNumberFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    printd("\n\n SignInScreen 진입");
    final isObscure = ref.watch(isObscureProvider);
    final formKey = ref.watch(formKeyProvider);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: WaveformBackgroundWidget(
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: PreferredSize(
            preferredSize: Size(0.25.sh, 1.sw),
            child: StaticAppBarWidget(
                title: '로그인',
                leading: IconButton(
                  icon: Icon(Icons.arrow_back_ios_new_rounded,
                      color: Colors.black),
                  onPressed: () {
                    context.pop();
                  },
                )),
          ),
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      SizedBox(height: 16 * 5),
                      // 전화번호 입력창
                      TextInputWidget(
                        prefixIcon: Icon(Icons.phone),
                        hintText: '전화번호를 입력해주세요.',
                        isObscure: false,
                        type: TextInputType.number,
                        ref: ref,
                        autofillHints: [AutofillHints.telephoneNumber],
                        controller: phoneNumberController,
                        inputFormatters: [
                          PhoneInputFormatter(),
                        ],
                        minLength: 11,
                        maxLength: 11,

                        focusNode: phoneNumberFocusNode, // Passing FocusNode
                      ),
                      SizedBox(height: 16),
                      // 비밀먼호 입력창
                      TextInputWidget(
                        hintText: '비밀번호를 입력해주세요.',
                        isObscure: isObscure,
                        type: TextInputType.emailAddress,
                        ref: ref,
                        controller: passwordController,
                        autofillHints: [AutofillHints.password],
                        prefixIcon: Icon(Icons.lock),
                        suffixIcon: IconButton(
                          onPressed: () {
                            final currentState = ref.watch(isObscureProvider);
                            ref.read(isObscureProvider.notifier).state =
                                !currentState;
                          },
                          icon: Icon((isObscure)
                              ? Icons.visibility
                              : Icons.visibility_off),
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'[0-9a-zA-Z!@#$%^&*]'))
                        ],

                        focusNode: passwordFocusNode, // Passing FocusNode
                        minLength: 8,
                        maxLength: 20,
                      ),
                      SizedBox(height: 32),
                      // 하단 "회원 가입하기" 버튼
                      BigButtonWidget(
                          text: '로그인 하기',
                          textColor: Colors.white,
                          onPressed: () async {
                            if (formKey.currentState == null) return;

                            final FormState formState =
                                formKey.currentState as FormState;
                            if (!formState.validate()) {
                              return;
                            }
                            FocusScope.of(context).unfocus();
                            final signInUserInfo = SignInInfo(
                              password: passwordController.text,
                              phoneNumber: phoneNumberController.text
                                  .replaceAll(RegExp(r'[^0-9]'), ''),
                            );
                            printd(signInUserInfo.password);
                            printd(signInUserInfo.phoneNumber);
                            final success = await ref
                                .read(userInfoProvider.notifier)
                                .requestSignIn(signInUserInfo);

                            if (success != null) {
                              context.go("/locationCheck");
                            } else {
                              AwesomeDialogWidget.showErrorDialog(
                                context: context,
                                title: '로그인 실패',
                                desc: '전화번호 또는 비밀번호를 확인해주세요.',
                              );
                            }
                          }),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // 하단 "비밀번호 찾기" 버튼
                          TextButtonWidget(
                            text: '비밀번호 찾기',
                            fontSize: 16.sp,
                            textColor: Color(0xFFDFDFDF),
                            onPressed: () {
                              context.push('/user/resetpassword');
                            },
                          ),
                          SizedBox(width: 10), // 여기서 간격을 조절해요
                          Container(
                            width: 1,
                            height: 18,
                            color: Color(0xFFDFDFDF),
                          ),
                          SizedBox(width: 10), // 여기서 간격을 조절해요
                          TextButtonWidget(
                            text: '회원가입',
                            fontSize: 16.sp,
                            textColor: Color(0xFFFFBF52),
                            onPressed: () {
                              FocusScope.of(context).unfocus();
                              context.push('/user/agreement');
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class TestWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Test Widget"),
      ),
    );
  }
}
