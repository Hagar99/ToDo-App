

import 'package:dora/shared/cubit/cubit.dart';
import 'package:dora/shared/cubit/states.dart';
import 'package:dora/shared/layouts/tasks_design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class done_tasks extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return BlocConsumer <AppCubit, AppStates>(
        listener: (context , state) => {},
        builder: (context, state) {
          return tasksDesignWidget(1, context);
        }
    );
  }
}
