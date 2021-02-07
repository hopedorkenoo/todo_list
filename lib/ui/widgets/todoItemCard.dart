import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/core/BLoCs/homeBloc.dart';
import 'package:todo_list/core/models/todo.dart';
import 'package:todo_list/core/util/appColors.dart';
import 'package:todo_list/core/util/textThemes.dart';

class ToDoItemCard extends StatefulWidget {
  final ToDo toDo;

  const ToDoItemCard({Key key, this.toDo}) : super(key: key);
  @override
  _ToDoItemCardState createState() => _ToDoItemCardState();
}

class _ToDoItemCardState extends State<ToDoItemCard> {
  @override
  Widget build(BuildContext context) {
    return Consumer<HomeBloc>(builder: (context, bloc, _) {
      return Dismissible(
        background: backgroundDelete(),
        key: Key(widget.toDo.id),
        confirmDismiss: (direction) async {
          if (direction == DismissDirection.endToStart) {
            final bool res = await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    content: Text(
                        "Are you sure you want to delete ${widget.toDo.title}?"),
                    actions: <Widget>[
                      FlatButton(
                        child: Text(
                          "Cancel",
                          style: TextStyle(color: Colors.black),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      FlatButton(
                        child: Text(
                          "Delete",
                          style: TextStyle(color: Colors.red),
                        ),
                        onPressed: () {
                          // TODO: Delete the item from DB etc..
                          bloc.deleteWithId(widget.toDo.id, context);
                        },
                      ),
                    ],
                  );
                });
            return res;
          }
        },
        child: GestureDetector(
          child: Row(children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.only(top: 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: false ? LColors.primaryColor : Colors.transparent,
                  boxShadow: false
                      ? [
                          BoxShadow(
                              color: LColors.black.withOpacity(0.1),
                              offset: Offset(2, 4),
                              blurRadius: 7)
                        ]
                      : [],
                ),
                child: Row(
                  children: [
                    //Checkbox
                    GestureDetector(
                      onTap: () {
                        widget.toDo.isDone = widget.toDo.isDone == 1 ? 0 : 1;
                        bloc.taskIsDone(widget.toDo);
                      },
                      child: Container(
                        width: 25,
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: widget.toDo.isDone == 1
                              ? Container(
                                  margin: EdgeInsets.all(2),
                                  padding: EdgeInsets.all(.5),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: LColors.primaryColor,
                                  ),
                                  child: Icon(
                                    Icons.check,
                                    color: LColors.white,
                                    size: 15,
                                  ),
                                )
                              : Stack(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.all(2),
                                      decoration: BoxDecoration(
                                        border: widget.toDo.isDone == 1
                                            ? Border.all()
                                            : Border.all(
                                                style: BorderStyle.solid,
                                                color: LColors.grey,
                                                width: 1,
                                              ),
                                        borderRadius: BorderRadius.circular(5),
                                        color: widget.toDo.isDone == 1
                                            ? LColors.primaryColor
                                            : Colors.transparent,
                                      ),
                                      // width: 25,
                                    ),
                                    Positioned(
                                      bottom: 0,
                                      right: 0,
                                      child: CircleAvatar(
                                        radius: 5,
                                        backgroundColor: LColors.primaryColor,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ),
                    SizedBox(width: 15),
                    Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${widget.toDo.title}",
                            style: LTextThemes.smallBodyBlack,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 5),
                          Text(
                            "${widget.toDo.activity}",
                            style: LTextThemes.tinyFadedAnotePrim,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ]),
        ),
      );
    });
  }

  Widget backgroundDelete() {
    return Container(
        decoration: BoxDecoration(
          color: LColors.red,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              "Delete",
              style: LTextThemes.smallBodywhite,
            )
          ],
        ));
  }
}
