import 'package:dreamcast/theme/app_colors.dart';
import 'package:dreamcast/utils/size_utils.dart';
import 'package:dreamcast/widgets/toolbarTitle.dart';
import 'package:dreamcast/view/profileSetup/controller/profileSetupController.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';

import '../../../routes/my_constant.dart';
import '../../../utils/image_constant.dart';
import '../../../widgets/app_bar/appbar_leading_image.dart';
import '../../../widgets/app_bar/custom_app_bar.dart';
import '../../../widgets/custom_search_view.dart';
import '../../../widgets/button/common_material_button.dart';
import '../../account/model/createProfileModel.dart';

class ProfileSelectDialog extends StatefulWidget {
  ProfileFieldData createFieldBody;

  ProfileSelectDialog({Key? key, required this.createFieldBody})
      : super(key: key);

  @override
  State<ProfileSelectDialog> createState() => _ProfileSelectDialogState();
}

class _ProfileSelectDialogState extends State<ProfileSelectDialog> {
  EditProfileController controller = Get.find();

  @override
  void initState() {
    controller.tempOptionList.clear();
    controller.textController.value.clear();
    controller.tempOptionList.addAll(widget.createFieldBody.options ?? []);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black.withOpacity(0.80),
      appBar: _buildAppbar(),
      body: Container(
          decoration:  BoxDecoration(
              color: white, borderRadius: const BorderRadius.all(Radius.circular(0))),
          height: context.height,
          padding: const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 6),
          child: Stack(
            children: [
              Column(
                children: [
                  GetX<EditProfileController>(builder: (controller) {
                    return Container(
                      margin: EdgeInsets.zero,
                      width: context.width,
                      padding: const EdgeInsets.all(0),
                      child: CustomSearchView(
                        controller: controller.textController.value,
                        hintText: "search_here".tr,
                        onChanged: (data) {
                          filterSearchResults(data ?? "");
                        },
                        prefix: null, // No prefix icon
                        onClear: (result) {
                          filterSearchResults("");
                        },
                      ),
                    );
                  }),
                  const SizedBox(height: 8,),
                  Expanded(
                    child: _loadFilterData(widget.createFieldBody),
                  ),
                  const SizedBox(
                    height: 60,
                  )
                ],
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: CommonMaterialButton(
                  color: colorPrimary,
                  onPressed: () async {
                    _sendDataToServer();
                  },
                  text: "select".tr,
                ),
              )
            ],
          )),
    );
  }

  void filterSearchResults(String query) {
    if (query.isNotEmpty) {
      List<Options> dummyListData = [];
      for (var item in controller.tempOptionList) {
        if ((item.text?.toLowerCase())!.contains(query.toLowerCase())) {
          dummyListData.add(item);
        }
      }
      controller.tempOptionList.clear();
      controller.tempOptionList.addAll(dummyListData);
      return;
    } else {
      controller.tempOptionList.clear();
      controller.tempOptionList.addAll(widget.createFieldBody.options ?? []);
    }
  }

  _sendDataToServer() async {
    Get.back(result: widget.createFieldBody);
  }

  _loadFilterData(ProfileFieldData createFieldBody) {
    return Obx(() => ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: controller.tempOptionList.length,
        itemBuilder: (BuildContext context, int index) {
          var aioOption = controller.tempOptionList[index];
          return controller.tempOptionList[index].value.toString().isEmpty
              ? const SizedBox()
              : InkWell(
            onTap: () {
              if (createFieldBody.value is List) {
                if (createFieldBody.value.contains(aioOption.value)) {
                  createFieldBody.value?.remove(aioOption.value ?? "");
                } else {
                  createFieldBody.value?.add(aioOption.value ?? "");
                }
              } else {
                if (createFieldBody.value == aioOption.value) {
                  createFieldBody.value = "";
                } else {
                  createFieldBody.value = aioOption.value ?? "";
                }
              }
              setState(() {});
            },
            child: createFieldBody.value is List
                ? ListTile(
                contentPadding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 6.0),
                trailing: createFieldBody.value
                    .contains(aioOption.value)
                    ?  Icon(Icons.check_box, color: colorSecondary)
                    :  Icon(Icons.check_box_outline_blank,
                    color: colorSecondary),
                title: HtmlWidget(
                  aioOption.text ?? "",textStyle: TextStyle(
                    fontSize: 14.fSize, color: colorGray, fontWeight: FontWeight.normal),
                ))
                : ListTile(
                trailing: createFieldBody.value == aioOption.value
                    ?  Icon(Icons.radio_button_checked,
                    color: colorSecondary)
                    :  Icon(Icons.radio_button_off,
                    color: colorSecondary),
                title: HtmlWidget(
                  aioOption.text ?? "",
                )),
          );
        }));
  }

  /// Section Widget
  PreferredSizeWidget _buildAppbar() {
    return CustomAppBar(
      height: 72.v,
      leadingWidth: 45.h,
      leading: AppbarLeadingImage(
        imagePath: ImageConstant.imgArrowLeft,
        margin: EdgeInsets.only(
          left: 7.h,
          top: 3,
          // bottom: 12.v,
        ),
        onTap: () {
          Get.back();
        },
      ),
      title: ToolbarTitle(title: widget.createFieldBody.label ?? ""),
    );
  }
}
