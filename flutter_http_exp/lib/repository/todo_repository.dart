import 'package:flutter_http_exp/models/todo.dart';
import 'package:flutter_http_exp/repository/repository.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TodoRepostory implements Repository {
  String dataURL = 'https://jsonplaceholder.typicode.com';
  //DELETE veri silmek
  @override
  Future<String> deletedTodo(Todo todo) {
    // TODO: implement deletedTodo
    throw UnimplementedError();
  }

  //GET veri okuma
  @override
  Future<List<Todo>> getTodoList() async {
    List<Todo> todoList = [];
    var url = Uri.parse('$dataURL/todos');
    var response = await http.get(url);

    print('status code : ${response.statusCode}');
    var body = json.decode(response.body);
    for (int i = 0; i < body.length; i++) {
      todoList.add(Todo.fromJson(body[i]));
    }
    return todoList;
  }

  //Patch veri güncellemek
  @override
  Future<String> patchComplated(Todo todo) async {
    var url = Uri.parse('$dataURL/todos/${todo.id}');
    String resData = '';
    await http.patch(url,
        body: {'completed': (!todo.completed!).toString()},
        headers: {'Authorization': 'your_token'}).then((response) {
      Map<String, dynamic> result = json.decode(response.body);
      print(result.entries);
      return resData = result[''];
    });
    return resData;
  }

  //POST veri göndermek
  @override
  Future<String> postTodo(Todo todo) {
    // TODO: implement postTodo
    throw UnimplementedError();
  }

  //Put güncellemek
  @override
  Future<String> putComplated(Todo todo) {
 // TODO: implement deletedTodo
    throw UnimplementedError();
  }
}
