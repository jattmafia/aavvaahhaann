// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:avahan/core/models/play_group.dart';

class PlayState {
  final PlayGroup? session;
  // final bool isPlaying;
  // final Duration duration;

  PlayState({
    this.session,
    // this.isPlaying = false,
    // this.duration = Duration.zero,
  });

  PlayState copyWith({
    PlayGroup? session,
    // bool? isPlaying,
    // Duration? duration,
  }) {
    return PlayState(
      session: session ?? this.session,
      // isPlaying: isPlaying ?? this.isPlaying,
      // duration: duration ?? this.duration,
    );
  }
}
