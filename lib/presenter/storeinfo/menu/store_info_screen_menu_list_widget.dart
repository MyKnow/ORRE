import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:orre/model/menu_info_model.dart';
import 'package:orre/presenter/storeinfo/menu/store_info_screen_menu_tilie_widget.dart';
import 'package:orre/services/debug_services.dart';
import 'package:orre/widget/text/text_widget.dart';

import '../../../../model/store_info_model.dart';

class StoreMenuListWidget extends ConsumerWidget {
  final StoreDetailInfo storeDetailInfo;
  final String category;

  const StoreMenuListWidget({
    super.key,
    required this.storeDetailInfo,
    required this.category,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    printd("StoreMenuListWidget build");
    // printd("category: $category");
    // storeDetailInfo.menuInfo.forEach((element) {
    //   printd("element: ${element.menuCode}");
    // });
    final menuList =
        MenuInfo.getMenuByCategory(storeDetailInfo.menuInfo, category);
    printd("카테고리: $category");
    if (category == '추천 메뉴') {
      final recommendMenuList = storeDetailInfo.getRecommendedMenus();
      printd("추천 메뉴");
      return SingleChildScrollView(
        child: Column(
          children: List.generate(recommendMenuList.length, (index) {
            return Column(
              children: <Widget>[
                StoreMenuTileWidget(menu: recommendMenuList[index]), // 메뉴 타일 위젯
                if (index !=
                    recommendMenuList.length - 1) // 마지막 항목에는 구분선을 넣지 않습니다
                  Divider(
                    color: const Color(0xFFDFDFDF),
                    thickness: 2.r,
                    endIndent: 10.r,
                    indent: 10.r,
                  ),
              ],
            );
          }),
        ),
      );
    } else if (menuList.isEmpty) {
      return Padding(
        padding: EdgeInsets.only(left: 16.r),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextWidget(
              '메뉴 정보가 없습니다.',
              textAlign: TextAlign.start,
              fontSize: 16.sp.r,
              color: const Color(0xFFDFDFDF),
            )
          ],
        ),
      );
    } else {
      return SingleChildScrollView(
        child: Column(
          children: List.generate(menuList.length, (index) {
            return Column(
              children: <Widget>[
                StoreMenuTileWidget(menu: menuList[index]), // 메뉴 타일 위젯
                if (index != menuList.length - 1) // 마지막 항목에는 구분선을 넣지 않습니다
                  Divider(
                    color: const Color(0xFFDFDFDF),
                    thickness: 2.r,
                    endIndent: 10.r,
                    indent: 10.r,
                  ),
              ],
            );
          }),
        ),
      );
    }
  }
}
