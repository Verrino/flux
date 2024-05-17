import 'package:flutter/material.dart';
import 'package:flux/color_pallete.dart';
import 'package:flux/screens/models/account.dart';
import 'package:flux/screens/models/posting.dart';
import 'package:flux/services/profile_service.dart';

class PostBox extends StatefulWidget {
  final ColorPallete colorPallete;
  final String uid;
  final Posting post;


  final String? postingImageUrl;

  const PostBox({
    super.key, 
    required this.colorPallete, 
    required this.uid,
    required this.post,
    this.postingImageUrl});

  @override
  State<PostBox> createState() => _PostBoxState();
}

class _PostBoxState extends State<PostBox> {
  Account? account;
  bool _isLoading = true;
  @override
  void initState() {
    // TODO: implement initState
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
    return _isLoading ?
      Container() :
      Container(
        decoration: BoxDecoration(
          color: widget.colorPallete.postBackgroundColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    account!.profilePictureUrl.isNotEmpty ?
                      CircleAvatar(
                        backgroundImage: NetworkImage(account!.profilePictureUrl),
                      ) :
                      CircleAvatar(),
                    Text(
                      account!.username, 
                      style: TextStyle(
                        color: widget.colorPallete.fontColor
                      ),
                      ),
                    Text(
                      '1h',
                      style: TextStyle(
                        color: widget.colorPallete.fontColor.withOpacity(0.4),
                      ),
                    ),
                  ],
                ),
                if (widget.post.postingImageUrl != null) ... [
                  if (widget.post.postingImageUrl!.isNotEmpty) 
                    Image.network(widget.post.postingImageUrl!),
                ],
                Column(
                  children: [
                    Text('${account!.username} ${widget.post.postingDescription}', style: TextStyle(color: widget.colorPallete.fontColor)),
                  ],
                ),
                Row(
                  children: [
                    Column(
                      children: [
                        GestureDetector(
                          child: const Icon(Icons.favorite_border, color: Colors.red),
                        ),
                        Text(widget.post.countLikes.toString(), style: TextStyle(color: widget.colorPallete.fontColor)),
                      ],
                    ),
                    Column(
                      children: [
                        GestureDetector(
                          child: Icon(Icons.comment_rounded, color: widget.colorPallete.fontColor),
                        ),
                        Text(widget.post.countComments.toString(), style: TextStyle(color: widget.colorPallete.fontColor)),
                      ],
                    ),
                    GestureDetector(
                      child: Icon(Icons.share, color: widget.colorPallete.fontColor),
                    ),
                    GestureDetector(
                      child: Icon(Icons.bookmark, color: widget.colorPallete.fontColor),
                    ),
                  ],
                ),
              ],
            ),
            PopupMenuButton(
              itemBuilder: (context) => [],
              iconColor: widget.colorPallete.fontColor,
            ),
          ],
        ),
      );
  }
}