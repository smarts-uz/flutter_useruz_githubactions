import 'package:flutter/material.dart';
import 'package:youdu/src/constants/constants.dart';

class SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  SliverAppBarDelegate(
    this._tabBar, {
    this.padding = EdgeInsets.zero,
    this.background = AppColors.background,
  });

  final TabBar _tabBar;
  final EdgeInsets padding;
  final Color background;

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      padding: padding,
      color: background,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
