import 'package:dreamcast/core/extension/content_extension.dart';
import 'package:dreamcast/utils/image_constant.dart';
import 'package:dreamcast/utils/size_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import '../theme/app_colors.dart';
import 'custom_image_view.dart';
class CustomSearchView1 extends StatelessWidget {
  String title;
  bool? hideFilter;
  final Function press;
  final FocusNode? focusNode;
  final Function(String) onSubmit;
  final Function(String) onClear;
  Rx<TextEditingController> textController;
  CustomSearchView1(
      {Key? key,
      required this.title,
      this.hideFilter,
      this.focusNode,
      required this.press,
      required this.onSubmit,
      required this.onClear,
      required this.textController})
      : super(key: key);
  var inputData = "".obs;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10))),
      width: double.infinity,
      child: Center(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 9,
              child: Container(
                width: context.width,
                padding: const EdgeInsets.symmetric(horizontal: 6),
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: colorLightGray,
                    border: Border.all(color: Colors.transparent, width: 0.5),
                    borderRadius: const BorderRadius.all(Radius.circular(32))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: TextField(
                        autocorrect: false,
                        style: const TextStyle(fontSize: 12),
                        controller: textController.value,
                        onTapOutside: (event) {
                          if (focusNode != null) {
                            focusNode?.unfocus();
                          } else {
                            FocusManager.instance.primaryFocus?.unfocus();
                          }
                        },
                        decoration: const InputDecoration(
                            hintText: ' Search here', border: InputBorder.none),
                        onSubmitted: (data) {
                          inputData(data);
                          if (data.isNotEmpty) {
                            Future.delayed(Duration.zero, () async {
                              onSubmit(data);
                            });
                          }
                        },
                        onChanged: (data) {
                          inputData(data);
                        },
                      ),
                    ),
                    Obx(
                      () => textController.value.text.isNotEmpty
                          ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: InkWell(
                                onTap: () {
                                  Future.delayed(Duration.zero, () async {
                                    textController.value.clear();
                                    onClear("");
                                  });
                                },
                                child: const Icon(
                                  Icons.clear,
                                ),
                              ),
                            )
                          : InkWell(
                              onTap: () {
                                Future.delayed(Duration.zero, () async {
                                  onSubmit(textController.value.text);
                                });
                              },
                              child: Container(
                                margin:
                                    EdgeInsets.fromLTRB(16.h, 14.v, 8.h, 14.v),
                                child: CustomImageView(
                                  imagePath: ImageConstant.imgRewind,
                                  height: 26.adaptSize,
                                  width: 26.adaptSize,
                                ),
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              width: 12,
            ),
            hideFilter == null
                ? Expanded(
                    flex: 1,
                    child: InkWell(
                      onTap: () {
                        Future.delayed(Duration.zero, () async {
                          press();
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: SvgPicture.asset(
                          ImageConstant.filterIcon,
                          height: 20.adaptSize,
                          width: 20.adaptSize,
                        ),
                      ),
                    ),
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
