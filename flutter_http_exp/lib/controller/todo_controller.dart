import '../models/todo.dart';
import '../repository/repository.dart';

class TodoController{
    final Repository _repository;
    TodoController(this._repository);

    //get
    Future<List<Todo>>fetchTodoList()async{
        return _repository.getTodoList();
    }
    //patch
    Future<String>updatePatchCoompleted(Todo todo)async{
      return _repository.patchComplated(todo);
    }
}