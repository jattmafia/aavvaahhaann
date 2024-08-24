// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notifications_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$pushNotificationsHash() => r'b231f5dbcb52d4b70a9d39c5f8ae5dc38bb47835';

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

/// See also [pushNotifications].
@ProviderFor(pushNotifications)
const pushNotificationsProvider = PushNotificationsFamily();

/// See also [pushNotifications].
class PushNotificationsFamily
    extends Family<AsyncValue<List<PushNotification>>> {
  /// See also [pushNotifications].
  const PushNotificationsFamily();

  /// See also [pushNotifications].
  PushNotificationsProvider call({
    DateTime? date,
    DateTime? endDate,
    bool scheduled = false,
    bool template = false,
  }) {
    return PushNotificationsProvider(
      date: date,
      endDate: endDate,
      scheduled: scheduled,
      template: template,
    );
  }

  @override
  PushNotificationsProvider getProviderOverride(
    covariant PushNotificationsProvider provider,
  ) {
    return call(
      date: provider.date,
      endDate: provider.endDate,
      scheduled: provider.scheduled,
      template: provider.template,
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
  String? get name => r'pushNotificationsProvider';
}

/// See also [pushNotifications].
class PushNotificationsProvider
    extends AutoDisposeFutureProvider<List<PushNotification>> {
  /// See also [pushNotifications].
  PushNotificationsProvider({
    DateTime? date,
    DateTime? endDate,
    bool scheduled = false,
    bool template = false,
  }) : this._internal(
          (ref) => pushNotifications(
            ref as PushNotificationsRef,
            date: date,
            endDate: endDate,
            scheduled: scheduled,
            template: template,
          ),
          from: pushNotificationsProvider,
          name: r'pushNotificationsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$pushNotificationsHash,
          dependencies: PushNotificationsFamily._dependencies,
          allTransitiveDependencies:
              PushNotificationsFamily._allTransitiveDependencies,
          date: date,
          endDate: endDate,
          scheduled: scheduled,
          template: template,
        );

  PushNotificationsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.date,
    required this.endDate,
    required this.scheduled,
    required this.template,
  }) : super.internal();

  final DateTime? date;
  final DateTime? endDate;
  final bool scheduled;
  final bool template;

  @override
  Override overrideWith(
    FutureOr<List<PushNotification>> Function(PushNotificationsRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: PushNotificationsProvider._internal(
        (ref) => create(ref as PushNotificationsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        date: date,
        endDate: endDate,
        scheduled: scheduled,
        template: template,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<PushNotification>> createElement() {
    return _PushNotificationsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PushNotificationsProvider &&
        other.date == date &&
        other.endDate == endDate &&
        other.scheduled == scheduled &&
        other.template == template;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, date.hashCode);
    hash = _SystemHash.combine(hash, endDate.hashCode);
    hash = _SystemHash.combine(hash, scheduled.hashCode);
    hash = _SystemHash.combine(hash, template.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin PushNotificationsRef
    on AutoDisposeFutureProviderRef<List<PushNotification>> {
  /// The parameter `date` of this provider.
  DateTime? get date;

  /// The parameter `endDate` of this provider.
  DateTime? get endDate;

  /// The parameter `scheduled` of this provider.
  bool get scheduled;

  /// The parameter `template` of this provider.
  bool get template;
}

class _PushNotificationsProviderElement
    extends AutoDisposeFutureProviderElement<List<PushNotification>>
    with PushNotificationsRef {
  _PushNotificationsProviderElement(super.provider);

  @override
  DateTime? get date => (origin as PushNotificationsProvider).date;
  @override
  DateTime? get endDate => (origin as PushNotificationsProvider).endDate;
  @override
  bool get scheduled => (origin as PushNotificationsProvider).scheduled;
  @override
  bool get template => (origin as PushNotificationsProvider).template;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
