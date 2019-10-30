
class SearchResponse {
  List<Item> items;
  bool hasMore;
  int quotaMax;
  int quotaRemaining;

  SearchResponse({
    this.items,
    this.hasMore,
    this.quotaMax,
    this.quotaRemaining,
  });

  factory SearchResponse.fromJson(Map<String, dynamic> json) => SearchResponse(
    items: List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
    hasMore: json["has_more"],
    quotaMax: json["quota_max"],
    quotaRemaining: json["quota_remaining"],
  );

}

class Item {
  List<String> tags;
  Owner owner;
  bool isAnswered;
  int viewCount;
  int answerCount;
  int score;
  int lastActivityDate;
  int creationDate;
  int lastEditDate;
  int questionId;
  String link;
  String title;
  int acceptedAnswerId;

  Item({
    this.tags,
    this.owner,
    this.isAnswered,
    this.viewCount,
    this.answerCount,
    this.score,
    this.lastActivityDate,
    this.creationDate,
    this.lastEditDate,
    this.questionId,
    this.link,
    this.title,
    this.acceptedAnswerId,
  });

  factory Item.fromJson(Map<String, dynamic> json) => Item(
    tags: List<String>.from(json["tags"].map((x) => x)),
    owner: Owner.fromJson(json["owner"]),
    isAnswered: json["is_answered"],
    viewCount: json["view_count"],
    answerCount: json["answer_count"],
    score: json["score"],
    lastActivityDate: json["last_activity_date"],
    creationDate: json["creation_date"],
    lastEditDate: json["last_edit_date"] == null ? null : json["last_edit_date"],
    questionId: json["question_id"],
    link: json["link"],
    title: json["title"],
    acceptedAnswerId: json["accepted_answer_id"] == null ? null : json["accepted_answer_id"],
  );

  static List<Item> fromJsonList(jsonList) {
    return jsonList.map<Item>((obj) => Item.fromJson(obj)).toList();
  }
}

class Owner {
  int reputation;
  int userId;
  String userType;
  int acceptRate;
  String profileImage;
  String displayName;
  String link;

  Owner({
    this.reputation,
    this.userId,
    this.userType,
    this.acceptRate,
    this.profileImage,
    this.displayName,
    this.link,
  });

  factory Owner.fromJson(Map<String, dynamic> json) => Owner(
    reputation: json["reputation"],
    userId: json["user_id"],
    userType: json["user_type"],
    acceptRate: json["accept_rate"],
    profileImage: json["profile_image"],
    displayName: json["display_name"],
    link: json["link"],
  );

}
