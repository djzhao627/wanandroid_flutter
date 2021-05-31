import 'package:banner_view/banner_view.dart';
import 'package:flutter/material.dart';

class BannerItem extends StatelessWidget {
  final List<Widget> _banners;

  BannerItem(this._banners);

  @override
  Widget build(BuildContext context) {
    return _banners.isNotEmpty
        ? BannerView(
            _banners,

            /// 自动轮播间隔
            intervalDuration: const Duration(seconds: 3),
          )
        : Container();
  }
}
