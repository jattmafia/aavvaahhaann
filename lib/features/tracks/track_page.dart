// ignore_for_file: use_build_context_synchronously

import 'dart:math';

import 'package:avahan/core/enums/avahan_data_type.dart';
import 'package:avahan/core/enums/library_item_type.dart';
import 'package:avahan/core/models/artist.dart';
import 'package:avahan/core/models/library_item.dart';
import 'package:avahan/core/models/mood.dart';
import 'package:avahan/core/models/music_category.dart';
import 'package:avahan/core/models/play_group.dart';
import 'package:avahan/core/models/playlist.dart';
import 'package:avahan/core/models/track.dart';
import 'package:avahan/core/providers/client_provider.dart';
import 'package:avahan/core/providers/player_provider.dart';
import 'package:avahan/core/providers/sharer_provider.dart';
import 'package:avahan/core/repositories/library_item_repository.dart';
import 'package:avahan/features/components/description_text.dart';
import 'package:avahan/features/library/providers/library_items_provider.dart';
import 'package:avahan/features/profile/providers/your_profile_provider.dart';
import 'package:avahan/features/tracks/providers/play_notifier_provider.dart';
import 'package:avahan/features/tracks/providers/tracks_provider.dart';
import 'package:avahan/utils/extensions.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:url_launcher/url_launcher_string.dart';

class TrackPage extends ConsumerWidget {
  const TrackPage({super.key});

  static const route = '/track';

  

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final labels = context.labels;
    final state = ref.read(playNotifierProvider);
    final notifier = ref.read(playNotifierProvider.notifier);
    final player = ref.read(playerProvider);
    final lang = ref.lang;
    final library = ref.watch(libraryItemsProvider).asData?.value ?? [];
    var slidduration = Duration.zero;
seek(value) async {
   slidduration =  Duration(seconds: value.toInt());
  
  }
    return StreamBuilder(
      stream: player.currentIndexStream,
      builder: (context, snapshot) {
        final index = snapshot.data ?? 0;
        final track = notifier.track(index);
        final image = track.icon(lang);

        final libraryItem = library
            .where((element) =>
                element.itemId == track.id &&
                element.type == LibraryItemType.track)
            .firstOrNull;

        final isInLibrary = libraryItem != null;

        return HookConsumer(
          builder: (context, ref, child) {
            final memorised = useMemoized(
                () => ColorScheme.fromImageProvider(
                      provider: CachedNetworkImageProvider(image),
                    ),
                []);
            final schemeAsync = useFuture(memorised);
            final scheme = schemeAsync.data ?? context.scheme;
            return Scaffold(
              body: SingleChildScrollView(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        scheme.primaryContainer,
                        scheme.primaryContainer.withOpacity(0),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      AppBar(
                        forceMaterialTransparency: true,
                        leading: IconButton(
                          icon: Transform.rotate(
                            angle: pi / 2,
                            child: const Icon(Icons.arrow_forward_ios_rounded),
                          ),
                          onPressed: () => context.pop(),
                        ),
                        // actions: [
                        // IconButton(
                        //   icon: const Icon(Icons.more_vert_rounded),
                        //   onPressed: () {},
                        // ),
                        // ],
                        title: notifier.root.key != AvahanDataType.track
                            ? Column(
                                children: [
                                  Text(
                                    labels
                                        .playingFrom(notifier.root.key.name)
                                        .toUpperCase(),
                                    style: context.style.bodySmall,
                                  ),
                                  Text(
                                    switch (notifier.root.key) {
                                      AvahanDataType.artist =>
                                        (state.session!.data as Artist)
                                            .name(lang),
                                      AvahanDataType.playlist =>
                                        (state.session!.data as Playlist)
                                            .name(lang),
                                      AvahanDataType.mood =>
                                        (state.session!.data as Mood)
                                            .name(lang),
                                      AvahanDataType.category =>
                                        (state.session!.data as MusicCategory)
                                            .name(lang),
                                      _ => "",
                                    },
                                    style: context.style.titleSmall,
                                  ),
                                ],
                              )
                            : null,
                        actions: [
                          IconButton(
                            onPressed: () async {
                              ref.read(shareProvider).shareTrack(track);
                            },
                            icon: const Icon(Icons.share),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: AspectRatio(
                                aspectRatio: 1,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(6),
                                  child: CachedNetworkImage(
                                    imageUrl: image,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              track.name(lang),
                                              style: context.style.titleLarge!
                                                  .copyWith(
                                                      color: scheme
                                                          .onPrimaryContainer),
                                            ),
                                            Text(
                                              track.artistsLabel(ref, lang),
                                              style: TextStyle(
                                                  color: scheme.outline),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () async {
                                        final repository = ref.read(
                                            libraryItemRepositoryProvider);
                                        if (isInLibrary) {
                                          await repository
                                              .deleteLibraryItem(libraryItem);
                                          context.message(
                                              labels.removedFromLikedMusic);
                                        } else {
                                          await repository.writeLibraryItem(
                                            LibraryItem(
                                              id: 0,
                                              createdAt: DateTime.now(),
                                              createdBy: ref
                                                  .read(yourProfileProvider)
                                                  .value!
                                                  .id,
                                              type: LibraryItemType.track,
                                              itemId: track.id,
                                            ),
                                          );
                                          context.message(
                                              labels.addedToLikedMusic);
                                        }
                                        ref.refresh(libraryItemsProvider);
                                      },
                                      icon: isInLibrary
                                          ? const Icon(
                                              Icons.library_add_check,
                                              color: Colors.green,
                                            )
                                          : const Icon(
                                              Icons.library_add_outlined,
                                            ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      SliderUi(),
                       const SizedBox(height: 16),
                      if (track.description(lang) != null)
                        Padding(
                          padding: const EdgeInsets.all(16.0).copyWith(top: 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              DescriptionText(
                                track.description(lang)!,
                              ),
                              ...(track.links ?? []).map(
                                (e) => GestureDetector(
                                  onTap: () {
                                    launchUrlString(e.split('|').last);
                                  },
                                  child: Row(
                                    children: [
                                      Text(
                                        e.split('|').first,
                                        style: const TextStyle(
                                            color: Colors.blueAccent),
                                      ),
                                      const SizedBox(width: 4),
                                      Icon(
                                        Icons.open_in_new,
                                        size: 16,
                                        color: Colors.blueGrey.withOpacity(0.5),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      if (track.lyrics(lang) != null)
                        Padding(
                          padding: const EdgeInsets.all(16.0).copyWith(top: 0),
                          child: Material(
                            color: scheme.primaryContainer,
                            borderRadius: BorderRadius.circular(12),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                track.lyrics(lang)!,
                                style: context.style.bodyLarge?.copyWith(
                                  color: scheme.onPrimaryContainer,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}


class SliderUi extends HookConsumerWidget{
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
     final player = ref.read(playerProvider);
      final notifier = ref.read(playNotifierProvider.notifier);
      bool checkplay = true;
      bool holdplaybutton = false;

    nextTrack() async {
        try    { final response =    await ref.read(clientProvider).rpc('get_random_active_track');
                              print(response[0]as Map<String, dynamic>);
                               final Map<String, dynamic> data = response[0]as Map<String, dynamic>;
                              

                               Track track = Track.fromMap(data);
                               print(track.id);
                                final trackId = track.id;
                                 if (trackId != null) {
           
            
              final tracck = await ref
                  .read(tracksProvider(ids: [trackId]).future)
                  .then(
                    (value) => value.firstOrNull,
                  );
              if (tracck != null) {
              ref.read(playNotifierProvider.notifier).startPlaySession(
                      PlayGroup(
                        data: null,
                        tracks: [tracck],
                        start: tracck,
                      ),
                    );
                    
                    print(notifier.track(0));

    //                 Future.delayed(Duration(seconds: 2), () {
    //   context.replace(TrackPage.route);
    // });
                 Navigator.pushReplacement(
  context, 
  PageRouteBuilder(
    pageBuilder: (BuildContext context, Animation<double> animation1, Animation<double> animation2) {
      return const TrackPage();
    },
    transitionDuration: Duration.zero,
    reverseTransitionDuration: Duration.zero,
  ),
);
               print("not came here");

         

              }
           
                                 }
}catch(e){
  rethrow;
  print("this is error ${e.toString()}");

}
    }

   return  StreamBuilder(
                        stream: player.positionStream,
                        builder: (context, snapshot) {
                          final duration = player.duration ?? Duration.zero;
                          final position = snapshot.data ?? Duration.zero;
                          
                          return Column(
                            children: [
                              Stack(
                                alignment: Alignment.bottomCenter,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 24),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          position.playLabel,
                                          style: TextStyle(
                                            color: context.scheme.outline,
                                          ),
                                        ),
                                        Text(
                                          (Duration(
                                                  microseconds: duration
                                                          .inMicroseconds -
                                                      position.inMicroseconds))
                                              .playLabel,
                                          style: TextStyle(
                                            color: context.scheme.outline,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SliderTheme(
                                    data: const SliderThemeData(
                                      trackHeight: 2,
                                      thumbShape: RoundSliderThumbShape(
                                          enabledThumbRadius: 5.0),
                                    ),
                                    child: Slider(
                                      value: position.inSeconds.toDouble(),
                                      max: duration.inSeconds.toDouble(),
                                      onChanged: (value) {
                                         player.seek(
                                            Duration(seconds: value.toInt()));
                                        
                                      },
                                      onChangeStart: (value) {
                                        if(player.playerState.playing){
                                          checkplay = false;
                                          holdplaybutton = true;
                                          notifier.pausePlaySession();
                                        }
                                        
                                      },
                                      onChangeEnd: (value) {
                                        if(!checkplay){
                                          holdplaybutton = false;
                                           notifier.resumePlaySession();
                                        }

                                       
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 20,right: 20),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    StreamBuilder(
                                      initialData: player.playing,
                                            stream: player.loopModeStream,
                                      builder: (BuildContext context, AsyncSnapshot snapshot) { 
                                        LoopMode loop = player.loopMode;
                                      return  SizedBox(
                                        width: 40,
                                        child: IconButton(onPressed: (){
                                          notifier.setloop();
                                          
                                        }, icon: Icon(Icons.loop_rounded,color: loop == LoopMode.one ? context.scheme.primary : Colors.black38,)));
                                  
                                       },
                                        ),
                                   
                                    Row(
                                      
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        IconButton(
                                          iconSize: 48,
                                          onPressed: () async {
                                            
                                            // var a =  await ref.read(clientProvider).rpc('get_user_play_session_list');
                                            // print(a);
                                   //  var res =         await ref.read(clientProvider).rpc('get_user_filter_tracktry');
                                    





                                      //                             var res =         await ref.read(clientProvider).rpc('get_user_play_session_list').like('userid', '%25%');
                                      //  print(res);
                                        
                                        
                                        
                                          //    if(notifier.root.key == AvahanDataType.unknown || notifier.root.key == AvahanDataType.track) {
                                          //       try{
                                          //    await nextTrack();
                                           
                                          //   }catch(e){
                                          //     nextTrack();
                                          //     print("try again");
                                          //   }
                                          //   }else{
                                          //   notifier.previousPlaySession();}
                                          
                                           },
                                          icon:
                                              const Icon(Icons.skip_previous_rounded),
                                        ),
                                        const SizedBox(width: 20),
                                        SizedBox(
                                          width: 72,
                                          height: 72,
                                          child: StreamBuilder<bool>(
                                            initialData: player.playing,
                                            stream: player.playingStream,
                                            builder: (context, snapshot) {
                                             
                                              final playing = duration.inSeconds ==
                                                      position.inSeconds
                                                  ? false
                                                  : (snapshot.data ?? false);
                                              return FloatingActionButton(
                                                backgroundColor:
                                                    context.scheme.primary,
                                                focusElevation: 0,
                                                hoverElevation: 0,
                                                elevation: 0,
                                                foregroundColor:
                                                    context.scheme.onPrimary,
                                                shape: const CircleBorder(),
                                                onPressed: () {
                                                  if (playing) {
                                                    
                                                    notifier.pausePlaySession();
                                                    checkplay = !checkplay;
                                                  } else {
                                                    if (position.inSeconds ==
                                                        duration.inSeconds) {
                                                      notifier.replayPlaySession();
                                                      checkplay = !checkplay;
                                                    } else {
                                                      notifier.resumePlaySession();
                                                      checkplay = !checkplay;
                                                    }
                                                  }
                                                },
                                                child: playing || holdplaybutton
                                                    ? const Icon(
                                                        Icons.pause_rounded,
                                                        size: 48,
                                                      )
                                                    : const Icon(
                                                        Icons.play_arrow_rounded,
                                                        size: 48,
                                                      ),
                                              );
                                            },
                                          ),
                                        ),
                                        const SizedBox(width: 20),
                                        IconButton(
                                          iconSize: 48,
                                          onPressed: () async{
                                            print("this is tack type ${notifier.root.key}");
                                            
                                            if(notifier.root.key == AvahanDataType.unknown || notifier.root.key == AvahanDataType.track) {
                                                try{
                                             await nextTrack();
                                           
                                            }catch(e){
                                              nextTrack();
                                              print("try again");
                                            }
                                            }else{
                                              notifier.nextPlaySession();
                                            }
                                    
                                          
                                           
                                    
                                           // notifier.nextPlaySession();
                                            },
                                          icon: const Icon(Icons.skip_next_rounded),
                                        ),
                                      ],
                                    ),
                                
                                 SizedBox(width: 40,)
                                 
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    
  }

}

