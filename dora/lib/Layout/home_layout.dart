import 'package:dora/modules/task_module/text_field.dart';
import 'package:dora/shared/constants/constantd.dart';
import 'package:dora/shared/cubit/cubit.dart';
import 'package:dora/shared/cubit/states.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:intl/intl.dart';

class home_layout extends StatelessWidget {
  var taskController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (BuildContext context, AppStates state) => {},
        builder: (BuildContext context, AppStates state) {
          AppCubit cubit = AppCubit.get(context);
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              backgroundColor: Colors.teal,
              title: Text(
                cubit.screen_title[cubit.current_index],
              ),
            ),
            body: Conditional.single(
              context: context,
              conditionBuilder: (BuildContext context) => tasks.isNotEmpty,
              widgetBuilder: (BuildContext context) =>
                  cubit.screens[cubit.current_index],
              fallbackBuilder: (context) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
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
            ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.teal,
              onPressed: () {
                if (cubit.isBottomSheetShown) {
                  if (formKey.currentState!.validate()) {
                    cubit
                        .insertIntoDatabase(taskController.text,
                            dateController.text, timeController.text)
                        .then((value) {
                      Navigator.pop(context);
                      cubit.changeIsBottomShown(false, Icons.edit);
                    });
                  }
                } else {
                  taskController.clear();
                  dateController.clear();
                  timeController.clear();
                  scaffoldKey.currentState
                      ?.showBottomSheet(
                        (context) => Container(
                          color: Colors.white,
                          child: Form(
                            key: formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                textField(
                                  'Task Name',
                                  taskController,
                                  TextInputType.text,
                                  const Icon(
                                    Icons.title,
                                  ),
                                  validate: (String? value) {
                                    if (value!.isEmpty) {
                                      return 'title must not be empty';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(
                                  height: 15.0,
                                ),
                                textField(
                                  'Task Time',
                                  timeController,
                                  TextInputType.datetime,
                                  const Icon(
                                    Icons.watch_later_outlined,
                                  ),
                                  validate: (String? value) {
                                    if (value!.isEmpty) {
                                      return 'Time must not be empty';
                                    }
                                    return null;
                                  },
                                  onTap: () {
                                    showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.now(),
                                    ).then((value) {
                                      timeController.text =
                                          value!.format(context).toString();
                                    });
                                  },
                                ),
                                const SizedBox(
                                  height: 15.0,
                                ),
                                textField(
                                  'Task Date',
                                  dateController,
                                  TextInputType.datetime,
                                  const Icon(
                                    Icons.calendar_today_rounded,
                                  ),
                                  validate: (String? value) {
                                    if (value!.isEmpty) {
                                      return 'Date must not be empty';
                                    }
                                    return null;
                                  },
                                  onTap: () {
                                    showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime(2022, 5, 19),
                                    ).then((value) {
                                      dateController.text = DateFormat.yMMMd()
                                          .format(value!)
                                          .toString();
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        elevation: 20.0,
                      )
                      .closed
                      .then((value) {
                    cubit.changeIsBottomShown(false, Icons.edit);
                  });
                  cubit.changeIsBottomShown(true, Icons.add);
                }
              },
              child: Icon(cubit.flot),
            ),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              fixedColor: Colors.teal,
              currentIndex: cubit.current_index,
              onTap: (index) {
                cubit.changeIndex(index);
              },
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.menu,
                  ),
                  label: 'tasks',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.check_box,
                  ),
                  label: 'done',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.archive_rounded,
                  ),
                  label: 'archive',
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
