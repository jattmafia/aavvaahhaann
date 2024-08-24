// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:avahan/core/models/track.dart';
import 'package:flutter/material.dart';

class ViewState {
  final String name;
  final String? description;
  final String cover;
  final bool isInLibrary;
  final VoidCallback onLibraryTap;
  final VoidCallback onDownloadTap;
  final bool isPlaying;
  final VoidCallback onPlayTap;
  final VoidCallback? onShareTap;
  final int tracksCount;
  final Widget child;
  final List<Track> tracks;


  ViewState({
    required this.name,
    required this.description,
    required this.cover,
    required this.isInLibrary,
    required this.onLibraryTap,
    required this.onDownloadTap,
    required this.isPlaying,
    required this.onPlayTap,
    required this.tracksCount,
    required this.child,
    required this.tracks,
     this.onShareTap,
  });
}
