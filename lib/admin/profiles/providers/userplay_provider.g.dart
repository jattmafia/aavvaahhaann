// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'userplay_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$userSongListHash() => r'd88c63db1f2b00e1a47aad59e700ca48291a80ff';

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

/// See also [userSongList].
@ProviderFor(userSongList)
const userSongListProvider = UserSongListFamily();

/// See also [userSongList].
class UserSongListFamily extends Family<AsyncValue<List<UserTodaySongs>>> {
  /// See also [userSongList].
  const UserSongListFamily();

  /// See also [userSongList].
  UserSongListProvider call(
    String id,
    String date,
  ) {
    return UserSongListProvider(
      id,
      date,
    );
  }

  @override
  UserSongListProvider getProviderOverride(
    covariant UserSongListProvider provider,
  ) {
    return call(
      provider.id,
      provider.date,
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
  String? get name => r'userSongListProvider';
}

/// See also [userSongList].
class UserSongListProvider extends FutureProvider<List<UserTodaySongs>> {
  /// See also [userSongList].
  UserSongListProvider(
    String id,
    String date,
  ) : this._internal(
          (ref) => userSongList(
            ref as UserSongListRef,
            id,
            date,
          ),
          from: userSongListProvider,
          name: r'userSongListProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$userSongListHash,
          dependencies: UserSongListFamily._dependencies,
          allTransitiveDependencies:
              UserSongListFamily._allTransitiveDependencies,
          id: id,
          date: date,
        );

  UserSongListProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
    required this.date,
  }) : super.internal();

  final String id;
  final String date;

  @override
  Override overrideWith(
    FutureOr<List<UserTodaySongs>> Function(UserSongListRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: UserSongListProvider._internal(
        (ref) => create(ref as UserSongListRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        id: id,
        date: date,
      ),
    );
  }

  @override
  FutureProviderElement<List<UserTodaySongs>> createElement() {
    return _UserSongListProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UserSongListProvider &&
        other.id == id &&
        other.date == date;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);
    hash = _SystemHash.combine(hash, date.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin UserSongListRef on FutureProviderRef<List<UserTodaySongs>> {
  /// The parameter `id` of this provider.
  String get id;

  /// The parameter `date` of this provider.
  String get date;
}

class _UserSongListProviderElement
    extends FutureProviderElement<List<UserTodaySongs>> with UserSongListRef {
  _UserSongListProviderElement(super.provider);

  @override
  String get id => (origin as UserSongListProvider).id;
  @override
  String get date => (origin as UserSongListProvider).date;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
