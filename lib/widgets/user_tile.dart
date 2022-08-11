import 'package:flutter/material.dart';

import '../models/muser.dart';
import 'cashed_image.dart';

class UserTile extends StatelessWidget {
  const UserTile({
    Key? key,
    required this.user,
  }) : super(key: key);

  final MUser? user;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        children: [
          CachedImage(
            user?.profilePhoto,
            height: 20.0,
            width: 20.0,
          ),
          const SizedBox(
            width: 12,
          ),
          Text(
            user?.name ?? "-",
            style: const TextStyle(fontSize: 16),
          )
        ],
      ),
    );
  }
}
