import 'dart:async';
import 'package:camera/camera.dart';
import 'package:dreamcast/theme/app_colors.dart';
import 'package:dreamcast/utils/image_constant.dart';
import 'package:dreamcast/utils/size_utils.dart';
import 'package:dreamcast/view/photobooth/controller/photobooth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../widgets/camera_permission_screen.dart';
import '../../../widgets/textview/customTextView.dart';
import '../../../widgets/button/common_material_button.dart';

class CameraScreen extends StatefulWidget {
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen>
    with WidgetsBindingObserver {
  //Create an instance of ScreenshotController
  final PhotoBoothController photoboothController = Get.find();
  CameraController? controller;

  // Initial values
  bool _isCameraPermissionGranted = false;
  bool _isRearCameraSelected = false;

  final resolutionPresets = ResolutionPreset.values;
  ResolutionPreset currentResolutionPreset = ResolutionPreset.medium;

  void getPermissionStatus() async {
    // Request camera permission
    await Permission.camera.request();
    // Check if camera permission is granted
    final isCameraPermissionGranted =
        await _requestPermission(Permission.camera);
    if (isCameraPermissionGranted) {
      setState(() {
        _isCameraPermissionGranted =
            true; // Ensure _isCameraPermissionGranted is declared and set accordingly
      });
      photoboothController.isCameraPermissionDenied(false);
      // Initialize the camera if available
      if (photoboothController.cameras.isNotEmpty) {
        if (photoboothController.cameras.length > 1) {
          onNewCameraSelected(
              photoboothController.cameras[1]); // Adjust index as needed
        } else {
          onNewCameraSelected(
              photoboothController.cameras[0]); // Adjust index as needed
        }
      } else {
        Get.snackbar(
          "camera".tr,
          "camera_not_available".tr,
          colorText: Colors.white,
          backgroundColor: Colors.lightBlue,
        );
      }
    } else {
      PermissionStatus status = await Permission.camera.status;
      if (status.isPermanentlyDenied) {
        photoboothController.isCameraPermissionDenied(true);
      }
    }
  }

  Future<bool> _requestPermission(Permission permission) async {
    final status = await permission.status;
    if (status.isGranted) {
      return true;
    } else {
      final result = await permission.request();
      return result.isGranted;
    }
  }

  Future<XFile?> takePicture() async {
    final CameraController? cameraController = controller;
    if (cameraController!.value.isTakingPicture) {
      // A capture is already pending, do nothing.
      return null;
    }
    try {
      XFile file = await cameraController.takePicture();
      return file;
    } on CameraException catch (e) {
      print('Error occured while taking picture: $e');
      return null;
    }
  }

  void resetCameraValues() async {
    await controller!.setZoomLevel(0);
  }

  void onNewCameraSelected(CameraDescription cameraDescription) async {
    print("12 onNewCameraSelected");
    final previousCameraController = controller;

    final CameraController cameraController = CameraController(
      cameraDescription,
      currentResolutionPreset,
      imageFormatGroup: ImageFormatGroup.jpeg,
      enableAudio: false, // Disable audio to avoid requesting audio permission
    );
    await previousCameraController?.dispose();
    // resetCameraValues();

    if (mounted) {
      setState(() {
        controller = cameraController;
      });
    }
    // Update UI if controller updated
    cameraController.addListener(() {
      if (mounted) setState(() {});
    });

    try {
      await cameraController.initialize();
    } on CameraException catch (e) {
      print('Error initializing camera: $e');
    }
    if (mounted) {
      photoboothController.isCameraInitialized.value =
          controller!.value.isInitialized;
    } else {
      photoboothController.isCameraInitialized.value =
          controller!.value.isInitialized;
    }
  }

  void onViewFinderTap(TapDownDetails details, BoxConstraints constraints) {
    if (controller == null) {
      return;
    }

    final offset = Offset(
      details.localPosition.dx / constraints.maxWidth,
      details.localPosition.dy / constraints.maxHeight,
    );
    controller!.setExposurePoint(offset);
    controller!.setFocusPoint(offset);
  }

  @override
  void initState() {
    // Hide the status bar in Android
    WidgetsBinding.instance.addObserver(this);
    getPermissionStatus();
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Check permission status when app is resumed
      getPermissionStatus();
    }
    final CameraController? cameraController = controller;
    // App state changed before we got the chance to initialize.
    photoboothController.checkPermissionStatus(true);
    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    } else if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      // Check permission status when app is resumed
      photoboothController.checkPermissionStatus(true);
      onNewCameraSelected(cameraController.description);
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }

  takeImage() async {
    XFile? rawImage = await takePicture();
    if (rawImage!.path.isNotEmpty) {
      Get.back(result: rawImage.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            iconTheme:  IconThemeData(color: white),
            backgroundColor: Colors.transparent,
            leading: GestureDetector(
              onTap: (){
                Get.back();
              },
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: SvgPicture.asset(ImageConstant.crossIcon),
              ),
            ),
            title: CustomTextView(
              text: "ai_photo_search".tr,
              color: white,
              fontSize: 18,
              textAlign: TextAlign.center,
            )),
        backgroundColor: Colors.transparent,
        body: GetX<PhotoBoothController>(
          builder: (photoBoothController) {
            return photoboothController.isCameraPermissionDenied.value
                ? CameraPermissionScreen(
                    title: "allow_camera_permission".tr,
                    content: "ai_camera_permission_desc".tr,
                  )
                : photoboothController.isCameraInitialized.value
                    ? buildCameraWidget()
                    : GestureDetector(
                        onTap: () {},
                        child: Center(
                          child: TextButton(
                            onPressed: () {
                              getPermissionStatus();
                            },
                            child: CustomTextView(
                              text: "refresh".tr,
                              color: white,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                      );
          },
        ));
  }

  ///camera widget
  buildCameraWidget() {
    return Stack(
      alignment: Alignment.center,
      children: [
        CameraPreview(
          controller!,
          child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTapDown: (details) => onViewFinderTap(details, constraints),
            );
          }),
        ),
        Align(
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.all(70.0),
            child: SvgPicture.asset(
              ImageConstant.cameraFrame,
              color: white,
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: SizedBox(
            height: 58,
            width: 212.adaptSize,
            child: CommonMaterialButton(
              color: white,
              textColor: colorSecondary,
              textSize: 18,
              weight: FontWeight.w600,
              text: "search".tr,
              onPressed: () {
                takeImage();
              },
            ),
          ),
        ),
      ],
    );
  }

  ///used when we need to change the camera
  buildCameraChangeWidget() {
    return InkWell(
      onTap: () {
        photoboothController.isCameraInitialized(false);
        onNewCameraSelected(
            photoboothController.cameras[_isRearCameraSelected ? 1 : 0]);
        setState(() {
          _isRearCameraSelected = !_isRearCameraSelected;
        });
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          const Icon(
            Icons.circle,
            color: Colors.black38,
            size: 60,
          ),
          Icon(
            _isRearCameraSelected ? Icons.camera_rear : Icons.camera_front,
            color: Colors.white,
            size: 30,
          ),
        ],
      ),
    );
  }
}
