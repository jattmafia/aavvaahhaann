import 'package:avahan/core/enums/avahan_data_type.dart';
import 'package:avahan/core/models/app_banner.dart';
import 'package:avahan/core/providers/master_data_provider.dart';
import 'package:avahan/core/repositories/master_data_repository.dart';
import 'package:avahan/features/subscriptions/providers/premium_provider.dart';
import 'package:avahan/features/subscriptions/providers/subscription_notifier.dart';
import 'package:avahan/utils/dates.dart';
import 'package:avahan/utils/extensions.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:url_launcher/url_launcher_string.dart';

class BannerView extends ConsumerWidget {
  const BannerView({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var banners = ref.read(masterDataProvider).asData?.value.banners ?? [];

    final premium = ref.watch(premiumProvider).asData?.value ?? false;

    banners = banners
        .where((element) =>
            element.active &&
            (element.dateTimeSlot != null
                ? element.dateTimeSlot!.start.isBefore(Dates.now) &&
                    element.dateTimeSlot!.end.isAfter(Dates.now)
                : true))
        .where((element) => element.action == 'premium' ? !premium : true)
        .toList();

    final v = banners.length > 1 ? 32 : 0;

    if (banners.isEmpty) {
      return const SizedBox.shrink();
    }

    print(banners.map((e) => e.image).toList());

    return LayoutBuilder(
      builder: (context, ctx) {
        final width = ctx.maxWidth;
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: CarouselSlider(
            options: CarouselOptions(
              autoPlay: true,
              enableInfiniteScroll: banners.length > 1 ? true : false,
              autoPlayInterval: const Duration(seconds: 5),
              height: ((width - (v + 24)) / 3),
              viewportFraction:
                  banners.length > 1 ? ((width - (v + 24)) / (width)) : 1,
            ),
            items: banners.map(
              (i) {
                return Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: banners.length == 1 ? 16 : 4),
                  child: GestureDetector(
                    onTap: () {
                      if(i.id != null){
                        ref.read(masterDataRepositoryProvider).createBannerClickEvent(i.id!);
                      }
                      final type = AvahanDataType.values.firstWhere(
                          (element) => element.name == i.action,
                          orElse: () => AvahanDataType.unknown);
                      if (type != AvahanDataType.unknown &&
                          i.ids != null &&
                          i.ids!.isNotEmpty) {
                        context.push(
                          '',
                          ref: ref,
                          extra: MapEntry(type, i.ids!),
                        );
                      } else if (i.action == 'link' && i.link?.crim != null) {
                        launchUrlString(i.link!,
                            mode: LaunchMode.externalApplication);
                      } else if (i.action == "premium") {
                        ref.read(subscriptionProvider).init();
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        image: DecorationImage(
                          image: CachedNetworkImageProvider(i.imageUrl(ref.lang)),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ).toList(),
          ),
        );
      },
    );
  }
}
