import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive_intro/constans/hive_constants.dart';
import 'package:hive_intro/home/model/user_model.dart';

abstract class ICacheManager<T> {
  final String key;
  Box<UserModel>? _box;

  ICacheManager(this.key);
  Future<void> init() async {
    registerAdapter();
    if (!(_box?.isOpen ?? false)) {
      _box = await Hive.openBox("_userCacheoZo");
    }
  }

  void registerAdapter();

  Future<void> addItems(List<T> items);
  Future<void> putItems(List<T> items);

  List<T>? getValues();
  T? getItem(String key);
  Future<void> putItem(String key, T item);
  Future<void> removeItem(String key);
  Future<void> clearAll(String key) async {
    await _box?.clear();
  }
}

class UserCacheManager extends ICacheManager<UserModel> {
  UserCacheManager(String key) : super(key);

  @override
  Future<void> addItems(List<UserModel> items) async {
    await _box?.addAll(items);
  }

  @override
  Future<void> putItems(List<UserModel> items) async {
    await _box?.putAll(Map.fromEntries(items.map((e) => MapEntry(e.id, e))));
  }

  @override
  UserModel? getItem(String key) {
    return _box?.get(key);
  }

  @override
  Future<void> putItem(String key, UserModel item) async {
    await _box?.put(key, item);
  }

  @override
  Future<void> removeItem(String key) async {
    await _box?.delete(key);
  }

  @override
  List<UserModel>? getValues() {
    return _box?.values.toList();
  }

  @override
  void registerAdapter() {
    if (!Hive.isAdapterRegistered(HiveConstants.userTypeId)) {
      Hive.registerAdapter(UserModelAdapter());
      Hive.registerAdapter(CompanyAdapter());
      Hive.registerAdapter(AddressAdapter());
      Hive.registerAdapter(GeoAdapter());
    }
  }
}
