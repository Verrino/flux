import 'package:flutter/material.dart';
import 'package:flux/color_pallete.dart';

class PostBox extends StatelessWidget {
  final ColorPallete colorPallete;
  final String username;
  final String postDescription;
  final String pictureProfileUrl;
  final DateTime postedTime;
  final int countLikes;
  final int countComments;

  final String? postingImageUrl;

  const PostBox({
    super.key, 
    required this.colorPallete, 
    required this.username, 
    required this.postDescription, 
    required this.pictureProfileUrl, 
    required this.postedTime, 
    required this.countLikes, 
    required this.countComments,
    this.postingImageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: colorPallete.postBackgroundColor,
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
                  CircleAvatar(
                    backgroundImage: NetworkImage(pictureProfileUrl),
                  ),
                  Text(
                    username, 
                    style: TextStyle(
                      color: colorPallete.fontColor
                    ),
                    ),
                  Text(
                    '1h',
                    style: TextStyle(
                      color: colorPallete.fontColor.withOpacity(0.4),
                    ),
                  ),
                ],
              ),
              if (postingImageUrl != null) ... [
                Image.network(postingImageUrl!),
              ],
              Column(
                children: [
                  Text('$username $postDescription', style: TextStyle(color: colorPallete.fontColor)),
                ],
              ),
              Row(
                children: [
                  Column(
                    children: [
                      GestureDetector(
                        child: const Icon(Icons.favorite_border, color: Colors.red,),
                      ),
                      Text(countLikes.toString(), style: TextStyle(color: colorPallete.fontColor)),
                    ],
                  ),
                  Column(
                    children: [
                      GestureDetector(
                        child: Icon(Icons.comment_rounded, color: colorPallete.fontColor),
                      ),
                      Text(countComments.toString(), style: TextStyle(color: colorPallete.fontColor)),
                    ],
                  ),
                  GestureDetector(
                    child: Icon(Icons.share, color: colorPallete.fontColor),
                  ),
                  GestureDetector(
                    child: Icon(Icons.bookmark, color: colorPallete.fontColor),
                  ),
                ],
              ),
            ],
          ),
          PopupMenuButton(
            itemBuilder: (context) => [],
            iconColor: colorPallete.fontColor,
          ),
        ],
      ),
    );
  }
}