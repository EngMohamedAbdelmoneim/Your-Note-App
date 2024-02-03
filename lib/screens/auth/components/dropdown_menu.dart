import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../../blocs/my_user_bloc/my_user_bloc.dart';
class DropDownMenu extends StatelessWidget {
  const DropDownMenu({super.key, required this.index});
  final int index;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskBloc, TaskState>(
  builder: (context, state) {
    return DropdownButton2(
        customButton:  Icon(
          Icons.more_vert,
          size: 30,
          color: HexColor("0000FF"),
        ),
        items: [
          ...MenuItems.firstItems.map(
                (item) => DropdownMenuItem<MenuItem>(
              value: item,
              child: MenuItems.buildItem(item),
            ),
          ),
          const DropdownMenuItem<Divider>(enabled: false, child: Divider()),
          ...MenuItems.secondItems.map(
                (item) => DropdownMenuItem<MenuItem>(
              value: item,
              child: MenuItems.buildItem(item),
            ),
          ),
        ],
        onChanged: (value) {
          MenuItems.onChanged(context, value! as MenuItem,state,index);
        },
        dropdownStyleData: DropdownStyleData(
          width: 160,
          padding: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: Colors.white,
          ),
          offset: const Offset(0, 8),
        ),
        menuItemStyleData: MenuItemStyleData(
          customHeights: [
            ...List<double>.filled(MenuItems.firstItems.length, 48),
            8,
            ...List<double>.filled(MenuItems.secondItems.length, 48),
          ],
          padding: const EdgeInsets.only(left: 16, right: 16),
        ),
    );
  },
);
  }
}

class MenuItem {
  const MenuItem({
    required this.text,
    required this.icon,
  });

  final String text;
  final IconData icon;
}

abstract class MenuItems {
  static const List<MenuItem> firstItems = [important,];
  static const List<MenuItem> secondItems = [delete];

  static const important = MenuItem(text: 'Important', icon: Icons.label_important_outline,);
  static const delete = MenuItem(text: 'Delete', icon: Icons.delete_outline);

  static Widget buildItem(MenuItem item) {
    return Row(
      children: [
        Icon(item.icon, color: HexColor("0000FF"), size: 22),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: Text(
            item.text,
            style:  TextStyle(
              color:  HexColor("0000FF"),
            ),
          ),
        ),
      ],
    );
  }

  static void onChanged(BuildContext context, MenuItem item,state,int index) {
    final Task = state.tasks[index];
    bool true1 = true;
    switch (item) {
      case MenuItems.important:
        {
          BlocProvider.of<TaskBloc>(context).add(UpdateTask(
              Task.date,
              taskId: Task.id,
              isImportant: true1,
              title: Task.title,
              description: Task.description,
              isDone: Task.isDone
          ));
          break;
        }
      case MenuItems.delete:
        {
          BlocProvider.of<TaskBloc>(context).add(DeleteTask(
              Task.id,
          ));
          break;
        }
    }
  }
}