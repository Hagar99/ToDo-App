
import 'package:dora/modules/task_module/list_of_tasks.dart';
import 'package:dora/shared/constants/constantd.dart';
import 'package:dora/shared/cubit/cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_conditional_rendering/conditional.dart';


Widget tasksDesignWidget (int selector, context)
{
 List < List <Map> > taskKind =
     [
       AppCubit.get(context).newTasksList,
       AppCubit.get(context).doneTasksList,
       AppCubit.get(context).archivedTasksList,
     ];
        return  Conditional.single(
          context: context,
          conditionBuilder: (context) => taskKind[selector].isNotEmpty,
          widgetBuilder: (context) => ListView.separated(
            itemBuilder: (context, index) {
              return task_design(taskKind[selector][index], context);
            },

            separatorBuilder: (context, index) =>
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10,),
                  child: Container(
                    width: double.minPositive,
                    height: 3.0,
                    decoration: const BoxDecoration(
                      color: Colors.green,
                    ),
                  ),
                ),

            itemCount: taskKind[selector].length,
          ),
          fallbackBuilder: (context) =>
             Center(
               child: Column (
                 mainAxisAlignment: MainAxisAlignment.center,
                  children: const
                 [
                   Icon(
                     Icons.menu,
                     size: 70.0,
                     color: Colors.grey,
                   ),
                   Text(
                       'No Tasks Here, Please Enter Some!',
                     style: TextStyle(
                       fontSize: 16.0,
                       fontWeight: FontWeight.bold,
                       color: Colors.grey,

                     ),
                   ),
                 ],
               ),
             ),
        );
      }