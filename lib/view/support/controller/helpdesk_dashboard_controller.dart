import 'package:dreamcast/view/support/controller/supportController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../main.dart';
import '../../../utils/dialog_constant.dart';
import '../../beforeLogin/globalController/authentication_manager.dart';
import 'faq_controller.dart';

class HelpdeskDashboardController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late final TabController _tabController;
  TabController get tabController => _tabController;

  final selectedTabIndex = 0.obs;
  final tabList = ["FAQs", "Contact Us", "Support Chat"];

  final SOSFaqController _faqController = Get.find();
  final AuthenticationManager _manager = Get.find();

  @override
  void onInit() {
    super.onInit();
    _tabController = TabController(vsync: this, length: tabList.length);
    _tabController.addListener(_handleTabChange);
  }

  void _handleTabChange() {
    // Handle only actual tab switch, not rebuilds
    if (_tabController.indexIsChanging) {
      final newIndex = _tabController.index;

      if (newIndex == 2 && !_manager.isLogin()) {
        DialogConstantHelper.showLoginDialog(
          navigatorKey.currentState!.context!,
          _manager,
        );

        // Revert to previously selected tab
        _tabController.index = selectedTabIndex.value;
        return;
      }

      selectedTabIndex.value = newIndex;

      switch (newIndex) {
        case 0:
          _faqController.getFaqList(isRefresh: false);
          break;
        case 1:
          _faqController.getSOSList(isRefresh: false);
          break;
        // No need for case 2 since it's gated behind login
      }
    }
  }

  Future<void> initController() async {
    Get.lazyPut(() => SupportController(), fenix: true);
    Get.put<SOSFaqController>(SOSFaqController());
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    super.dispose();
  }
}
