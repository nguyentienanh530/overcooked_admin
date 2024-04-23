import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:overcooked_admin/common/widget/responsive.dart';
import '../../core/utils/utils.dart';
import 'common_text_style.dart';

class EmptyScreen extends StatelessWidget {
  const EmptyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Responsive(
        mobile: _buildMobileWidget(),
        tablet: _buildWebWidget(),
        desktop: _buildWebWidget());
  }

  Widget _buildMobileWidget() => Padding(
      padding: EdgeInsets.all(defaultPadding),
      child: Column(
          children: [
        Container(
            decoration: const BoxDecoration(
                color: Colors.black38, shape: BoxShape.circle),
            margin: EdgeInsets.all(defaultPadding),
            child: Image.asset("assets/image/empty.png")),
        const SizedBox(height: 16),
        Center(
            child: Text("Không có sản phẩm",
                style: CommonTextStyle.bold(fontSize: kTextSizeLarge))),
        const SizedBox(height: 16),
        Center(
            child: Text(
                "Xin lỗi, chúng tôi không thể tìm thấy bất kỳ kết quả nào cho mặt hàng của bạn.",
                style: CommonTextStyle.light(fontSize: kTextSizeSmall),
                textAlign: TextAlign.center))
      ]
              .animate(interval: 50.ms)
              .slideX(
                  begin: -0.1,
                  end: 0,
                  curve: Curves.easeInOutCubic,
                  duration: 500.ms)
              .fadeIn(curve: Curves.easeInOutCubic, duration: 500.ms)));

  Widget _buildWebWidget() => Padding(
      padding: EdgeInsets.all(defaultPadding),
      child: Row(children: [
        const Expanded(child: SizedBox()),
        Expanded(
            flex: 2,
            child: Column(
                children: [
              Container(
                  decoration: const BoxDecoration(
                      color: Colors.black38, shape: BoxShape.circle),
                  margin: EdgeInsets.all(defaultPadding),
                  child: Image.asset("assets/image/empty.png")),
              const SizedBox(height: 16),
              Center(
                  child: Text("Không có sản phẩm",
                      style: CommonTextStyle.bold(fontSize: kTextSizeLarge))),
              const SizedBox(height: 16),
              Center(
                  child: Text(
                      "Xin lỗi, chúng tôi không thể tìm thấy bất kỳ kết quả nào cho mặt hàng của bạn.",
                      style: CommonTextStyle.light(fontSize: kTextSizeSmall),
                      textAlign: TextAlign.center))
            ]
                    .animate(interval: 50.ms)
                    .slideX(
                        begin: -0.1,
                        end: 0,
                        curve: Curves.easeInOutCubic,
                        duration: 500.ms)
                    .fadeIn(curve: Curves.easeInOutCubic, duration: 500.ms))),
        const Expanded(child: SizedBox())
      ]));
}
