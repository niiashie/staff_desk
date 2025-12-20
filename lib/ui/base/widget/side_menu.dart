import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:leave_desk/constants/colors.dart';
import 'package:leave_desk/constants/images.dart';

class SideMenu extends StatefulWidget {
  final List<String> labels;
  final List<String> icons;
  final int selected;
  final Function(String, int) onSelected;
  const SideMenu({
    super.key,
    required this.labels,
    required this.icons,
    required this.selected,
    required this.onSelected,
  });

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  int? _hoveredIndex;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      height: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            offset: const Offset(2, 0),
            blurRadius: 3,
            spreadRadius: 0,
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Image.asset(AppImages.logo, width: 60, height: 60),
            const SizedBox(height: 12),
            const Text(
              "Staff Desk",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 25),
            ListView.builder(
              itemCount: widget.labels.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return MouseRegion(
                  onEnter: (_) {
                    setState(() {
                      _hoveredIndex = index;
                    });
                  },
                  onExit: (_) {
                    setState(() {
                      _hoveredIndex = null;
                    });
                  },
                  child: Container(
                    width: double.infinity,
                    height: 40,
                    margin: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: index == widget.selected
                          ? const Color(0xFFFFFFFF)
                          : _hoveredIndex == index
                          ? AppColors.primaryColor.withValues(alpha: 0.7)
                          : Colors.transparent,
                      borderRadius: BorderRadius.all(
                        Radius.circular(
                          index == widget.selected || _hoveredIndex == index
                              ? 15
                              : 0,
                        ),
                      ),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.all(
                          Radius.circular(
                            index == widget.selected || _hoveredIndex == index
                                ? 15
                                : 0,
                          ),
                        ),
                        onTap: () {
                          widget.onSelected(widget.labels[index], index);
                          // Handle tap
                        },
                        child: Stack(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const SizedBox(width: 15),
                                  SvgPicture.asset(
                                    widget.icons[index],
                                    width: 18,
                                    height: 18,
                                    colorFilter: ColorFilter.mode(
                                      index == widget.selected
                                          ? AppColors.primaryColor
                                          : Colors.white,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                  const SizedBox(width: 17),
                                  Text(
                                    widget.labels[index],
                                    style: TextStyle(
                                      color: index == widget.selected
                                          ? AppColors.primaryColor
                                          : Colors.white,
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
