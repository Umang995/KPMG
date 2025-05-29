import '../../../../../theme/app_colors.dart';
import '../../../../../utils/pref_utils.dart';
import '../../../../../widgets/textview/customTextView.dart';
import '../../../../../widgets/button/custom_icon_button.dart';
import '../../../../../widgets/dash_widget.dart';
import '../../../controller/angelHallController.dart';
import 'package:dreamcast/theme/ui_helper.dart';
import 'package:dreamcast/utils/size_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';



class AngelHallBody extends GetView<AngelHallController> {
  dynamic session;
  int index;
  int size;
  AngelHallBody(
      {super.key,
        required this.session,
        required this.index,
        required this.size});
  var isViewExpend = false.obs;
  var statusColor = [const Color(0xffCF148A), const Color(0xff4658A7)];
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.width,
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  index != 0
                      ? DashWidget(
                    length: 35.v,
                    dashLength: 3,
                    dashColor: colorGray,
                    direction: Axis.vertical,
                  )
                      : SizedBox(
                    height: 35.v,
                  ),
                  CustomTextView(
                    text: UiHelper.displayDateFormat(
                        date: session.startDatetime.toString(),
                        timezone: PrefUtils.getTimezone()),
                    textAlign: TextAlign.center,
                    fontWeight: FontWeight.normal,
                    fontSize: 12.h,
                    color: colorSecondary,
                  ),
                  CustomTextView(
                    text: UiHelper.displayTimeFormat(
                        date: session.startDatetime.toString(),
                        timezone: PrefUtils.getTimezone()),
                    textAlign: TextAlign.center,
                    fontWeight: FontWeight.normal,
                    fontSize: 12.h,
                    color: colorGray,
                  ),
                  const Icon(
                    Icons.radio_button_unchecked,
                    color: borderColor,
                  ),
                  index != size - 1
                      ? DashWidget(
                    dashLength: 3,
                    length: 35.v,
                    dashColor: colorGray,
                    direction: Axis.vertical,
                  )
                      : SizedBox(
                    height: 35.v,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            width: 6.v,
          ),
          Expanded(
            flex: 20,
            child: Container(
              padding: EdgeInsets.all(14.v),
              margin: EdgeInsets.only(bottom: 16.v),
              decoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border.all(
                      color: statusColor[index%2==0?0:1],
                      width: 1),
                  borderRadius: const BorderRadius.all(Radius.circular(10))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextView(
                      text: session?.label ?? "",
                      textAlign: TextAlign.start,
                      color: colorSecondary,
                      fontWeight: FontWeight.normal,
                      fontSize: 17),
                  SizedBox(
                    height: 24.v,
                  ),
                  CustomIconButton(
                    onTap: () async {
                      await controller.getAngelHallDetail(
                          session.id);
                    },
                    height: 50,
                    width: context.width,
                    decoration: BoxDecoration(
                        color: colorPrimary,
                        border: Border.all(color: colorPrimary, width: 1),
                        borderRadius: BorderRadius.circular(10)),
                    child: Center(
                      child: AutoCustomTextView(
                        text: "book_tour".tr,
                        fontSize: 16,
                        maxLines: 1,
                        color: white,
                      ),
                    ),
                  )

                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
