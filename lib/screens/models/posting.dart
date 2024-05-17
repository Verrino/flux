class Posting {
  String? postingImageUrl;
  final String? uid;
  final String? postId;
  final String postingDescription;
  final String location;
  final int countLikes;
  final int countComments;
  final DateTime postedTime;

  Posting(
    {required this.postingDescription, 
    required this.location, 
    this.postingImageUrl, 
    required this.countLikes,
    required this.countComments,
    required this.postedTime,
    required this.postId,
    required this.uid});

  factory Posting.fromJson(Map<String, dynamic> json) {
    return Posting(
      postingDescription: json['description'],
      location: json['location'],
      postingImageUrl: json['posting_image_url'], 
      countLikes: json['count_likes'],
      countComments: json['count_comments'],
      postedTime: DateTime.now(), 
      postId: json['post_id'], 
      uid: json['uid'],
    );
  }
}