import 'package:flutter/material.dart';
import 'package:leave_desk/constants/colors.dart';

class Pagination extends StatefulWidget {
  final int totalPages;
  final Function(int) onPageChanged;
  final int currentPage;

  const Pagination({
    Key? key,
    required this.totalPages,
    required this.onPageChanged,
    this.currentPage = 1,
  }) : super(key: key);

  @override
  State<Pagination> createState() => _PaginationState();
}

class _PaginationState extends State<Pagination> {
  late int _currentPage;

  @override
  void initState() {
    super.initState();
    _currentPage = widget.currentPage;
  }

  @override
  void didUpdateWidget(Pagination oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentPage != oldWidget.currentPage) {
      _currentPage = widget.currentPage;
    }
  }

  void _goToPage(int page) {
    if (page >= 1 && page <= widget.totalPages && page != _currentPage) {
      setState(() {
        _currentPage = page;
      });
      widget.onPageChanged(page);
    }
  }

  List<Widget> _buildPageNumbers() {
    List<Widget> pageNumbers = [];
    int start, end;

    if (widget.totalPages <= 7) {
      start = 1;
      end = widget.totalPages;
    } else {
      if (_currentPage <= 4) {
        start = 1;
        end = 5;
      } else if (_currentPage >= widget.totalPages - 3) {
        start = widget.totalPages - 4;
        end = widget.totalPages;
      } else {
        start = _currentPage - 2;
        end = _currentPage + 2;
      }
    }

    // First page
    if (start > 1) {
      pageNumbers.add(_buildPageButton(1));
      if (start > 2) {
        pageNumbers.add(_buildEllipsis());
      }
    }

    // Middle pages
    for (int i = start; i <= end; i++) {
      pageNumbers.add(_buildPageButton(i));
    }

    // Last page
    if (end < widget.totalPages) {
      if (end < widget.totalPages - 1) {
        pageNumbers.add(_buildEllipsis());
      }
      pageNumbers.add(_buildPageButton(widget.totalPages));
    }

    return pageNumbers;
  }

  Widget _buildPageButton(int page) {
    bool isActive = page == _currentPage;
    return InkWell(
      onTap: () => _goToPage(page),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: isActive ? AppColors.primaryColor : Colors.grey.shade300,
          ),
        ),
        child: Text(
          page.toString(),
          style: TextStyle(
            color: isActive ? Colors.white : Colors.black87,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildEllipsis() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: const Text('...'),
    );
  }

  Widget _buildNavigationButton({
    required IconData icon,
    required VoidCallback onPressed,
    required bool enabled,
  }) {
    return InkWell(
      onTap: enabled ? onPressed : null,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: enabled ? Colors.transparent : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: enabled ? Colors.grey.shade300 : Colors.grey.shade200,
          ),
        ),
        child: Icon(
          icon,
          size: 18,
          color: enabled ? Colors.black87 : Colors.grey.shade400,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.totalPages <= 0) {
      return const SizedBox.shrink();
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildNavigationButton(
          icon: Icons.chevron_left,
          onPressed: () => _goToPage(_currentPage - 1),
          enabled: _currentPage > 1,
        ),
        ..._buildPageNumbers(),
        _buildNavigationButton(
          icon: Icons.chevron_right,
          onPressed: () => _goToPage(_currentPage + 1),
          enabled: _currentPage < widget.totalPages,
        ),
      ],
    );
  }
}
