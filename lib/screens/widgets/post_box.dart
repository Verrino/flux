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
                  Text('$username $postDescription'),
                ],
              ),
              Row(
                children: [
                  Column(
                    children: [
                      GestureDetector(
                        child: const Icon(Icons.favorite_border),
                      ),
                      Text(countLikes.toString()),
                    ],
                  ),
                  Column(
                    children: [
                      GestureDetector(
                        child: const Icon(Icons.comment_rounded),
                      ),
                      Text(countComments.toString()),
                    ],
                  ),
                  GestureDetector(
                    child: const Icon(Icons.share),
                  ),
                  GestureDetector(
                    child: const Icon(Icons.bookmark),
                  ),
                ],
              ),
            ],
          ),
          InkWell(
            child: Icon(Icons.menu),
          )
        ],
      ),
    );
  }
}