import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/post.dart';
import '../providers/posts.dart';
import '../providers/auth.dart';

class EditPostScreen extends StatefulWidget {
  static const routeName = './editPost';

  @override
  _EditPostScreenState createState() => _EditPostScreenState();
}

class _EditPostScreenState extends State<EditPostScreen> {
  final _contentsFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();

  var _editedPost = Post(
    id: null,
    title: '',
    contents: '',
    datetime: null,
    boardId: '',
    userId: '',
  );

  var _initValues = {
    'title': '',
    'contents': '',
  };

  var _isInit = true;
  var _isLoading = false;
  var arguments = null;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    arguments = ModalRoute.of(context)!.settings.arguments as Map;
    if (_isInit) {
      final postId = arguments['postId'];
      if (postId != null) {
        _editedPost = Provider.of<Posts>(context, listen: false)
            .items
            .firstWhere((post) => post.id == postId);
        _initValues = {
          'title': _editedPost.title ?? '',
          'contents': _editedPost.contents ?? '',
        };
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _contentsFocusNode.dispose();
    super.dispose();
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }
    _form.currentState!.save();

    setState(() {
      _isLoading = true;
    });

    if (_editedPost.id != null) {
      await Provider.of<Posts>(context, listen: false)
          .updatePost(_editedPost.id, _editedPost);
    } else {
      try {
        await Provider.of<Posts>(context, listen: false).addPost(_editedPost);
      } catch (error) {
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('An error ocurred.'),
            content: Text('오류가 발생했습니다.'),
            actions: <Widget>[
              FlatButton(
                child: Text('확인'),
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
              )
            ],
          ),
        );
      }
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final userId = Provider.of<Auth>(context).userId;

    return Scaffold(
      appBar: AppBar(
        title: Text('글 작성'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.check),
            onPressed: _saveForm,
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _form,
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        initialValue: _initValues['title'],
                        decoration: InputDecoration(
                          labelText: '제목',
                        ),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(_contentsFocusNode);
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return '제목을 입력해주세요.';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _editedPost = Post(
                            title: value,
                            contents: _editedPost.contents,
                            datetime: _editedPost.datetime,
                            boardId: arguments['boardId'],
                            userId: userId,
                            id: _editedPost.id,
                          );
                        },
                      ),
                      TextFormField(
                        initialValue: _initValues['contents'],
                        decoration: InputDecoration(labelText: '내용'),
                        maxLines: 15,
                        keyboardType: TextInputType.multiline,
                        textInputAction: TextInputAction.done,
                        focusNode: _contentsFocusNode,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return '내용을 입력해주세요.';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _editedPost = Post(
                            title: _editedPost.title,
                            contents: value,
                            boardId: _editedPost.boardId,
                            datetime: _editedPost.datetime,
                            id: _editedPost.id,
                            userId: _editedPost.userId,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
