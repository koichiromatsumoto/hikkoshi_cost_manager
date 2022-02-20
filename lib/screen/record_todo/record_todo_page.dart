import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hikkoshi_cost_manager/components/date_formatter.dart';
import 'package:hikkoshi_cost_manager/components/input_todo_dialog.dart';
import 'package:hikkoshi_cost_manager/model/db/costs_database.dart';
import 'package:hikkoshi_cost_manager/model/entity/todos.dart';
import 'package:hikkoshi_cost_manager/model/repository/todos_repository.dart';
import 'package:hikkoshi_cost_manager/state/display_done_provider.dart';
import 'package:hooks_riverpod/all.dart';

class RecordTodoPage extends StatefulWidget {
  @override
  _RecordTodoPageState createState() => new _RecordTodoPageState();
}

class _RecordTodoPageState extends State<RecordTodoPage> {

  @override
  Widget build(BuildContext context) {
    @override
    void initState() {
      super.initState();
      final CostsDatabase instance = CostsDatabase.instance;
      final db = instance.database;
    }
    var futureBuilder = FutureBuilder(
      future: TodoRepository.getAll(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return mainCardView(context, Todo.mainCache, false);
          default:
            if (snapshot.hasError)
              return Text('Error: ${snapshot.error}');
            else
              Todo.mainCache = snapshot.data;
            return mainCardView(context, Todo.mainCache, true);
        }
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: Text("やることリスト"),
        centerTitle: true,
      ),
      body: futureBuilder,
      floatingActionButton: Container(
        margin: EdgeInsets.only(bottom: 50.0),
        child: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () {
              inputTodoDialog(context);
            }),
      ),
    );
  }

  Widget mainCardView(BuildContext context, List<Todo> todos, bool isEnabled) {
    todos.sort((a, b) {
      int result;
      if (a.deadline == null) {
        result = 1;
      } else if (b.deadline == null) {
        result = -1;
      } else {
        // Ascending Order
        result = a.deadline!.compareTo(b.deadline!);
      }
      return result;
    });
    final deviceWidth = MediaQuery
        .of(context)
        .size
        .width;
    var now = DateTime.now();
    var today = DateTime(now.year, now.month, now.day, 0, 0);
    return SingleChildScrollView(
        padding: EdgeInsets.only(bottom: 80),
        child: Consumer(builder: (context, watch, child) {
          var doneExistFlg = false;
          List<Todo> nonDisplayTodos = [];
          for (var todo in todos) {
            if (!watch(displayDoneProvider).displayDoneFlg) {
              if (todo.isDone == "true") {
                nonDisplayTodos.add(todo);
              }
            }
            if (todo.isDone == "true") {
              doneExistFlg = true;
            }
          }
          nonDisplayTodos.forEach((todo) {
            todos.remove(todo);
          });
          return Column(
            children: <Widget>[
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.fromLTRB(40, 30, 30, 15),
                child: Text(
                  "引越し作業でやることを\n管理しましょう",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.black54,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              if (doneExistFlg) ElevatedButton(
                child: Text(
                  watch(displayDoneProvider).displayDoneFlg
                      ? '完了済みを非表示'
                      : '完了済みを表示',
                ),
                style: ElevatedButton.styleFrom(
                  primary: Colors.blueAccent,
                  onPrimary: Colors.white,
                  elevation: 5,
                  shadowColor: Colors.deepOrangeAccent,
                ),
                onPressed: () {
                  setState(() {
                    if (watch(displayDoneProvider).displayDoneFlg == false) {
                      context.read(displayDoneProvider).handleChange(true);
                    } else {
                      context.read(displayDoneProvider).handleChange(false);
                    }
                  });
                },
              ),
              SizedBox(height: 10),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  final todoDeadline = todos[index].deadline != null
                      ? todos[index].deadline
                      : DateTime(2200, 1, 1, 0, 0);
                  final todoDeadlineStr = todos[index].deadline != null
                      ? formattedDate(todos[index].deadline!)
                      : "なし";
                  var todoIsDone = todos[index].isDone != null
                      ? todos[index].isDone
                      : "false";
                  return Center(
                    child: SizedBox(
                      width: deviceWidth,
                      child: Card(
                        elevation: 5,
                        shadowColor: Colors.blueGrey,
                        color:
                        todoIsDone == "false" ? (today
                            .difference(todoDeadline!)
                            .inDays <= 0) ? Colors.white : Color.fromARGB(
                            255, 255, 238, 244) : Colors.grey,
                        child: Container(
                          child: Row(children: <Widget>[
                            Container(
                              padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                              width: deviceWidth * 0.15,
                              child: IconButton(
                                onPressed: () {
                                  TodoRepository.updateIsDone(
                                    id: todos[index].id,
                                    isDone: todoIsDone == "false"
                                        ? "true"
                                        : "false",
                                  );
                                  setState(() {
                                    todoIsDone = todos[index].isDone != null
                                        ? todos[index].isDone
                                        : "false";
                                  });
                                },
                                icon: Icon(
                                  todoIsDone == "false"
                                      ? Icons.check_box_outline_blank
                                      : Icons.check_box,
                                  color: Colors.black54,
                                  size: 28,
                                ),
                              ),
                            ),
                            Flexible(
                              child: Container(
                                child: InkWell(
                                  onTap: () {
                                    inputTodoDialog(context,
                                        todo: todos[index]);
                                  },
                                  child: Column(children: <Widget>[
                                    Container(
                                      padding:
                                      EdgeInsets.fromLTRB(0, 10, 30, 0),
                                      child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.end,
                                          children: <Widget>[
                                            Text(
                                              '期限: ',
                                              style: TextStyle(
                                                fontSize: 16,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 16,
                                            ),
                                            Text(
                                              '$todoDeadlineStr',
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: (today
                                                    .difference(todoDeadline!)
                                                    .inDays <= 0)
                                                    ? Colors.black
                                                    : Colors.red,
                                              ),
                                              textAlign: TextAlign.right,
                                            ),
                                          ]),
                                    ),
                                    Container(
                                      padding: EdgeInsets.fromLTRB(0, 5, 5, 10),
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        todos[index].name,
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ]),
                                ),
                              ),
                            ),
                          ]),
                        ),
                      ),
                    ),
                  );
                },
                itemCount: todos.length,
              ),
            ],
          );
        }));
  }
}
