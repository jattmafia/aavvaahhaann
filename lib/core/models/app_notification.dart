// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

class AppNotification {
  final String messageId;
  final String title;
  final String body;
  final String? imageUrl;
  final String? type;
  final List<int>? ids;
  final String? link;
  final DateTime receivedAt;
  final String? selected;
    final bool seen;


  AppNotification({
    required this.messageId,
    required this.title,
    required this.body,
    this.imageUrl,
    required this.type,
    required this.ids,
    required this.receivedAt,
    this.selected,
    this.seen = false,
    this.link,
  });


  factory AppNotification.fromMessage(RemoteMessage message, bool seen) {
    print(message.toMap());
    return AppNotification(
      messageId: message.messageId ?? '',
      title: message.notification?.title ?? '',
      body: message.notification?.body ?? '',
      imageUrl: defaultTargetPlatform == TargetPlatform.android
          ? message.notification?.android?.imageUrl
          : message.notification?.apple?.imageUrl,
      type: message.data['type'],
      ids: message.data['ids'] != null ? List<int>.from((jsonDecode(message.data['ids']) as Iterable).map((e) => int.tryParse("$e")).where((element) => element != null)) : null,
      receivedAt: message.sentTime ?? DateTime.now(),
      selected: message.data['selected'],
      seen: seen,
      link: message.data['link'],
    );
  }

  

  Map<String, dynamic> toMap() {
    return {
      'messageId': messageId,
      'title': title,
      'body': body,
      'imageUrl': imageUrl,
      'type': type,
      'ids': ids,
      'receivedAt': receivedAt.millisecondsSinceEpoch,
      'selected': selected,
      'seen': seen,
      'link': link,
    };
  }

  factory AppNotification.fromMap(Map<String, dynamic> map) {
    print(map);
    return AppNotification(
      messageId: map['messageId'] ?? '',
      title: map['title'] ?? '',
      body: map['body'] ?? '',
      imageUrl: map['imageUrl'],
      type: map['type'],
      ids: map['ids'] != null ? List<int>.from(map['ids']) : null,
      receivedAt: DateTime.fromMillisecondsSinceEpoch(map['receivedAt']),
      selected: map['selected'],
      seen: map['seen'] ?? false,
      link: map['link'],
    );
  }

  String toJson() => json.encode(toMap());

  factory AppNotification.fromJson(String source) => AppNotification.fromMap(json.decode(source));

  AppNotification copyWith({
    String? messageId,
    String? title,
    String? body,
    String? imageUrl,
    String? type,
    List<int>? ids,
    DateTime? receivedAt,
    String? selected,
    bool? seen,
    String? link,
  }) {
    return AppNotification(
      messageId: messageId ?? this.messageId,
      title: title ?? this.title,
      body: body ?? this.body,
      imageUrl: imageUrl ?? this.imageUrl,
      type: type ?? this.type,
      ids: ids ?? this.ids,
      receivedAt: receivedAt ?? this.receivedAt,
      selected: selected ?? this.selected,
      seen: seen ?? this.seen,
      link: link ?? this.link,
    );
  }
}
