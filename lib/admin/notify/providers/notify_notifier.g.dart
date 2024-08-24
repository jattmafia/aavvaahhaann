// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notify_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$notifyNotifierHash() => r'c37daab1f43cc66a07f5186a4a68b375adf995a2';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$NotifyNotifier
    extends BuildlessAutoDisposeNotifier<NotifyState> {
  late final PushNotification? notification;

  NotifyState build(
    PushNotification? notification,
  );
}

/// See also [NotifyNotifier].
@ProviderFor(NotifyNotifier)
const notifyNotifierProvider = NotifyNotifierFamily();

/// See also [NotifyNotifier].
class NotifyNotifierFamily extends Family<NotifyState> {
  /// See also [NotifyNotifier].
  const NotifyNotifierFamily();

  /// See also [NotifyNotifier].
  NotifyNotifierProvider call(
    PushNotification? notification,
  ) {
    return NotifyNotifierProvider(
      notification,
    );
  }

  @override
  NotifyNotifierProvider getProviderOverride(
    covariant NotifyNotifierProvider provider,
  ) {
    return call(
      provider.notification,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'notifyNotifierProvider';
}

/// See also [NotifyNotifier].
class NotifyNotifierProvider
    extends AutoDisposeNotifierProviderImpl<NotifyNotifier, NotifyState> {
  /// See also [NotifyNotifier].
  NotifyNotifierProvider(
    PushNotification? notification,
  ) : this._internal(
          () => NotifyNotifier()..notification = notification,
          from: notifyNotifierProvider,
          name: r'notifyNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$notifyNotifierHash,
          dependencies: NotifyNotifierFamily._dependencies,
          allTransitiveDependencies:
              NotifyNotifierFamily._allTransitiveDependencies,
          notification: notification,
        );

  NotifyNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.notification,
  }) : super.internal();

  final PushNotification? notification;

  @override
  NotifyState runNotifierBuild(
    covariant NotifyNotifier notifier,
  ) {
    return notifier.build(
      notification,
    );
  }

  @override
  Override overrideWith(NotifyNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: NotifyNotifierProvider._internal(
        () => create()..notification = notification,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        notification: notification,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<NotifyNotifier, NotifyState>
      createElement() {
    return _NotifyNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is NotifyNotifierProvider &&
        other.notification == notification;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, notification.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin NotifyNotifierRef on AutoDisposeNotifierProviderRef<NotifyState> {
  /// The parameter `notification` of this provider.
  PushNotification? get notification;
}

class _NotifyNotifierProviderElement
    extends AutoDisposeNotifierProviderElement<NotifyNotifier, NotifyState>
    with NotifyNotifierRef {
  _NotifyNotifierProviderElement(super.provider);

  @override
  PushNotification? get notification =>
      (origin as NotifyNotifierProvider).notification;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
