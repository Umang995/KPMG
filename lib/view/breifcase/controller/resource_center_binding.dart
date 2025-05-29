import 'package:dreamcast/view/breifcase/controller/common_document_controller.dart';
import 'package:get/get.dart';

class ResourceCenterBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<CommonDocumentController>(CommonDocumentController(),);
    //Get.lazyPut(() => ResourceCenterController(),fenix: true);
  }
}
