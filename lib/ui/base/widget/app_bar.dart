import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:leave_desk/app/locator.dart';
import 'package:leave_desk/constants/colors.dart';
import 'package:leave_desk/constants/spaces.dart';
import 'package:leave_desk/models/navigation_item.dart';
import 'package:leave_desk/services/app_service.dart';
import 'package:leave_desk/shared/custom_button.dart';
import 'package:leave_desk/ui/auth/login_view.dart';
import 'package:leave_desk/ui/base/widget/bread_crumb.dart';
import 'package:leave_desk/utils.dart';
import 'package:stacked_services/stacked_services.dart';

class AppBarWidget extends StatefulWidget {
  const AppBarWidget({super.key});

  @override
  State<AppBarWidget> createState() => _AppBarWidgetState();
}

class _AppBarWidgetState extends State<AppBarWidget> {
  bool sideMenuOpened = true;
  var appService = locator<AppService>();
  String? selectedCompanyBranch;
  Stream? stream;
  StreamSubscription<NavigationItem>? streamSubscription;
  List<NavigationItem> menuItems = [];

  @override
  void initState() {
    listenToBreadCrumbMenuItemChange();
    // selectedCompanyBranch =
    //     "${appService.user!.warehouses![0].role}_${appService.user!.warehouses![0].warehouse!.id}";
    // appService.selectedWarehouseId =
    //     appService.user!.warehouses![0].warehouse!.id.toString();
    // appService.selectedWarehouseRole = appService.user!.warehouses![0].role;
    appService.controller.add(
      NavigationItem("Dashbiard", "/dashboard", "main"),
    );
    super.initState();
  }

  @override
  void dispose() {
    streamSubscription!.cancel(); // Dispose when widget is popped
    super.dispose();
  }

  popUntilIndex(int index) {
    int previousMenuLength = menuItems.length;

    for (int i = index; i < previousMenuLength - 1; previousMenuLength--) {
      Utils.sideMenuNavigationKey.currentState!.pop();
    }
  }

  listenToBreadCrumbMenuItemChange() {
    stream = appService.controller.stream;
    streamSubscription =
        stream!.listen((value) {
              if (value.type == 'sub') {
                menuItems.add(value);
              } else if (value.type == "pop") {
                removeMenuItemsUntilIndex(int.parse(value.route));
              } else {
                menuItems.clear();
                menuItems.add(value);
              }
              setState(() {});
            })
            as StreamSubscription<NavigationItem>?;
  }

  removeMenuItemsUntilIndex(index) {
    //popUntilIndex(index);
    while (menuItems.length > index + 1) {
      menuItems.removeLast();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 0.5,
      child: Container(
        width: double.infinity,
        color: AppColors.baseColor,
        height: 60,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(width: 5),
                    BreadCrumb(menuItems: menuItems),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.calendar_month, size: 15, color: Colors.grey[600]),
                  const SizedBox(width: 5),
                  Text(
                    DateFormat('d, MMMM, y').format(DateTime.now()),
                    style: const TextStyle(
                      color: AppColors.crudTextColor,
                      fontSize: AppfontSizes.small,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(width: 15),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 3),
                    child: CustomButton(
                      width: 30,
                      height: 30,
                      borderRadius: 15,
                      color: Colors.white,
                      elevation: 1,
                      title: const Icon(
                        Icons.notifications_outlined,
                        size: 15,
                        color: AppColors.lightTextColor,
                      ),
                      ontap: () {},
                    ),
                  ),
                  const SizedBox(width: 3),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 3),
                    child: PopupMenuButton(
                      icon: Material(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(17),
                        ),
                        elevation: 1,
                        color: Colors.white,
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(17)),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.person_outline,
                              size: 15,
                              color: AppColors.lightTextColor,
                            ),
                          ),
                        ),
                      ),
                      offset: const Offset(0.0, 60),
                      onSelected: (value) async {
                        if (value == "logout") {
                          DialogResponse? response = await appService
                              .confirmAction(
                                title: "Logout",
                                message: "Do you really want to logout",
                                okayText: "Yes",
                                cancelText: "No",
                              );

                          if (response != null && response.confirmed) {
                            appService.currentUser = null;

                            Navigator.pushReplacement(
                              StackedService.navigatorKey!.currentContext!,
                              MaterialPageRoute(
                                builder: (context) => const LoginView(),
                              ),
                            );
                          }
                        } else if (value == "password") {
                          appService.showMessage(
                            title: "Pending",
                            message: "Feature to be released soon",
                          );
                        } else if (value == "edit") {}
                      },
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15.0)),
                      ),
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          enabled: false,
                          child: Container(
                            width: 150,
                            padding: const EdgeInsets.only(top: 5, bottom: 5),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Emmanuel",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  "Manager",
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        PopupMenuItem(
                          value: "password",
                          height: 45,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.lock,
                                  color: Colors.grey[700],
                                  size: 14,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  "Change Password",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        PopupMenuItem(
                          value: "logout",
                          height: 45,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.logout,
                                  color: Colors.grey[700],
                                  size: 17,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  "Logout",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // setSelectedCompanyBranch(val) {
  //   selectedCompanyBranch = val;
  //   appService.selectedWarehouseId = val.split("_")[1];
  //   appService.selectedWarehouseRole = val.split("_")[0];

  //   setState(() {});
  // }
}
