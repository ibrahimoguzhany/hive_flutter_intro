import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive_intro/home/home_view_service.dart';
import 'package:hive_intro/manager/user_cache_manager.dart';
import 'package:hive_intro/search_view/search_view.dart';
import 'package:kartal/kartal.dart';

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
  @override
  void initState() {
    super.initState();
    _homeService = HomeService(Dio(BaseOptions(baseUrl: _baseUrl)));
    cacheManager = UserCacheManager("userCacheNew212312");

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
                onPressed: () {
                  context.navigateToPage(SearchView(model: cacheManager));
                },
                icon: const Icon(Icons.search_outlined))
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
