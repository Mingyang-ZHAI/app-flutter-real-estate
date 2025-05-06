import 'package:flutter/material.dart';
import 'package:real_estate/theme/color.dart';
import 'package:real_estate/widgets/custom_image.dart';

class ChatItem extends StatelessWidget {
  final Map<String, dynamic> data;
  final GestureTapCallback? onTap;

  const ChatItem({Key? key, required this.data, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: AppColor.shadowColor.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 1,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          children: [
            _buildAvatar(),
            const SizedBox(width: 15),
            Expanded(child: _buildInfo()),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    return Stack(
      children: [
        CustomImage(
          data['image'],
          width: 55,
          height: 55,
          radius: 18,
        ),
        if (data['isOnline'])
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              width: 15,
              height: 15,
              decoration: BoxDecoration(
                color: AppColor.secondary,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              data['name'],
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              data['timeAgo'],
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
        const SizedBox(height: 3),
        Text(
          data['lastMessage'],
          style: TextStyle(
            fontSize: 14,
            color: data['unread'] ? AppColor.darker : Colors.grey,
            fontWeight: data['unread'] ? FontWeight.w500 : FontWeight.normal,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Spacer(),
            if (data['unread'])
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: AppColor.primary,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  data['unreadCount'].toString(),
                  style: const TextStyle(
                    fontSize: 10,
                    color: Colors.white,
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}