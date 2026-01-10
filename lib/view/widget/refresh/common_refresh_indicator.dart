import 'package:flutter/cupertino.dart';
import 'package:pmms/helper/color_helper.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class CommonRefreshIndicator extends StatelessWidget {
  final RefreshController controller;
  final Widget child;
  final VoidCallback onRefresh;
  final VoidCallback? onLoadMore;
  final bool enablePullUp;
  final bool enablePullDown;

  const CommonRefreshIndicator({
    super.key,
    required this.controller,
    required this.child,
    required this.onRefresh,
    this.onLoadMore,
    this.enablePullUp = false,
    this.enablePullDown = true,
  });

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      controller: controller,
      enablePullDown: enablePullDown,
      enablePullUp: enablePullUp,
      onRefresh: onRefresh,
      onLoading: onLoadMore,
      physics: const ClampingScrollPhysics(),
      header: CustomHeader(
        height: 60,
        builder: (context, mode) {
          return Center(
            child: CupertinoActivityIndicator(
              radius: 11,
              color: AppColorHelper().primaryColor,
            ),
          );
        },
      ),
      child: child,
    );
  }
}
