import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hikkoshi_cost_manager/model/entity/todos.dart';
import 'package:hikkoshi_cost_manager/model/repository/todos_repository.dart';

import 'date_formatter.dart';

Future<void> inputTodoDialog(BuildContext context, {Todo? todo = null}) async {
  final _formKey = GlobalKey<FormState>();
  return showDialog(
      context: context,
      builder: (context) {
        var todoName = "";
        var todoDeadlineStr = "";
        String initialName = "";
        String initialDeadlineStr = "";
        DateTime? todoDeadline = null;
        if (todo != null) {
          // ignore: unnecessary_null_comparison
          initialName = todo.name != null ? todo.name : "";
          initialDeadlineStr =
              todo.deadline != null ? formattedDate(todo.deadline!) : "";
          todoDeadline = todo.deadline != null ? todo.deadline! : null;
        }
        final TextEditingController _todoNameController =
            new TextEditingController(text: initialName);
        final TextEditingController _todoDeadlineController =
            new TextEditingController(text: initialDeadlineStr);

        return StatefulBuilder(builder: (context, setState) {
          Future<void> selectDate(BuildContext context) async {
            final DateTime? selected = await showDatePicker(
              context: context,
              initialDate:
                  todoDeadline != null ? todoDeadline! : DateTime.now(),
              firstDate: DateTime(DateTime.now().year),
              lastDate: DateTime(DateTime.now().year + 2),
            );
            if (selected != null) {
              todoDeadline = selected;
              todoDeadlineStr = formattedDate(todoDeadline!);
              _todoDeadlineController.text = todoDeadlineStr;
            }
          }

          return AlertDialog(
            content: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: todo == null ? 180.0 : 220.0,
              ),
              child: Form(
                key: _formKey,
                child: Column(children: <Widget>[
                  if (todo != null) Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                    TextButton(
                      child: Text(
                        todo.isDone == "false" ? '完了にする' : '未完了にする',
                        style: TextStyle(color: Colors.blue),
                      ),
                      onPressed: () {
                        TodoRepository.updateIsDone(
                          id: todo.id,
                          isDone: todo.isDone == "false"
                              ? "true"
                              : "false",
                        );
                        Navigator.pop(context);
                      },
                      style: TextButton.styleFrom(
                        primary: Colors.white,
                      ),
                    ),
                    TextButton(
                      child: Text(
                        '削除',
                        style: TextStyle(color: Colors.red),
                      ),
                      onPressed: () {
                        TodoRepository.delete(todo.id);
                        Navigator.pop(context);
                      },
                      style: TextButton.styleFrom(
                        primary: Colors.white,
                      ),
                    ),
                  ])
                  else Text(
                      "やることを追加",
                    style: TextStyle(
                      // fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  )
                  ,
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _todoNameController,
                    decoration: InputDecoration(
                      labelText: "何をやる？",
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 0,
                        horizontal: 15,
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          FocusScope.of(context).requestFocus(new FocusNode());
                          _todoNameController.clear();
                        },
                        icon: Icon(Icons.clear),
                      ),
                    ),
                    keyboardType: TextInputType.text,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(50),
                    ],
                    onChanged: (value) {
                      todoName = value;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'やることを入力してください';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _todoDeadlineController,
                    decoration: InputDecoration(
                      labelText: "いつまでにやる？",
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 0,
                        horizontal: 15,
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          _todoDeadlineController.clear();
                          todoDeadline = null;
                        },
                        icon: Icon(Icons.clear),
                      ),
                    ),
                    keyboardType: TextInputType.text,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(50),
                    ],
                    onTap: () {
                      FocusScope.of(context).requestFocus(new FocusNode());
                      selectDate(context);
                    },
                    onChanged: (value) {
                      todoDeadlineStr = value;
                    },
                  ),
                ]),
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text(
                  'キャンセル',
                  style: TextStyle(color: Colors.blue),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                style: TextButton.styleFrom(
                  primary: Colors.white,
                ),
              ),
              TextButton(
                child: Text(
                  'OK',
                  style: TextStyle(color: Colors.blue),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    if (todo == null) {
                      TodoRepository.create(
                        name: todoName,
                        deadline: todoDeadline,
                      );
                    } else {
                      if (todoName == null || todoName.isEmpty) {
                        todoName = todo.name;
                      }
                      TodoRepository.update(
                        id: todo.id,
                        name: todoName,
                        deadline: todoDeadline,
                      );
                    }
                    Navigator.pop(context);
                  }
                },
                style: TextButton.styleFrom(
                  primary: Colors.white,
                ),
              ),
            ],
          );
        });
      });
}
