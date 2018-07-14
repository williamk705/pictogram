import 'dart:convert';

class Picture {
  final String id;
  final createdAt;
  final updatedAt;
  final Map<String, dynamic> urls;
  final Map<String, dynamic> links;

  Picture(this.id, this.createdAt, this.updatedAt, this.urls, this.links);

  Picture.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        createdAt = json['created_at'],
        updatedAt = json['updated_at'],
        urls = json['urls'],
        links = json['links'];

  Map<String, dynamic> toJson() =>
      {
        'id': id,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
        'urls': urls,
        'links': links
      };
}