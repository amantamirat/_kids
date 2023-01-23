import 'package:abdu_kids/model/my_model.dart';
import 'package:abdu_kids/services/my_service.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';

class DeleteDialog extends StatefulWidget {
  final MyModel model;
  const DeleteDialog({Key? key, required this.model}) : super(key: key);
  @override
  State<DeleteDialog> createState() => _DeleteDialog();
}

class _DeleteDialog extends State<DeleteDialog> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Delete Data'),
      content: Text(
          'Are you sure, delete ${widget.model.toString()} and its Contenet?'),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            GoRouter.of(context).pop(1);
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            if (await MyService.deleteModel(widget.model)) {
              Fluttertoast.showToast(
                  msg: 'Removed!',
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.amber,
                  textColor: Colors.black);
              GoRouter.of(context).pop(0);
            } else {
              GoRouter.of(context).pop(1);
            }
          },
          child: const Text('Yes'),
        ),
      ],
    );
  }
}
