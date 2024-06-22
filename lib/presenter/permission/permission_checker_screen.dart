import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:orre/widget/popup/awesome_dialog_widget.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../services/debug_services.dart';
import '../../widget/button/big_button_widget.dart';
import '../../widget/text/text_widget.dart';

class PermissionCheckerScreen extends ConsumerStatefulWidget {
  @override
  _PermissionCheckerScreenState createState() =>
      _PermissionCheckerScreenState();
}

class _PermissionCheckerScreenState
    extends ConsumerState<PermissionCheckerScreen> {
  @override
  void initState() {
    super.initState();
    _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    // Combining location and notification permission requests
    Map<Permission, PermissionStatus> statuses = await [
      Permission.location,
      Permission.notification,
    ].request();

    // 권한 별 언어 변환 List (한국어)
    List<String> permissionNames = [
      "위치",
      // "알림",
    ];

    // if (!allPermissionsGranted) {
    if (statuses[Permission.location]!.isDenied ||
        statuses[Permission.location]!.isPermanentlyDenied) {
      List<String> deniedPermissions = [];

      if (statuses[Permission.location]!.isDenied ||
          statuses[Permission.location]!.isPermanentlyDenied) {
        deniedPermissions.add(permissionNames[0]);
      }

      // if (statuses[Permission.notification]!.isDenied ||
      //     statuses[Permission.notification]!.isPermanentlyDenied) {
      //   deniedPermissions.add(permissionNames[1]);
      // }

      printd("Denied permissions: $deniedPermissions");

      _showPermissionDeniedDialog(context, deniedPermissions);
      return;
    }

    // If all permissions granted, proceed to the next page
    printd("All permissions granted, navigating to initial page.");
    context.go('/initial');
  }

  void _showPermissionDeniedDialog(
      BuildContext context, List<String> deniedPermissions) {
    AwesomeDialogWidget.showCustomDialog(
      context: context,
      title: "권한 허용 필요",
      desc:
          "${deniedPermissions.join(', ')} 권한이 허용되지 않았습니다.\n모든 권한을 허용해야 다음 단계로 진행할 수 있습니다.",
      dialogType: DialogType.warning,
      btnText: "확인",
      onPressed: () {
        openAppSettings();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 50),
            TextWidget(
              "오리",
              fontSize: 30.sp,
              fontWeight: FontWeight.bold,
              color: Color(0xFFFFBF52),
            ),
            SizedBox(height: 20),
            TextWidget(
              "오리의 이용을 위해\n아래 권한을 허용해 주세요.",
              textAlign: TextAlign.center,
              fontSize: 16.sp,
              color: Colors.black,
              maxLines: 5,
            ),
            SizedBox(height: 40),
            Divider(thickness: 1, color: Colors.grey[300]),
            SizedBox(height: 20),
            PermissionItem(
              icon: Icons.location_on,
              title: "위치 (필수)",
              description: "현재 위치를 확인하고 맞춤형 서비스를 제공하기 위해 위치 권한이 필요합니다.",
            ),
            PermissionItem(
              icon: Icons.notifications,
              title: "알림 (선택)",
              description: "웨이팅 변동사항을 확인하기 위해 알림 권한이 필요합니다.",
            ),
            if (Platform.isAndroid)
              PermissionItem(
                icon: Icons.phone,
                title: "전화 (선택)",
                description: "안드로이드 기기에서 가게로 전화를 걸기 위해선, 전화 권한이 필요합니다.",
              ),
            PermissionItem(
              icon: Icons.camera_alt_rounded,
              title: "카메라 (선택)",
              description: "QR 코드를 스캔하기 위해선, 카메라 권한이 필요합니다.",
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: BigButtonWidget(
                text: "권한 설정하고 시작하기",
                onPressed: () async {
                  await _requestPermissions();
                },
                textColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PermissionItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  PermissionItem(
      {required this.icon, required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(icon, size: 40, color: Colors.grey),
          SizedBox(width: 20),
          Container(
            width: 1.sw - 100,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextWidget(title, fontSize: 18, fontWeight: FontWeight.bold),
                SizedBox(height: 5),
                TextWidget(
                  description,
                  fontSize: 14.sp,
                  color: Colors.grey,
                  maxLines: 5,
                  textAlign: TextAlign.left,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
