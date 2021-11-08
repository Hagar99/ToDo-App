import 'package:dora/shared/cubit/cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget task_design(Map model, context) => Dismissible(
  key: Key(model['id'].toString()),
  child:   Padding(
    padding: const EdgeInsetsDirectional.all(13.0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 45.0,
          backgroundColor: Colors.blueGrey,
          child: Text(
           '${model['time']}',
            style: const TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(
          width: 15.0,
        ),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children:[
              Text(
                '${model['title']}',
                maxLines: 1,
                style:const TextStyle(
                  overflow: TextOverflow.ellipsis,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey,
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              Text(
                '${model['date']}',
                style: const TextStyle(
                  fontSize: 18.0,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
            ],
          ),
        ),
        const SizedBox(
          width: 15.0,
        ),
        IconButton(
          onPressed: ()
          {
            AppCubit.get(context).updateDatabase("DONE", model['id']);
          },
          icon: const Icon(Icons.check_box_rounded),
          color:  Colors.teal,
        ),
        IconButton(
          onPressed: ()
          {
            AppCubit.get(context).updateDatabase("ARCHIVED", model['id']);
          },
          icon: const Icon(Icons.archive),
          color: Colors.grey[600],
        ),
      ],
    ),
  ),
  onDismissed: (direction){
    AppCubit.get(context).DeleteData(model['id']);
  },
 direction: DismissDirection.endToStart,
);