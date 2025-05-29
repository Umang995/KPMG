import 'package:dreamcast/theme/app_colors.dart';
import 'package:dreamcast/utils/image_constant.dart';
import 'package:dreamcast/utils/size_utils.dart';
import 'package:dreamcast/view/skeletonView/ListDocumentSkeleton.dart';
import 'package:dreamcast/widgets/app_bar/appbar_leading_image.dart';
import 'package:dreamcast/widgets/app_bar/custom_app_bar.dart';
import 'package:dreamcast/widgets/textview/customTextView.dart';
import 'package:dreamcast/widgets/toolbarTitle.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../widgets/loading.dart';
import '../../dashboard/showLoadingPage.dart';
import '../controller/faq_controller.dart';
import '../model/sos_model.dart';

class SOSInfoPag extends GetView<SOSFaqController> {
  SOSInfoPag({Key? key}) : super(key: key);

  static const routeName = "/FaqListPage";

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  ExpansionTileController expansionTileController = ExpansionTileController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        toolbarHeight: 0,
        elevation: 0,
        centerTitle: false,
        title: ToolbarTitle(
          title: "faq".tr,
          color: Colors.black,
        ),
        shape:
            const Border(bottom: BorderSide(color: borderColor, width: 1)),
        backgroundColor: white,
        iconTheme: IconThemeData(color: colorSecondary),
      ),
      body: Container(
        padding: const EdgeInsets.only(top: 12, left: 15, right: 15),
        child: GetX<SOSFaqController>(
          builder: (controller) {
            return Stack(
              children: [
                RefreshIndicator(
                  key: _refreshIndicatorKey,
                  color: colorLightGray,
                  backgroundColor: colorPrimary,
                  strokeWidth: 1.0,
                  triggerMode: RefreshIndicatorTriggerMode.anywhere,
                  onRefresh: () async {
                    return Future.delayed(
                      const Duration(seconds: 1),
                      () {
                        controller.getSOSList(isRefresh: true);
                      },
                    );
                  },
                  child: buildListView(context),
                ),
                // when the first load function is running
                _progressEmptyWidget()
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _progressEmptyWidget() {
    return Center(
      child: controller.loading.value
          ? const Loading()
          : !controller.isFirstLoading.value && controller.sosList.isEmpty
              ? ShowLoadingPage(refreshIndicatorKey: _refreshIndicatorKey)
              : const SizedBox(),
    );
  }

  Widget buildListView(BuildContext context) {
    return Skeletonizer(
        enabled: controller.isFirstLoading.value,
        child: controller.isFirstLoading.value
            ? const ListDocumentSkeleton()
            : ListView.separated(
                padding: EdgeInsets.zero,
                separatorBuilder: (BuildContext context, int index) {
                  return const SizedBox(
                    height: 12,
                  );
                },
                itemCount: controller.sosList.length,
                itemBuilder: (context, index) {
                  final category = controller.sosList[index];
                  return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 4),
                          child: CustomTextView(
                            text: controller.sosList[index].label ?? "",
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: colorSecondary,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const SizedBox(height: 5),
                        ...?category.items
                            ?.map((user) => _buildContactCard(user, context)),
                        const SizedBox(height: 15),
                      ]);
                },
              ));
  }

  Widget _buildContactCard(Items user, BuildContext context) {
    // Check if both phone and email are null
    bool disableTap = (user.mobile == null || user.mobile!.isEmpty) &&
        (user.email == null || user.email!.isEmpty);

    return Card(
      color: colorLightGray,
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 14),
        child: ListTile(
          contentPadding: EdgeInsets.zero,
          leading: (user.avatar == null || user.avatar!.isEmpty) &&
                  (user.shortName == null || user.shortName!.isEmpty)
              ? null
              : CircleAvatar(
                  radius: 29,
                  backgroundColor:
                      white, // Remove this line if you only want the avatar or initials
                  backgroundImage:
                      user.avatar != null && user.avatar!.isNotEmpty
                          ? NetworkImage(user.avatar!)
                          : null,
                  child: user.avatar == null || user.avatar!.isEmpty
                      ? Center(
                          child: CustomTextView(
                            text: user.shortName ?? "",
                            color: colorSecondary,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            textAlign: TextAlign.center,
                          ),
                        )
                      : null,
                ),
          title: user.name == null || user.name!.isEmpty
              ? const SizedBox()
              : CustomTextView(
                  text: user.name ?? "",
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: colorSecondary,
                ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Display email if available
              if (user.email != null &&
                  user.email!.isNotEmpty &&
                  user.email != "null")
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset(ImageConstant.email),
                    const SizedBox(width: 10),
                    Expanded(
                      child: CustomTextView(
                        text: user.email ?? "",
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: colorGray,
                      ),
                    ),
                  ],
                ),
              // Display phone number if available
              if (user.mobile != null &&
                  user.mobile!.isNotEmpty &&
                  user.mobile != "null")
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset(ImageConstant.phone),
                    const SizedBox(width: 10),
                    Expanded(
                      child: CustomTextView(
                        text: user.mobile ?? "",
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: colorGray,
                      ),
                    ),
                  ],
                ),
            ],
          ),
          onTap: disableTap
              ? null
              : () {
                  if (user.email != null && user.email!.isNotEmpty) {
                    _showContactOptions(context, user);
                  } else {
                    _launchDialer(user.mobile ?? "");
                  }
                },
          tileColor: Colors.transparent,
          splashColor: Colors.transparent,
        ),
      ),
    );
  }

  void _showContactOptions(BuildContext context, Items user) {
    showModalBottomSheet(
      backgroundColor: white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10), topRight: Radius.circular(10))),
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: Image.asset(
                ImageConstant.gmailIcon,
                height: 30,
              ),
              title:  CustomTextView(
                text: 'Send Email',
                fontSize: 16,
                fontWeight: FontWeight.normal,
              ),
              onTap: () {
                Navigator.pop(context); // Close the dialog
                _launchEmail(user.email ??
                    ""); // Pass the tapped user's email to _launchEmail
              },
            ),
            ListTile(
              leading: Image.asset(
                ImageConstant.telephoneIcon,
                height: 30,
              ),
              title:  CustomTextView(
                text: 'Make Phone Call',
                fontSize: 16,
                fontWeight: FontWeight.normal,
              ),
              onTap: () {
                Navigator.pop(context); // Close the dialog
                _launchDialer(
                    user.mobile ?? ""); // Call the user's phone number
              },
            ),
          ],
        );
      },
    );
  }

  void _launchDialer(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      throw 'Could not launch $launchUri';
    }
  }

  void _launchEmail(String email) async {
    if (email.isEmpty) {
      Get.snackbar(
        'Error',
        'This contact does not have an email address.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    final Uri emailLaunchUri =
        Uri(scheme: 'mailto', path: email, queryParameters: {'subject': ''});

    try {
      if (await canLaunchUrl(emailLaunchUri)) {
        await launchUrl(emailLaunchUri, mode: LaunchMode.externalApplication);
      } else {
        // If canLaunchUrl returns false, try launching without checking
        await launchUrl(emailLaunchUri, mode: LaunchMode.externalApplication);
      }
    } on PlatformException catch (e) {
      print('PlatformException: ${e.message}');
      Get.snackbar(
        'Error',
        'There was an issue launching the email app: ${e.message}',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } catch (e) {
      print('Error launching email: $e');
      Get.snackbar(
        'Error',
        'There was an issue launching the email app. Please ensure you have an email app installed.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    }
  }
}
