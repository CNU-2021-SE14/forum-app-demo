import 'package:first_app/screens/board_screen.dart';
import 'package:first_app/screens/serach_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/posts.dart';
import '../screens/edit_post_screen.dart';
import '../widgets/post_item.dart';
import './main_screen.dart';

class SearchScreen extends StatefulWidget {
  static const routeName = './search';
  const SearchScreen({Key? key}) : super(key: key);

  _SerachScreen createState() => _SerachScreen();
}
class _SerachScreen extends State<SearchScreen>{
  TextEditingController? _editingController;
  List? data;
  String result='';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _editingController=new TextEditingController();
  }
  Future<void> _refreshPosts2(BuildContext context, String boardId,TextEditingController editingController)  async {
    await Provider.of<Posts>(context, listen: false).fetchAndSetPosts2(boardId,editingController.value.text);
  }

  Future<void> _refreshPosts(BuildContext context, String boardId) async {
    await Provider.of<Posts>(context, listen: false).fetchAndSetPosts(boardId);
  }

  @override
  Widget build(BuildContext context) {
    final args =ModalRoute.of(context)!.settings.arguments;//받아오는 부분
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          textInputAction: TextInputAction.go,
          controller: _editingController,
          style: TextStyle(color: Colors.black),
          keyboardType: TextInputType.text,
          decoration: InputDecoration(hintText: "검색어를 입력하세요"),
          onSubmitted: (text){
            _refreshPosts2(context, args.toString(),_editingController!);
          },
        ),
        leading: IconButton(
            onPressed: ()=>{
              _refreshPosts(context, args.toString()),
              Navigator.pop(context)
            },
          icon: Icon(Icons.arrow_back_sharp),
            ),
      ),
      body: FutureBuilder(

        builder: (ctx, snapshot) =>
        snapshot.connectionState == ConnectionState.waiting
            ? Center(
          child: CircularProgressIndicator(),
        )
            : RefreshIndicator(
          onRefresh: () => _refreshPosts2(context, args.toString(),_editingController!),
          child: Consumer<Posts>(
            builder: (ctx, postsData, _) => Padding(
              padding: EdgeInsets.all(8),
              child: postsData.items.length > 0
                  ? ListView.builder(
                itemCount: postsData.items.length,
                itemBuilder: (_, i) => Column(
                  children: [
                    PostItem(
                      postsData.items[i].id,
                    ),
                    Divider(),
                  ],
                ),
              )
                  : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.insert_drive_file_outlined,
                      size: 48,
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      'No Posts Yet',
                      textScaleFactor: 1.5,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),

    );
  }
}
