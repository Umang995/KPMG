/*
import 'package:dreamcast/theme/app_colors.dart';
import 'package:dreamcast/theme/strings.dart';
import 'package:dreamcast/view/beforeLogin/login/login_controller.dart';
import 'package:dreamcast/view/beforeLogin/splash/model/config_model.dart';
import '../../widgets/toolbarTitle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import '../../../widgets/common_material_button.dart';

class SignupDropdownDialog extends StatefulWidget {
  SignupField createFieldBody;

  SignupDropdownDialog({Key? key, required this.createFieldBody})
      : super(key: key);

  @override
  State<SignupDropdownDialog> createState() => _SignupDropdownDialogState();
}

class _SignupDropdownDialogState extends State<SignupDropdownDialog> {
  LoginController controller = Get.find();

  @override
  void initState() {
    super.initState();
    controller.countryCodeList.clear();
    //controller.countryCodeList.addAll(widget.createFieldBody.options ?? []);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black.withOpacity(0.80),
      appBar: AppBar(
        elevation: 0,
        shape: Border.all(width: 1, color: indicatorColor),
        backgroundColor: appBarColor,
        iconTheme: const IconThemeData(color: appIconColor),
        toolbarHeight: 60,
        title: ToolbarTitle(title: widget.createFieldBody.label ?? ""),
      ),
      body: Container(
          decoration: const BoxDecoration(
              color: white, borderRadius: BorderRadius.all(Radius.circular(0))),
          height: context.height,
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
          child: Stack(
            children: [
              Column(
                children: [
                  GetX<LoginController>(builder: (controller) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 12),
                      width: context.width,
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          color: Colors.white,
                          border: Border.all(color: indicatorColor, width: 1),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: TextField(
                              autocorrect: false,
                              style: const TextStyle(fontSize: 16),
                              controller: controller.textController?.value,
                              decoration: const InputDecoration(
                                  hintText: 'Search here',
                                  border: InputBorder.none),
                              onChanged: (data) {
                                filterSearchResults(data ?? "");
                              },
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Future.delayed(Duration.zero, () async {});
                            },
                            child: Container(
                                width: 40,
                                height: 40,
                                decoration: const BoxDecoration(
                                    color: secondaryColor,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(6))),
                                child: const Icon(Icons.search)),
                          ),
                        ],
                      ),
                    );
                  }),
                  const SizedBox(
                    height: 12,
                  ),
                  Expanded(
                    child: _loadFilterData(widget.createFieldBody),
                  ),
                  const SizedBox(
                    height: 50,
                  )
                ],
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: ProfileButton(
                    text: MyStrings.next,
                    press: () async {
                      _sendDataToServer();
                    }),
              )
            ],
          )),
    );
  }

  void filterSearchResults(String query) {
    if (query.isNotEmpty) {
      List<CountryData> dummyListData = [];
      for (var item in controller.countryCodeList) {
        if ((item.name?.toLowerCase())!.contains(query.toLowerCase())) {
          dummyListData.add(item);
        }
      }
      controller.countryCodeList.clear();
      controller.countryCodeList.addAll(dummyListData);
      return;
    } else {
      controller.countryCodeList.clear();
      //controller.countryCodeList.addAll(widget.createFieldBody.options ?? []);
    }
  }

  _sendDataToServer() async {
    Get.back(result: widget.createFieldBody);
  }

  _loadFilterData(SignupField createFieldBody) {
    return Obx(() => ListView.builder(
        padding: const EdgeInsets.all(0),
        itemCount: controller.countryCodeList?.length,
        itemBuilder: (BuildContext context, int index) {
          var countryData = controller.countryCodeList?[index];
          return InkWell(
            onTap: () {
              if (createFieldBody.value == countryData?.id) {
                createFieldBody.value = "";
              } else {
                createFieldBody.value = countryData?.id ?? "";
                createFieldBody.countryCode = countryData?.name ?? "";
              }
              setState(() {});
            },
            child: ListTile(
                trailing: createFieldBody.value == countryData?.id
                    ? const Icon(Icons.radio_button_checked,
                        color: primaryColor)
                    : const Icon(Icons.radio_button_off, color: primaryColor),
                title: HtmlWidget(
                   countryData?.name ?? "")),
          );
        }));
  }
}
*/
