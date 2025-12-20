import 'package:flutter/material.dart';
import 'package:leave_desk/app/locator.dart';
import 'package:leave_desk/constants/colors.dart';
import 'package:leave_desk/models/navigation_item.dart';
import 'package:leave_desk/services/app_service.dart';
import 'package:leave_desk/utils.dart';

class BreadCrumb extends StatefulWidget {
  final List<NavigationItem> menuItems;
  const BreadCrumb({super.key, required this.menuItems});

  @override
  State<BreadCrumb> createState() => _BreadCrumbState();
}

class _BreadCrumbState extends State<BreadCrumb> {
  var appService = locator<AppService>();

  int countRoutes(BuildContext context) {
    int count = 0;
    Navigator.popUntil(context, (route) {
      count++;
      return true; // Don't pop anything, just count
    });
    return count;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 3,
      margin: const EdgeInsets.only(right: 300),
      child: Align(
        alignment: Alignment.centerLeft,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: widget.menuItems.length,
          itemBuilder: (context, index) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      color: index == widget.menuItems.length - 1
                          ? AppColors.primaryColor
                          : Colors.transparent,
                    ),
                    child: Text(
                      widget.menuItems[index].name!,
                      style: TextStyle(
                        fontSize: 12,
                        color: index == widget.menuItems.length - 1
                            ? Colors.white
                            : AppColors.crudTextColor,
                      ),
                    ),
                  ),
                  onTap: () {
                    if (index != widget.menuItems.length - 1) {
                      popUntilIndex(index);
                      appService.controller.add(
                        NavigationItem("", "$index", "pop"),
                      );
                    }
                  },
                ),
                const SizedBox(width: 5),
                Visibility(
                  visible: index == widget.menuItems.length - 1 ? false : true,
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.chevron_right,
                        size: 13,
                        color: AppColors.crudTextColor,
                      ),
                      SizedBox(width: 5),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  popUntilIndex(int index) {
    int previousMenuLength = widget.menuItems.length;

    for (int i = index; i < previousMenuLength - 1; previousMenuLength--) {
      Utils.sideMenuNavigationKey.currentState!.pop();
    }
  }
}
