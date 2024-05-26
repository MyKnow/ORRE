import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:orre/model/menu_info_model.dart';
import 'package:orre/presenter/storeinfo/menu/store_info_screen_menu_tilie_widget.dart';
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
    // print("category: $category");
    // storeDetailInfo.menuInfo.forEach((element) {
    //   printd("element: ${element.menuCode}");
    // });
    final menuList =
        MenuInfo.getMenuByCategory(storeDetailInfo.menuInfo, category);
    if (menuList.isEmpty) {
      return Padding(
        padding: EdgeInsets.only(left: 16.r),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextWidget(
              '메뉴 정보가 없습니다.',
              textAlign: TextAlign.start,
              fontSize: 16.r,
              color: const Color(0xFFDFDFDF),
            )
          ],
        ),
      );
    } else if (category == '추천 메뉴') {
      return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: menuList.length,
        itemBuilder: (context, index) {
          final recommendMenuList =
              MenuInfo.getRecommendedMenu(storeDetailInfo.menuInfo);
          final menu = recommendMenuList[index];
          return StoreMenuTileWidget(menu: menu);
        },
        separatorBuilder: (context, index) => Divider(
          color: const Color(0xFFDFDFDF),
          thickness: 2.r,
          endIndent: 10.r,
          indent: 10.r,
        ),
      );
    } else {
      return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: menuList.length,
        itemBuilder: (context, index) {
          final menu = menuList[index];
          return StoreMenuTileWidget(menu: menu);
        },
        separatorBuilder: (context, index) => Divider(
          color: const Color(0xFFDFDFDF),
          thickness: 2.r,
          endIndent: 10.r,
          indent: 10.r,
        ),
      );
    }
  }
}
