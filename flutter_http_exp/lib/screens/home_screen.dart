import 'package:flutter/material.dart';
import 'package:flutter_http_exp/controller/todo_controller.dart';
import 'package:flutter_http_exp/repository/todo_repository.dart';

import '../models/todo.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var todoController = TodoController(TodoRepostory());

    return Scaffold(
        appBar: AppBar(
          title: const Text('Rest API'),
        ),
        body: FutureBuilder(
            future: todoController.fetchTodoList(),
            builder: (context, AsyncSnapshot<List<Todo>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.hasError) {
                return Center(
                  child: Text('errorrr' + snapshot.error.toString()),
                );
              }
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  var todo = snapshot.data?[index];
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 100,
                          child: Row(
                            children: [
                              Expanded(
                                  flex: 1, child: Text(todo!.id.toString())),
                              Expanded(flex: 3, child: Text(todo.title!)),
                              Expanded(
                                  flex: 3,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      InkWell(
                                          onTap: () {
                                            todoController
                                                .updatePatchCoompleted(todo);
                                          },
                                          child: const NewWidget(
                                            title: 'v2patch',
                                            color: Colors.purple,
                                          )),
                                      InkWell(
                                          onTap: () {},
                                          child: const NewWidget(
                                            title: 'v2put',
                                            color: Colors.orange,
                                          )),
                                      InkWell(
                                          onTap: () {},
                                          child: const NewWidget(
                                            title: 'v2del',
                                            color: Colors.cyan,
                                          )),
                                    ],
                                  )),
                            ],
                          ),
                        ),
                        const Divider(
                          thickness: 2,
                        )
                      ],
                    ),
                  );
                },
              );
            }));
  }
}

class NewWidget extends StatelessWidget {
  final String? title;
  final Color? color;
  const NewWidget({Key? key, required this.title, required this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      decoration:
      BoxDecoration(color: color, borderRadius: BorderRadius.circular(10)),
      child: Center(
    child: Text(title!),
      ),
    );
  }
}
