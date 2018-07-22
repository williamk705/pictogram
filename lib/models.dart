class Photographer {
  final String name;
  final String firstName;
  final String lastName;
  final String twitterUsername;
  final String portfolio;
  final String bio;
  final String location;
  final String instagramUsername;

  Photographer.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        firstName = json['first_name'],
        lastName = json['last_name'],
        twitterUsername = json['twitter_username'],
        portfolio = json['portfolio'],
        bio = json['bio'],
        location = json['location'],
        instagramUsername = json['instagram_username'];

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'first_name': firstName,
      'last_name': lastName,
      'twitter_username': twitterUsername,
      'portfolio': portfolio,
      'bio': bio,
      'location': location,
      'instagram_username': instagramUsername
    };
  }

}

class Urls {
  final String raw;
  final String full;
  final String regular;
  final String small;
  final String thumb;

  Urls.fromJson(Map<String, dynamic> json)
      : raw = json['raw'],
        full = json['full'],
        regular = json['regular'],
        small = json['small'],
        thumb = json['thumb'];

  Map<String, dynamic> toJson() {
    return {
      'raw': raw,
      'full': full,
      'regular': regular,
      'small': small,
      'thumb': thumb
    };
  }
}

class Picture {
  final String id;
  final int likes;
  final Urls urls;
  final Photographer user;

  Picture.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        likes = json['likes'],
        urls = new Urls.fromJson(json['urls']),
        user = new Photographer.fromJson(json['user']);

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'likes': likes,
      'urls': urls.toJson(),
      'user': user.toJson()
    };
  }

  static List fromList(List data) {
    final pictureList = [];
    for(var item in data) {
      pictureList.add(new Picture.fromJson(item));
    }

    return pictureList;
  }
}