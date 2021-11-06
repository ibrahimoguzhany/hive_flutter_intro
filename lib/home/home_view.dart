import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'home_view_service.dart';
import '../manager/user_cache_manager.dart';
import '../search_view/search_view.dart';

import 'model/user_model.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late final ICacheManager<UserModel> cacheManager;
  late final IHomeService _homeService;
  final String _baseUrl = "https://jsonplaceholder.typicode.com";
  List<UserModel>? _items;
  final _dummyPhoto = "https://picsum.photos/500/300";
  final _cacheKey = "hive_intro";
  @override
  void initState() {
    super.initState();
    _homeService = HomeService(Dio(BaseOptions(baseUrl: _baseUrl)));
    cacheManager = UserCacheManager(_cacheKey);

    fetchDatas();
  }

  Future<void> fetchDatas() async {
    await cacheManager.init();

    if (cacheManager.getValues()?.isNotEmpty ?? false) {
      _items = cacheManager.getValues();
    } else {
      _items = await _homeService.fetchUsers();
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () async {
                  await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              SearchView(model: cacheManager)));
                },
                icon: const Icon(Icons.search_outlined)),
            IconButton(
                onPressed: () async {
                  await cacheManager.clearAll(_cacheKey);
                },
                icon: const Icon(Icons.delete_forever_outlined))
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            if (_items?.isNotEmpty ?? false) {
              await cacheManager.addItems(_items!);
            }
          },
        ),
        body: (_items?.isNotEmpty ?? false)
            ? ListView.builder(
                itemCount: _items?.length,
                itemBuilder: (_, index) {
                  return Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage:
                            NetworkImage(_dummyPhoto + "?random=$index"),
                      ),
                      title: Text("${_items?[index].name}"),
                    ),
                  );
                })
            : const Center(child: CircularProgressIndicator()));
  }
}
