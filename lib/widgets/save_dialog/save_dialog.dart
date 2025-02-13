import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:momsori/getx_controller/file_name_controller.dart';
import 'package:momsori/widgets/save_dialog/add_category.dart';
import 'package:momsori/getx_controller/record_list_controller.dart';
import 'package:momsori/getx_controller/record_sound_controller.dart';
import 'package:momsori/my_keep_keyboard_popup_munu/src/keep_keyboard_popup_menu_item.dart';
import 'package:momsori/my_keep_keyboard_popup_munu/src/with_keep_keyboard_popup_menu.dart';
import 'package:momsori/screens/main_screen.dart';

Widget saveDialog(BuildContext saveContext) {
  final controller = Get.put<RecordListController>(RecordListController());
  final fileNameController = Get.put<FileNameController>(FileNameController());
  final rs = Get.put<RecordSoundController>(RecordSoundController());

  if (Get.arguments != null) {
    controller.changeCategory(Get.arguments);
  }
  controller.callCategoryList();
  controller.update();

  return Dialog(
    backgroundColor: Colors.transparent,
    insetPadding: EdgeInsets.only(left: 15, right: 15),
    child: Container(
      width: double.infinity,
      height: 200.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                width: double.infinity,
                height: 50.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10)),
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color.fromARGB(220, 255, 149, 149),
                        Color.fromARGB(130, 255, 154, 97),
                      ]),
                  //color: Colors.black,
                ),
              ),
              Positioned(
                top: 12.h,
                left: 10.h,
                child: Text(
                  '녹음 파일 저장',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 15.sp,
                  ),
                ),
              )
            ],
          ),
          SizedBox(
            height: 23.h,
          ),
          Container(
            margin: EdgeInsets.fromLTRB(20.w, 0.h, 20.w, 0.h),
            child: Column(
              children: [
                TextFormField(
                  onChanged: (nextText) {
                    fileNameController.changeFileName(nextText);
                  },
                  decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: Color.fromARGB(255, 252, 214, 214), width: 3),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: Color.fromARGB(255, 252, 214, 214), width: 3),
                    ),
                  ),
                  cursorColor: Color(0xffa9a9),
                ),
                SizedBox(
                  height: 20.h,
                ),
                // Text(
                //   '카테고리',
                //   style: TextStyle(
                //     fontWeight: FontWeight.w500,
                //     fontSize: 12.sp,
                //   ),
                // ),

                GetBuilder<RecordListController>(
                  init: controller,
                  builder: (_) => WithKeepKeyboardPopupMenu(
                    childBuilder: (context, openPopup) => InkWell(
                      onTap: openPopup,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            margin: EdgeInsets.only(right: 10.w),
                            //width: 40.w,
                            height: 16.h,
                            decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      color: Color.fromARGB(255, 249, 217, 228),
                                      width: 1)),
                            ),
                            child: Text(
                              '${controller.category}' + " ▼",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  fontSize: 13.5.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Color.fromARGB(255, 66, 66, 66)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    backgroundBuilder: (context, child) => Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          margin: EdgeInsets.only(right: 5),
                          child: Material(
                            elevation: 10,
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.white,
                            shadowColor: Colors.grey,
                            child: child,
                          ),
                        ),
                      ],
                    ),
                    menuBuilder: (context, closePopup) => Container(
                      padding: EdgeInsets.only(bottom: 10, left: 10, right: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.white,
                      ),
                      height: 170.h,
                      width: 120.w,
                      child: ListView.builder(
                        itemCount: _.categories.length,
                        itemBuilder: (context, index) {
                          return KeepKeyboardPopupMenuItem(
                            height: 30.h,
                            child: index == _.categories.length - 1
                                ? InkWell(
                                    onTap: () async {
                                      closePopup();
                                      Get.appUpdate();
                                      Get.back();
                                      Get.dialog(
                                        addCategory(context),
                                      ).then((value) => _.update()).then(
                                          (value) => Get.dialog(
                                              saveDialog(saveContext)));
                                    },
                                    child: Center(
                                      child: Text(
                                        //+카테고리추가
                                        '${_.categories[index]}',
                                        style: TextStyle(
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  )
                                : InkWell(
                                    onTap: () {
                                      controller.changeIndex(index);
                                      controller.changeCategory(
                                          controller.categories[index]);
                                      closePopup();
                                    },
                                    child: Container(
                                      height: 30.h,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          controller.categoryIndex == index
                                              ? SvgPicture.asset(
                                                  'assets/icons/체크박스선택.svg')
                                              : SvgPicture.asset(
                                                  'assets/icons/체크박스선택x.svg'),
                                          SizedBox(
                                            width: 6.w,
                                          ),
                                          Text(
                                            '${_.categories[index]}',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 12.sp,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 25.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: () {
                        controller.changeCategory(controller.category);
                        Get.back();
                      },
                      child: Text(
                        '취소',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14.sp,
                          color: Color(0xFFFFA9A9),
                        ),
                      ),
                    ),
                    Text(
                      '|',
                      style: TextStyle(
                        color: Color(0xffdadada),
                        fontSize: 18.sp,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        rs.saveFile(fileNameController.fileName.value,
                            controller.category);
                        print("폴더" + (controller.category).toString());
                        print("파일: " +
                            (fileNameController.fileName.value).toString());
                        Get.back();
                        controller.changeCategory(controller.category);
                        Get.snackbar(
                          '저장되었습니다!',
                          '탭하면 보관함으로 이동',
                          snackPosition: SnackPosition.BOTTOM,
                          onTap: (_) {
                            Get.off(
                              () => MainScreen(),
                              arguments: 2,
                            );
                          },
                          backgroundColor: Colors.grey.withOpacity(0.5),
                          overlayBlur: 3.0,
                        );
                      },
                      child: Text(
                        '저장',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14.sp,
                          color: Color(0xFFFFA9A9),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    ),
  );
}
// GetBuilder<RecordListController>(
//   init: controller,
//   builder: (_) => WithKeepKeyboardPopupMenu(
//     childBuilder: (context, openPopup) => InkWell(
//       onTap: openPopup,
//       child: Text(
//         '${controller.category}',
//         style: TextStyle(
//           fontSize: 12.sp,
//           fontWeight: FontWeight.w500,
//         ),
//       ),
//     ),
//     backgroundBuilder: (context, child) => Material(
//       elevation: 20,
//       borderRadius: BorderRadius.circular(30),
//       color: Colors.white,
//       shadowColor: Colors.grey,
//       child: child,
//     ),
//     menuBuilder: (context, closePopup) => Container(
//       padding: EdgeInsets.only(bottom: 10, left: 10, right: 10),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(30),
//         color: Colors.white,
//       ),
//       height: 170.h,
//       width: 120.w,
//       child: ListView.builder(
//         itemCount: _.categories.length,
//         itemBuilder: (context, index) {
//           return KeepKeyboardPopupMenuItem(
//             height: 30.h,
//             child: index == _.categories.length - 1
//                 ? InkWell(
//                     onTap: () {
//                       closePopup();
//                       Get.dialog(
//                         addCategory(context),
//                       );
//                     },
//                     child: Center(
//                       child: Text(
//                         '${_.categories[index]}',
//                         style: TextStyle(
//                           fontSize: 12.sp,
//                           fontWeight: FontWeight.w500,
//                           color: Colors.black,
//                         ),
//                       ),
//                     ),
//                   )
//                 : InkWell(
//                     onTap: () {
//                       controller.changeIndex(index);
//                       controller.changeCategory(
//                           controller.categories[index]);
//                       closePopup();
//                     },
//                     child: Container(
//                       height: 30.h,
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         children: [
//                           controller.categoryIndex == index
//                               ? SvgPicture.asset(
//                                   'assets/icons/체크박스선택.svg')
//                               : SvgPicture.asset(
//                                   'assets/icons/체크박스선택x.svg'),
//                           SizedBox(
//                             width: 6.w,
//                           ),
//                           Text(
//                             '${_.categories[index]}',
//                             style: TextStyle(
//                               fontWeight: FontWeight.w500,
//                               fontSize: 12.sp,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//           );
//         },
//       ),
//     ),
//   ),
// ),
