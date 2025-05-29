import 'package:dreamcast/theme/app_colors.dart';
import 'package:dreamcast/utils/size_utils.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

class CustomPopupMenu extends StatelessWidget {
  final VoidCallback onClose;
  final List<String> items;
  final ValueChanged<String> onSelected;
  final Offset position;

  CustomPopupMenu({
    required this.onClose,
    required this.items,
    required this.onSelected,
    required this.position,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          GestureDetector(
            onTap: onClose,
            child: Container(
              color: Colors.transparent,
            ),
          ),
          Positioned(
            left: position.dx,
            top: position.dy,
            child: Material(
              color: white,
              elevation: 8.0,
              borderRadius: BorderRadius.circular(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: items.map((item) {
                  return /*ListTile(
                    title: Text("Request Received"),
                    onTap: () {
                      onSelected(item);
                      onClose();
                    },
                  )*/const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("Request Received"),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
