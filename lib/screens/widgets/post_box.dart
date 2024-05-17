import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flux/color_pallete.dart';
import 'package:flux/screens/models/account.dart';
import 'package:flux/screens/models/posting.dart';
import 'package:flux/screens/navigation/profile_screen.dart';
import 'package:flux/screens/widgets/comment_box.dart';
import 'package:flux/services/post_service.dart';
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
  bool? _isLiked;

  bool _isLoading = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initialize();
  }

  void initialize() async {
    if (widget.post.likes.contains(FirebaseAuth.instance.currentUser!.uid)) {
      setState(() {
        _isLiked = true;
      });
    }
    else {
      setState(() {
        _isLiked = false;
      });
    }
    account ??= await ProfileService.getAccountByUid(widget.uid).whenComplete(() {
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
                GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen(account: account!)));
                  },
                  child: Row(
                    children: [
                      account!.profilePictureUrl.isNotEmpty ?
                        CircleAvatar(
                          backgroundImage: NetworkImage(account!.profilePictureUrl),
                        ) :
                        const CircleAvatar(),
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
                ),
                if (widget.post.postingImageUrl != null) ... [
                  if (widget.post.postingImageUrl!.isNotEmpty) 
                    GestureDetector(
                      onDoubleTap: () {
                        try {
                          if (!_isLiked! && widget.post.uid != FirebaseAuth.instance.currentUser!.uid) {
                            PostService.like(FirebaseAuth.instance.currentUser!.uid, widget.post).whenComplete(() => initialize());
                          }
                        } catch (e) {
                          print("error");
                        }
                      },
                      child: Image.network(widget.post.postingImageUrl!),
                    ),
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
                          onTap: () {
                            try {
                              if (_isLiked! && widget.post.uid != FirebaseAuth.instance.currentUser!.uid) {
                                PostService.dislike(FirebaseAuth.instance.currentUser!.uid, widget.post).whenComplete(() => initialize());
                              }
                              else {
                                if (widget.post.uid != FirebaseAuth.instance.currentUser!.uid) {
                                  PostService.like(FirebaseAuth.instance.currentUser!.uid, widget.post).whenComplete(() => initialize());
                                }
                              }
                            } catch (e) {
                              print("error");
                            }
                          },
                          child: _isLiked ?? false ? const Icon(Icons.favorite, color: Colors.red) : Icon(Icons.favorite_border, color: widget.colorPallete.fontColor),
                        ),
                        Text(widget.post.likes.length.toString(), style: TextStyle(color: widget.colorPallete.fontColor)),
                      ],
                    ),
                    Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              builder: (context) {
                                TextEditingController commentController = TextEditingController();
                                List<Widget> children = [];
                                widget.post.comments.forEach((key, value) {
                                  children.add(
                                    CommentBox(uid: key, colorPallete: widget.colorPallete, comment: value)
                                  );
                                  children.add(
                                    const SizedBox(height: 10)
                                  );
                                });
                                return Container(
                                  padding: EdgeInsets.only(top: 20, left: 12, right: 12, bottom: MediaQuery.of(context).viewInsets.bottom),
                                  width: double.infinity,
                                  constraints: const BoxConstraints(
                                    maxHeight: 600,
                                    minHeight: 300,
                                  ),
                                  decoration: BoxDecoration(
                                    color: widget.colorPallete.backgroundColor,
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(20), 
                                      topRight: Radius.circular(20),
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Column(
                                        children: children,
                                      ),
                                      TextField(
                                        controller: commentController,
                                        decoration: InputDecoration(
                                          suffixIcon: IconButton(
                                            icon: Icon(Icons.chevron_right_rounded, color: widget.colorPallete.fontColor),
                                            onPressed: () {
                                              PostService.comment(FirebaseAuth.instance.currentUser!.uid, commentController.text, widget.post);
                                            },
                                          ),
                                          
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(20), 
                                            borderSide: BorderSide(color: widget.colorPallete.fontColor),
                                          ),
                                        ),
                                        style: TextStyle(
                                          color: widget.colorPallete.fontColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                            });
                          },
                          child: Icon(Icons.comment_rounded, color: widget.colorPallete.fontColor),
                        ),
                        Text(widget.post.comments.length.toString(), style: TextStyle(color: widget.colorPallete.fontColor)),
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