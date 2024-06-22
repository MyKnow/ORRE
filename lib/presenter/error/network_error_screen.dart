import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:orre/widget/text/text_widget.dart';

class NetworkErrorScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/error_orre.gif',
              width: 200.sw,
              height: 200.sw,
            ),
            SizedBox(
              height: 16.h,
            ),
            TextWidget('네트워크 정보를 불러오는데 실패했습니다.'),
            ElevatedButton(
              onPressed: () {
                context.go('/stompCheck');
              },
              child: TextWidget('다시 시도하기'),
            ),
          ],
        ),
      ),
    );
  }
}
