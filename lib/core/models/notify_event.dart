class NotifyEvent {
  final String messageId;
  final int? uid;
  
  NotifyEvent({
    required this.messageId,
    required this.uid,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'messageId': messageId,
      'uid': uid,
    };
  }

  factory NotifyEvent.fromMap(Map<String, dynamic> map) {
    return NotifyEvent(
      messageId: map['messageId'] as String,
      uid: map['uid'] as int,
    );
  }
}
