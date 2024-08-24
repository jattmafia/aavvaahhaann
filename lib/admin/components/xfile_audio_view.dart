import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class XFileAudioView extends StatefulWidget {
  const XFileAudioView({super.key, this.file, this.url, this.duration});

  final PlatformFile? file;
  final String? url;
  final ValueChanged<int>? duration;
  @override
  State<XFileAudioView> createState() => _XFileAudioViewState();
}

class _XFileAudioViewState extends State<XFileAudioView> {
  final AudioPlayer audioPlayer = AudioPlayer();

  bool isPlaying = false;

  Duration currentPosition = Duration.zero;

  Duration totalDuration = Duration.zero;

  Stream<Duration> get positionStream => audioPlayer.positionStream;

  @override
  void initState() {
    super.initState();
    init();
    positionStream.listen((position) {
      setState(() {
        currentPosition = position;
        if (currentPosition == totalDuration) {
          isPlaying = false;
        }
      });
    });
  }

  void init() async {
    if (widget.file != null) {
      final bytes = widget.file!.bytes!;
      await audioPlayer.setAudioSource(BufferAudioSource(bytes)).then((value) {
        if (value != null) {
          widget.duration?.call(value.inSeconds);
          setState(() {
            totalDuration = value;
          });
        }
      });
    } else if (widget.url != null) {
      await audioPlayer.setUrl(widget.url!).then((value) {
        if (value != null) {
          widget.duration?.call(value.inSeconds);
          setState(() {
            totalDuration = value;
          });
        }
      });
    }
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes);

    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    if (totalDuration.inSeconds == 0) {
      return const SizedBox();
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Text(
                '${_formatDuration(currentPosition)} / ${_formatDuration(totalDuration)}',
                style: const TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.end,
              ),
              Expanded(
                child: Slider(
                  value: currentPosition.inSeconds.toDouble(),
                  max: totalDuration.inSeconds.toDouble(),
                  onChanged: (value) {
                    audioPlayer.seek(Duration(seconds: value.toInt()));
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.fast_rewind),
                    onPressed: () {
                      audioPlayer.seek(currentPosition - const Duration(seconds: 10));
                    },
                  ),
                  const SizedBox(width: 16),
                  IconButton(
                    icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                    iconSize: 40,
                    onPressed: () {
                      setState(() {
                        if (isPlaying) {
                          audioPlayer.pause();
                        } else {
                          audioPlayer.play();
                        }
                        isPlaying = !isPlaying;
                      });
                    },
                  ),
                  const SizedBox(width: 16),
                  IconButton(
                    icon: const Icon(Icons.fast_forward),
                    onPressed: () {
                      audioPlayer.seek(currentPosition + const Duration(seconds: 10));
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class BufferAudioSource extends StreamAudioSource {
  final Uint8List _buffer;

  BufferAudioSource(this._buffer);

  @override
  Future<StreamAudioResponse> request([int? start, int? end]) {
    start = start ?? 0;
    end = end ?? _buffer.length;

    return Future.value(
      StreamAudioResponse(
        sourceLength: _buffer.length,
        contentLength: end - start,
        offset: start,
        contentType: 'audio/mpeg',
        stream:
            Stream.value(List<int>.from(_buffer.skip(start).take(end - start))),
      ),
    );
  }
}
