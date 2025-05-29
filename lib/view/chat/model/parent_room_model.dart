
import 'package:dreamcast/view/chat/model/profile_model.dart';
import 'package:dreamcast/view/chat/model/room_model.dart';

class ParentRoomModel {
  RoomModel? roomModel;
  ChatProfileModel?  chatProfileModel;
  dynamic receiverId;
  ParentRoomModel({this.receiverId,this.roomModel,this.chatProfileModel});

}
