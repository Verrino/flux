import 'package:flutter/material.dart';
import 'package:flux/color_pallete.dart';
import 'package:flux/models/account.dart';
import 'package:flux/services/profile_service.dart';

class CommentBox extends StatefulWidget {
  final String uid;
  final String comment;
  final ColorPallete colorPallete;
  const CommentBox(
      {super.key,
      required this.uid,
      required this.colorPallete,
      required this.comment});

  @override
  State<CommentBox> createState() => _CommentBoxState();
}

class _CommentBoxState extends State<CommentBox> {
  Account? account;

  bool _isLoading = true;
  @override
  void initState() {
    super.initState();
    initialize();
  }

  void initialize() async {
    account = await ProfileService.getAccountByUid(widget.uid).whenComplete(() {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Container()
        : Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            child: Row(
              children: [
                if (widget.comment.isNotEmpty) ...[
                  CircleAvatar(
                    backgroundImage: NetworkImage(account!.profilePictureUrl),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    account!.username,
                    style: TextStyle(
                      color: widget.colorPallete.fontColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    widget.comment,
                    style: TextStyle(
                      color: widget.colorPallete.fontColor,
                    ),
                  ),
                ],
                if (widget.comment.isEmpty) Container(),
              ],
            ),
          );
  }
}
