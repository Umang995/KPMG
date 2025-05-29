import 'dart:convert';
import 'dart:math';
import 'package:dreamcast/core/extension/content_extension.dart';
import 'package:dreamcast/theme/app_colors.dart';
import 'package:dreamcast/theme/ui_helper.dart';
import 'package:dreamcast/utils/image_constant.dart';
import 'package:dreamcast/utils/size_utils.dart';
import 'package:dreamcast/view/qrCode/controller/qr_page_controller.dart';
import 'package:dreamcast/view/qrCode/model/qrScannedUserDetails_Model.dart';
import 'package:dreamcast/view/representatives/controller/user_detail_controller.dart';
import 'package:dreamcast/widgets/button/common_material_button.dart';
import 'package:dreamcast/widgets/camera_permission_screen.dart';
import 'package:dreamcast/widgets/textview/customTextView.dart';
import 'package:dreamcast/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_getx_widget.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRScannerPage extends StatefulWidget {
  const QRScannerPage({super.key});

  @override
  State<QRScannerPage> createState() => _HomePageState();
}

class _HomePageState extends State<QRScannerPage> with WidgetsBindingObserver {
  MobileScannerController mobileScannerController = MobileScannerController();
  bool flashOnOff = false;

  int zoomType = 1;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController qrCodeCtrl = TextEditingController();
  final QrPageController qrPageController = Get.find();
  final UserDetailController userDetailController = Get.find();

  String calledApi = "";
  String _lifecycleState = "Unknown";
  bool _isResumed = false;
  bool waitingForPermission = true;
  final GlobalKey<FormState> formKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    //******** Add the observer to listen to app lifecycle changes ********//
    WidgetsBinding.instance.addObserver(this);
    // ******* Camera permission *******//
    checkPermission();
  }

  // ******* Camera permission *******//
  checkPermission() async {
    bool? status = await UiHelper.checkAndRequestCameraPermissions();
    if (status!) {
      qrPageController.isCameraPermissionDenied(true);
      waitingForPermission = false;
    } else {
      qrPageController.isCameraPermissionDenied(false);
      waitingForPermission = false;
    }
    setState(() {});
  }

//******** Add the observer to listen to app lifecycle changes ********//
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
      if (state == AppLifecycleState.resumed && !_isResumed) {
        // App Paused
        print("state resumed");
        checkPermission();
        setState(() {
          _lifecycleState = "App resumed";
          _isResumed = true; // Reset the resume flag
        });
      } else if (state == AppLifecycleState.paused) {
        _lifecycleState = "App Paused";
        setState(() {
          _lifecycleState = "App Paused";
          _isResumed = false; // Reset the resume flag
        });
      } else if (state == AppLifecycleState.inactive) {
        _lifecycleState = "App Inactive";
      } else if (state == AppLifecycleState.detached) {
        _lifecycleState = "App Detached";
      }
    });
  }

  @override
  void dispose() {
    // Dispose Scanner controller
    mobileScannerController.dispose();
    // Remove the observer when the widget is disposed
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      resizeToAvoidBottomInset: true,
      body: !waitingForPermission
          ? GetX<QrPageController>(
              builder: (controller) {
                return !controller.isCameraPermissionDenied.value
                    ? CameraPermissionScreen(
                        content: "badge_camera_permission_desc".tr,
                        title: "camera_permission_allow".tr,
                        heading: "permission_required".tr,
                      )
                    : Stack(
                        children: [
                          ///******** QR scanner Widget ********//
                          _qrScannerWidget(),

                          ///******** Other option widgets ********//
                          _otherOptionWidgets()
                        ],
                      );
              },
            )
          : const Loading(),
    );
  }

  ///******** QR scanner Widget ********//
  _qrScannerWidget() {
    var scanArea = 350.adaptSize;
    return SizedBox(
      height: MediaQuery.of(context).size.height * 1,
      child: MobileScanner(
        overlayBuilder: (context, boxConstraints) {
          return Container(
            decoration: ShapeDecoration(
              shape: QrScannerOverlayShape(
                borderColor: Colors.white,
                borderLength: 175.adaptSize,
                borderWidth: 1,
                cutOutSize: scanArea,
              ),
            ),
          );
        },
        controller: mobileScannerController,
        onDetect: (BarcodeCapture value) {
          var result = value.barcodes[0].rawValue!;
          if (result.toString().length > 20) {
            Map<String, String> vCardData = parseVCard(result.toLowerCase());
            qrPageController.vCard.value.email =
                vCardData["email"].toString().replaceAll(",", "");
            qrPageController.vCard.value.mobile =
                vCardData["mobile"].toString().replaceAll(",", "");
            qrPageController.vCard.value.uniqueCode =
                vCardData["uc"].toString().replaceAll(",", "");
            var code = vCardData["uc"].toString().replaceAll(",", "");
            if (calledApi != code) {
              setState(() {
                calledApi = code;
              });

              ///******** Calling api get the user detail via unique code ********///
              print("QRCode: $code");
              getUserDetail(code);
            }
            Future.delayed(const Duration(seconds: 2), () {});
          } else {
            if (calledApi != result.toString()) {
              setState(() {
                calledApi = result.toString();
              });

              ///******** Calling api get the user detail via unique code ********///
              print("QRCode: $result");
              getUserDetail(result.toString());
            }
            Future.delayed(const Duration(seconds: 2), () {});
          }
        },
      ),
    );
  }

  ///******** Converting qr code data ********//
  Map<String, String> parseVCard(String vCard) {
    // Create an empty map to store the extracted data
    Map<String, String> vCardMap = {};

    // Split the vCard into lines
    List<String> lines = LineSplitter.split(vCard).toList();

    // Iterate through each line and extract key-value pairs
    for (var line in lines) {
      if (line.isNotEmpty && line.contains(':')) {
        // Split the line at the first ':' to separate the key and value
        var parts = line.split(':');
        var key = parts[0].trim();
        var value = parts
            .sublist(1)
            .join(':')
            .trim(); // Handles multiple colons if necessary

        // Map the extracted data to the vCardMap
        vCardMap[key] = value;
      }
    }

    return vCardMap;
  }

  ///******** Other option widgets ********//
  _otherOptionWidgets() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.2),
              borderRadius: BorderRadius.circular(100),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 5,
                  blurRadius: 20,
                  offset: const Offset(0, 10), // changes position of shadow
                ),
              ],
            ),
            child: FittedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                      onTap: () {
                        /// ******** Flash light ********///
                        _toggleFlashlight();
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: 37,
                        width: 37,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(100),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              spreadRadius: 5,
                              blurRadius: 20,
                              offset: const Offset(
                                  0, 10), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Icon(
                          flashOnOff ? Icons.flash_on : Icons.flash_off,
                          color: flashOnOff ? white : white,
                        ),
                      )),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        if (zoomType == 3) {
                          zoomType = 1;
                          mobileScannerController.resetZoomScale();
                        } else if (zoomType == 1) {
                          zoomType = 2;
                          mobileScannerController.setZoomScale(0.7);
                        } else {
                          zoomType = 3;
                          mobileScannerController.setZoomScale(1.0);
                        }
                      });
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: 37,
                      width: 37,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(100),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            spreadRadius: 5,
                            blurRadius: 20,
                            offset: const Offset(
                                0, 10), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Text(
                        zoomType == 1
                            ? "1X"
                            : zoomType == 2
                                ? "2X"
                                : "3X",
                        style: TextStyle(
                            color: white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 25),
          const CustomTextView(
              text: "OR",
              color: Colors.white, // Adjust text color if needed
              fontSize: 14,
              textAlign: TextAlign.center,
              fontWeight: FontWeight.w500),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 100),
            child: CommonMaterialButton(
              textColor: Colors.black,
              text: "add_manually".tr,
              height: 48,
              textSize: 16,
              color: Colors.white,
              onPressed: () {
                qrCodeCtrl.clear();
                if (flashOnOff) {
                  mobileScannerController.toggleTorch();
                  setState(() {
                    flashOnOff = false;
                  });
                }

                /// ********* Add manually qr code *********///
                _addManuallyPopup();
              },
              weight: FontWeight.w500, // Medium font weight
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  ///******** Flash light ********///
  void _toggleFlashlight() {
    mobileScannerController.toggleTorch();
    setState(() {
      flashOnOff = !flashOnOff;
    });
  }

  /// ********* Add manually qr code *********///
  _addManuallyPopup() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            contentPadding: EdgeInsets.zero,
            content: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Spacer(), // to push the close button to the right
                      IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        icon: Icon(
                          Icons.close,
                          color: colorGray,
                        ),
                        onPressed: () => Get.back(result: ""),
                      ),
                    ],
                  ),
                  CustomTextView(
                      text: "enter_qrcode".tr,
                      color: const Color.fromRGBO(
                          51, 51, 51, 1), // Adjust text color if needed
                      fontSize: 18,
                      textAlign: TextAlign.center,
                      fontWeight: FontWeight.w600),
                  SizedBox(
                    height: 30.adaptSize,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Form(
                      key: _formKey,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 0),
                        child: TextFormField(
                          controller: qrCodeCtrl,
                          textInputAction: TextInputAction.done,
                          enabled: true,
                          maxLength: 50,
                          keyboardType: TextInputType.text,
                          validator: (String? value) {
                            if (value!.trim().isEmpty) {
                              return "enter_qr_code".tr;
                            } else {
                              return null;
                            }
                          },
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp('[a-zA-Z0-9]')),
                          ],
                          decoration: InputDecoration(
                            prefixStyle: TextStyle(color: colorGray),
                            counter: const Offstage(),
                            contentPadding:
                                const EdgeInsets.fromLTRB(20, 15, 20, 15),
                            hintText: "enter_qrcode".tr,
                            hintStyle: const TextStyle(
                              color: Color.fromRGBO(138, 138, 142, 1),
                            ),
                            labelStyle:
                                TextStyle(color: colorGray, fontSize: 14),
                            prefixIconConstraints:
                                const BoxConstraints(minWidth: 60),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                    color: colorLightGray, width: 1)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                    color: colorLightGray, width: 1)),
                            errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                    color: Colors.red, width: 1)),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                    color: colorLightGray, width: 1)),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10.adaptSize,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: CommonMaterialButton(
                      text: "submit".tr,
                      height: 53,
                      textSize: 16,
                      color: colorPrimary,
                      onPressed: () {
                        if (_formKey.currentState?.validate() == true) {
                          Navigator.pop(context);

                          ///******** Calling api get the user detail via unique code ********///
                          print("QRCode: ${qrCodeCtrl.text}");
                          getUserDetail(qrCodeCtrl.text);
                        } else {
                          return;
                        }
                      },
                      weight: FontWeight.w500, // Medium font weight
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                ],
              ),
            ),
          );
        });
  }

  ///******** Calling api get the user detail via unique code ********///
  getUserDetail(String? code) async {
    mobileScannerController.resetZoomScale();
    if (flashOnOff) {
      mobileScannerController.toggleTorch();
      setState(() {
        flashOnOff = false;
      });
    }
    QrScannedUserDetailsModel response =
        await qrPageController.getUserDetail(context, code);
    print(response);
    if (response.code == 200 && response.status == true) {
      mobileScannerController.dispose();

      ///********* Save contact Bottom Sheet ***********///
      saveContactBottomSheet(context, response.body!, code ?? "");
    }
  }

  ///********* Save contact Bottom Sheet ***********///
  saveContactBottomSheet(
      BuildContext context, Data details, String uniqueCode) {
    userDetailController.notesEdtController.clear();
    showModalBottomSheet(
        context: context,
        backgroundColor: white,
        isDismissible: false,
        isScrollControlled:
            true, // Allows bottom sheet to adjust when keyboard opens
        builder: (context) {
          return Stack(
            children: [
              SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomTextView(
                                text: "user_profile".tr,
                                fontSize: 22.v,
                                fontWeight: FontWeight.w600,
                                color: colorSecondary,
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: SvgPicture.asset(ImageConstant.icClose),
                              ),
                            ],
                          ),
                        ),
                        Divider(color: colorLightGray),
                        const SizedBox(height: 12),
                        Container(
                          height: 80,
                          width: 80,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: colorSecondary,
                              border: Border.all(color: Colors.transparent)),
                          child: Center(
                              child: CustomTextView(
                            text: details.shortName ?? "",
                            textAlign: TextAlign.center,
                            color: white,
                          )),
                        ),
                        const SizedBox(height: 8),
                        CustomTextView(
                          text: details.name ?? "",
                          textAlign: TextAlign.center,
                          color: colorSecondary,
                          fontSize: 22.v,
                        ),
                        const SizedBox(height: 5),
                        CustomTextView(
                          text: details.company ?? "",
                          textAlign: TextAlign.center,
                          fontWeight: FontWeight.w500,
                          fontSize: 16.v,
                          color: colorDisabled,
                        ),
                        CustomTextView(
                          text: details.position ?? "",
                          textAlign: TextAlign.center,
                          color: colorDisabled,
                          fontWeight: FontWeight.w500,
                          fontSize: 16.v,
                        ),
                        const SizedBox(height: 8),
                        Container(
                          decoration: BoxDecoration(
                              color: colorLightGray,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                    bottom: 0.h,
                                    right: 16.h,
                                    left: 16.h,
                                    top: 10.v),
                                child: CustomTextView(
                                  text: "Info",
                                  maxLines: 2,
                                  color: colorSecondary,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 14.v, horizontal: 16.h),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: context.width * .27,
                                          child: CustomTextView(
                                            text: "Email :",
                                            maxLines: 2,
                                            color: colorGray,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 5.h,
                                        ),
                                        CustomTextView(
                                          text: details.email ?? "",
                                          maxLines: 2,
                                          color: colorSecondary,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16,
                                        ),
                                      ],
                                    ),
                                    //SvgPicture.asset("assets/svg/temp_arrow_details.svg")
                                  ],
                                ),
                              ),
                              const Divider(
                                height: 1,
                                color: borderColor,
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 14.v, horizontal: 16.h),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: context.width * .27,
                                          child: CustomTextView(
                                            text: "Phone :",
                                            maxLines: 2,
                                            color: colorGray,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 5.h,
                                        ),
                                        CustomTextView(
                                          text: details.mobile ?? "",
                                          maxLines: 2,
                                          color: colorSecondary,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16,
                                        ),
                                      ],
                                    ),
                                    //SvgPicture.asset("assets/svg/temp_arrow_details.svg")
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: context.width,
                          padding: const EdgeInsets.all(12),
                          margin: const EdgeInsets.only(top: 20),
                          decoration: BoxDecoration(
                            color: colorLightGray,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(12),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: EdgeInsets.zero,
                                child: CustomTextView(
                                  text: "add_note".tr,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 16),
                                padding: EdgeInsets.zero,
                                child: Form(
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  key: formKey,
                                  child: TextFormField(
                                    controller:
                                        userDetailController.notesEdtController,
                                    maxLength: 1024,
                                    maxLines: 2,
                                    minLines: 1,
                                    keyboardType: TextInputType.multiline,
                                    textInputAction: TextInputAction.newline,
                                    validator: (String? value) {
                                      if (value == null ||
                                          value.toString().trim().isEmpty) {
                                        return "enter_notes".tr;
                                      } else if (value.length < 3) {
                                        return "notes_length_validation".tr;
                                      } else {
                                        return null;
                                      }
                                    },
                                    onChanged: (value) {},
                                    onEditingComplete: () {
                                      FocusManager.instance.primaryFocus
                                          ?.unfocus();
                                    },
                                    decoration: InputDecoration(
                                        counter: const Offstage(),
                                        contentPadding:
                                            const EdgeInsets.fromLTRB(
                                                16, 15, 16, 15),
                                        hintText: "addNotesHere".tr,
                                        hintStyle: TextStyle(
                                            color: colorGray,
                                            fontSize: 14,
                                            fontWeight: FontWeight.normal),
                                        labelStyle: TextStyle(
                                            color: colorGray, fontSize: 14),
                                        filled: true,
                                        prefixIconConstraints:
                                            const BoxConstraints(minWidth: 60),
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: const BorderSide(
                                                color: Colors.grey)),
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: BorderSide(
                                                color: colorSecondary)),
                                        errorBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide:
                                                const BorderSide(color: Colors.red)),
                                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.black)),
                                        disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.grey))),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(height: 15),
                        CommonMaterialButton(
                            text: "save_contact".tr,
                            color: colorPrimary,
                            onPressed: () async {
                              FocusManager.instance.primaryFocus?.unfocus();
                              var jsonRequest = {
                                // "code": uniqueCode,
                                "qrcode": uniqueCode,
                                "note": userDetailController
                                        .notesEdtController.text
                                        .trim()
                                        .toString() ??
                                    ""
                              };
                              await qrPageController.saveUserToContact(
                                  context, jsonRequest);
                              Navigator.pop(context);
                            }),
                      ],
                    ),
                  ),
                ),
              ),
              Obx(() => qrPageController.loading.value
                  ? const Loading()
                  : const SizedBox()),
            ],
          );
        });
  }
}

class QrScannerOverlayShape extends ShapeBorder {
  QrScannerOverlayShape({
    this.borderColor = Colors.red,
    this.borderWidth = 1.0,
    this.overlayColor = const Color.fromRGBO(0, 0, 0, 80),
    this.borderRadius = 0,
    this.borderLength = 40,
    double? cutOutSize,
    double? cutOutWidth,
    double? cutOutHeight,
    this.cutOutBottomOffset = 0,
  })  : cutOutWidth = cutOutWidth ?? cutOutSize ?? 250,
        cutOutHeight = cutOutHeight ?? cutOutSize ?? 250 {
    assert(
      borderLength <=
          min(this.cutOutWidth, this.cutOutHeight) / 2 + borderWidth * 2,
      "Border can't be larger than ${min(this.cutOutWidth, this.cutOutHeight) / 2 + borderWidth * 2}",
    );
    assert(
        (cutOutWidth == null && cutOutHeight == null) ||
            (cutOutSize == null && cutOutWidth != null && cutOutHeight != null),
        'Use only cutOutWidth and cutOutHeight or only cutOutSize');
  }

  final Color borderColor;
  final double borderWidth;
  final Color overlayColor;
  final double borderRadius;
  final double borderLength;
  final double cutOutWidth;
  final double cutOutHeight;
  final double cutOutBottomOffset;

  @override
  EdgeInsetsGeometry get dimensions => const EdgeInsets.all(10);

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return Path()
      ..fillType = PathFillType.evenOdd
      ..addPath(getOuterPath(rect), Offset.zero);
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    Path getLeftTopPath(Rect rect) {
      return Path()
        ..moveTo(rect.left, rect.bottom)
        ..lineTo(rect.left, rect.top)
        ..lineTo(rect.right, rect.top);
    }

    return getLeftTopPath(rect)
      ..lineTo(
        rect.right,
        rect.bottom,
      )
      ..lineTo(
        rect.left,
        rect.bottom,
      )
      ..lineTo(
        rect.left,
        rect.top,
      );
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    final width = rect.width;
    final borderWidthSize = width / 2;
    final height = rect.height;
    final borderOffset = borderWidth / 2;
    final mBorderLength =
        borderLength > min(cutOutHeight, cutOutHeight) / 2 + borderWidth * 2
            ? borderWidthSize / 2
            : borderLength;
    final mCutOutWidth =
        cutOutWidth < width ? cutOutWidth : width - borderOffset;
    final mCutOutHeight =
        cutOutHeight < height ? cutOutHeight : height - borderOffset;

    final backgroundPaint = Paint()
      ..color = overlayColor
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;

    final boxPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.fill
      ..blendMode = BlendMode.dstOut;

    final cutOutRect = Rect.fromLTWH(
      rect.left + width / 2 - mCutOutWidth / 2 + borderOffset,
      -cutOutBottomOffset +
          rect.top +
          height / 2.5 -
          mCutOutHeight / 2 +
          borderOffset,
      mCutOutWidth - borderOffset * 2,
      mCutOutHeight - borderOffset * 2,
    );

    canvas
      ..saveLayer(
        rect,
        backgroundPaint,
      )
      ..drawRect(
        rect,
        backgroundPaint,
      )
      // Draw top right corner
      ..drawRRect(
        RRect.fromLTRBAndCorners(
          cutOutRect.right - mBorderLength,
          cutOutRect.top,
          cutOutRect.right,
          cutOutRect.top + mBorderLength,
          // topRight: Radius.circular(borderRadius),
        ),
        borderPaint,
      )
      // Draw top left corner
      ..drawRRect(
        RRect.fromLTRBAndCorners(
          cutOutRect.left,
          cutOutRect.top,
          cutOutRect.left + mBorderLength,
          cutOutRect.top + mBorderLength,
          // topLeft: Radius.circular(borderRadius),
        ),
        borderPaint,
      )
      // Draw bottom right corner
      ..drawRRect(
        RRect.fromLTRBAndCorners(
          cutOutRect.right - mBorderLength,
          cutOutRect.bottom - mBorderLength,
          cutOutRect.right,
          cutOutRect.bottom,
          // bottomRight: Radius.circular(borderRadius),
        ),
        borderPaint,
      )
      // Draw bottom left corner
      ..drawRRect(
        RRect.fromLTRBAndCorners(
          cutOutRect.left,
          cutOutRect.bottom - mBorderLength,
          cutOutRect.left + mBorderLength,
          cutOutRect.bottom,
          // bottomLeft: Radius.circular(borderRadius),
        ),
        borderPaint,
      )
      ..drawRRect(
        RRect.fromRectAndRadius(
          cutOutRect,
          const Radius.circular(0),
        ),
        boxPaint,
      )
      ..restore();
  }

  @override
  ShapeBorder scale(double t) {
    return QrScannerOverlayShape(
      borderColor: borderColor,
      borderWidth: borderWidth,
      overlayColor: overlayColor,
    );
  }
}
