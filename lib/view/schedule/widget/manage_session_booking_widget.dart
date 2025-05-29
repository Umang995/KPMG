import 'package:dreamcast/utils/size_utils.dart';
import 'package:dreamcast/view/schedule/controller/session_controller.dart';
import 'package:dreamcast/view/speakers/controller/speakersController.dart';
import 'package:dreamcast/widgets/button/common_material_button.dart';
import 'package:dreamcast/widgets/textview/customTextView.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../api_repository/app_url.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_decoration.dart';
import '../../../theme/ui_helper.dart';
import '../../../utils/dialog_constant.dart';
import '../../../utils/image_constant.dart';
import '../../../widgets/button/custom_icon_button.dart';
import '../../../widgets/dialog/custom_animated_dialog_widget.dart';
import '../../../widgets/dialog/custom_dialog_widget.dart';
import '../model/scheduleModel.dart';

class ManageSessionBookingWidget extends GetView<SessionController> {
  final SessionsData session;
  final bool isDetail;

  ManageSessionBookingWidget({
    super.key,
    required this.session,
    this.isDetail = false,
  });

  @override
  Widget build(BuildContext context) {
    print("@@is availableSeats: ${session.availableSeats}");
    print("@@is SeatBooked: ${session.isSeatBooked}");
    print("@@is Revoke: ${session.isRevoke}");
    print("@@is canbook: ${session.canBook}");

    //its have a booking features
    final bool allowSeatBooking = [
      BookingType.admin_assign.name,
      BookingType.admin_approval.name,
      BookingType.auto_approval.name,
    ].contains(session.isBooking);

    final bool isCanBookASeat = session.canBook == true;
    final bool isSeatBooked = session.isSeatBooked == 1;
    final bool isSeatAvailable = (session.availableSeats ?? 0) > 0;
    final bool isRevokeAllowed = session.isRevoke == true;
    final bool isSeatFull = !isSeatAvailable;
    final bool shouldDisableButton = ((!isRevokeAllowed && isSeatBooked) ||
        isSeatFull ||
        isCanBookASeat == false);

    final bool canWatchLive =
        session.isOnlineStream == 1 && !controller.isStreaming.value;

    final bool isAdminAssign =
        session.isBooking == BookingType.admin_assign.name;

    Widget buildBookingButton(BuildContext context) {
      if (!allowSeatBooking) return const SizedBox();

      // Hide button if it's admin assigned and not already booked
      if (isAdminAssign && !isSeatBooked) return const SizedBox();

      final String buttonText = () {
        if (isSeatBooked) {
          if (isRevokeAllowed) return "Revoke";
          return "Booked";
        } else if (isSeatAvailable) {
          return "Book Now";
        } else {
          return "Seats Full";
        }
      }();

      final Color buttonColor = isSeatBooked
          ? (isRevokeAllowed ? white : colorLightGray)
          : (shouldDisableButton
              ? colorPrimary.withOpacity(0.5)
              : colorPrimary);

      final Color textColor = isSeatBooked ? colorPrimary : white;

      final Color borderColor =
          (isSeatBooked && isRevokeAllowed) ? colorPrimary : Colors.transparent;

      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!isSeatFull && !isSeatBooked)
            CustomTextView(
              text: "${session.availableSeats} Seats Available",
              fontSize: 12,
            ),
          CommonMaterialButton(
            textSize: 16,
            isWrap: !isDetail,
            radius: 6,
            borderColor: borderColor,
            borderWidth: (borderColor == colorPrimary) ? 1 : 0,
            textColor: textColor,
            color: buttonColor,
            height: isDetail ? 50 : 35.h,
            onPressed: () {
              if (!controller.authManager.isLogin()) {
                DialogConstantHelper.showLoginDialog(
                    Get.context!, controller.authManager);
                return;
              }
              if (!isRevokeAllowed && isSeatBooked) {
                UiHelper.showFailureMsg(context, "You can't revoke the seat.");
                return;
              }

              if ((!isSeatAvailable && !isSeatBooked) || !isCanBookASeat)
                return;

              showActionDialog(
                context: context,
                content: isSeatBooked
                    ? "Are you sure you want to Revoke a seat from ${session.auditorium?.text ?? ""}?"
                    : "Are you sure you want to Book a seat in ${session.auditorium?.text ?? ""}?",
                body: {"webinar_id": session.id ?? ""},
                title: "",
                logo: isSeatBooked
                    ? ImageConstant.icRevokeRequest
                    : ImageConstant.ic_question_confirm,
                confirmButtonText: isSeatBooked ? "Revoke" : "Book",
              );
            },
            text: buttonText,
          ),
        ],
      );
    }

    Widget buildWatchLiveButton() {
      return CustomIconButton(
        height: 50,
        width: double.infinity,
        child: Container(
          decoration: BoxDecoration(
            color: colorPrimary,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomTextView(
                text: "watch_live".tr,
                color: white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              const SizedBox(width: 8),
              Icon(Icons.play_arrow, color: white, size: 18),
            ],
          ),
        ),
        onTap: () {
          controller.isStreaming(!controller.isStreaming.value);
        },
      );
    }

    if (isDetail) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: AppDecoration.outlineBlack,
        child: isSeatBooked || !allowSeatBooking
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (allowSeatBooking)
                    Expanded(child: buildBookingButton(context)),
                  if (canWatchLive && (!allowSeatBooking || isSeatBooked)) ...[
                    const SizedBox(width: 12),
                    Expanded(child: buildWatchLiveButton()),
                  ],
                ],
              )
            : buildBookingButton(context),
      );
    } else {
      return SizedBox(child: buildBookingButton(context));
    }
  }

  void showActionDialog({
    required BuildContext context,
    required String content,
    required Map<String, dynamic> body,
    required String title,
    required String logo,
    required String confirmButtonText,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomDialogWidget(
          logo: logo,
          title: session.isSeatBooked == 1
              ? "Revoke"
              : (session.availableSeats != null && session.availableSeats! > 0)
                  ? "Please Confirm"
                  : "Seats Full",
          description: content,
          buttonAction: "Yes, $confirmButtonText",
          buttonCancel: "cancel".tr,
          onCancelTap: () {},
          onActionTap: () async {
            var result = await controller.actionAgainstSessionBooking(
              requestBody: body,
              url: session.isSeatBooked == 1
                  ? AppUrl.revokeSessionSeat
                  : AppUrl.bookSessionSeat,
            );
            if (result["status"]) {
              await Get.dialog(
                barrierDismissible: false,
                CustomAnimatedDialogWidget(
                  title: "",
                  logo: ImageConstant.icSuccessAnimated,
                  description: result['message'],
                  buttonAction: "okay".tr,
                  buttonCancel: "cancel".tr,
                  isHideCancelBtn: true,
                  onCancelTap: () {},
                  onActionTap: () async {
                    if (isDetail) {
                      await controller.getSessionDetail(requestBody: {
                        "id": controller.mSessionDetailBody.value.id
                      });
                      controller.mSessionDetailBody.refresh();
                    }
                    controller.refreshTheTab();
                    if (Get.isRegistered<SpeakersDetailController>()) {
                      Get.find<SpeakersDetailController>()
                          .refreshTheSessionList();
                    }
                  },
                ),
              );
            } else {
              UiHelper.showFailureMsg(context, result["message"]);
            }
          },
        );
      },
    );
  }
}
