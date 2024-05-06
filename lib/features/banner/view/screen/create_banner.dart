import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:overcooked_admin/common/bloc/generic_bloc_state.dart';
import 'package:overcooked_admin/common/dialog/app_alerts.dart';
import 'package:overcooked_admin/common/dialog/progress_dialog.dart';
import 'package:overcooked_admin/common/dialog/retry_dialog.dart';
import 'package:overcooked_admin/common/widget/empty_widget.dart';
import 'package:overcooked_admin/core/utils/contants.dart';
import 'package:overcooked_admin/core/utils/extensions.dart';
import 'package:overcooked_admin/core/utils/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:overcooked_admin/features/banner/bloc/banner_bloc.dart';
import 'package:overcooked_admin/features/banner/data/model/banner_model.dart';

class CreateBanner extends StatefulWidget {
  const CreateBanner({super.key});

  @override
  State<CreateBanner> createState() => _CreateBannerState();
}

class _CreateBannerState extends State<CreateBanner> {
  // late BannerModel _bannerModel;
  Uint8List? _imageFile;
  String _image = '';
  final _formKey = GlobalKey<FormState>();
  final _uploadImageProgress = ValueNotifier(0.0);
  final _isUploadImage = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var buildWidget = SafeArea(
        child: Form(
            key: _formKey,
            child: Column(children: [
              _buildAppbar(),
              const SizedBox(height: 16),
              Expanded(
                  child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            _ImageBanner(
                                image: _image,
                                imageFile: _imageFile,
                                onTap: () async => await pickAndResizeImage(
                                            width: 800, height: 340)
                                        .then((value) {
                                      setState(() {
                                        _imageFile = value;
                                      });
                                    })),
                            const SizedBox(height: 32),
                            _buildButton()
                          ])))
            ])));

    var uploadImageWidget = ValueListenableBuilder(
        valueListenable: _uploadImageProgress,
        builder: (context, value, child) {
          logger.d(value);
          return Scaffold(
              body: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        LinearProgressIndicator(
                            value: value / 100,
                            color: context.colorScheme.secondary,
                            backgroundColor: context.colorScheme.primary),
                        const SizedBox(height: 16),
                        Text('Uploading ${(value).toStringAsFixed(2)} %')
                      ])));
        });

    return ValueListenableBuilder(
        valueListenable: _isUploadImage,
        builder: (context, value, child) =>
            value ? uploadImageWidget : buildWidget);
  }

  _buildButton() => FilledButton(
      onPressed: () => _handelCreateBanner(), child: const Text('Thêm Banner'));

  _handelCreateBanner() async {
    final invalid = _formKey.currentState?.validate() ?? false;
    final toast = FToast()..init(context);
    if (invalid) {
      if (_imageFile == null) {
        toast.showToast(child: AppAlerts.errorToast(msg: 'chưa chọn hình'));
      } else {
        _isUploadImage.value = true;
        _image = await uploadImage(
            path: 'Banner', file: _imageFile!, progress: _uploadImageProgress);
        _isUploadImage.value = false;
        var newBanner = BannerModel(image: _image);
        _createBanner(newBanner);
      }
    }
  }

  void _createBanner(BannerModel newBanner) {
    showDialog(
        context: context,
        builder: (context) => BlocProvider(
            create: (context) =>
                BannerBloc()..add(BannerCreated(bannerModel: newBanner)),
            child: BlocBuilder<BannerBloc, GenericBlocState<BannerModel>>(
                builder: (context, state) => switch (state.status) {
                      Status.loading => Container(color: Colors.transparent),
                      Status.empty => const EmptyWidget(),
                      Status.failure => RetryDialog(
                          title: state.error ?? '',
                          onRetryPressed: () => context
                              .read<BannerBloc>()
                              .add(BannerCreated(bannerModel: newBanner))),
                      Status.success => ProgressDialog(
                          descriptrion: 'Tạo banner thành công!',
                          isProgressed: false,
                          onPressed: () {
                            pop(context, 2);
                          })
                    })));
  }

  _buildAppbar() => AppBar(
          centerTitle: true,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          title: Text('Thêm Banner',
              style: context.titleStyleMedium!
                  .copyWith(fontWeight: FontWeight.bold)),
          actions: [
            IconButton(
                onPressed: () => context.pop(),
                icon: const Icon(Icons.highlight_remove_rounded))
          ]);
}

class _ImageBanner extends StatelessWidget {
  const _ImageBanner(
      {required this.image, required this.imageFile, required this.onTap});
  final String image;
  final Uint8List? imageFile;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: imageFile == null
            ? _buildImage(context)
            : Container(
                height: 155,
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(defaultBorderRadius),
                    image: DecorationImage(
                        image: MemoryImage(imageFile!), fit: BoxFit.cover))));
  }

  Widget _buildImage(BuildContext context) {
    return image == ''
        ? Container(
            height: 155,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(defaultBorderRadius)),
            child: DottedBorder(
                dashPattern: const [6, 6],
                color: context.colorScheme.secondary,
                strokeWidth: 1,
                radius: Radius.circular(defaultBorderRadius),
                borderType: BorderType.RRect,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Align(
                          alignment: Alignment.topCenter,
                          child: Container(
                              height: 48,
                              width: 48,
                              decoration: BoxDecoration(
                                  color: context.colorScheme.primary,
                                  border: Border.all(
                                      color: context.colorScheme.primary,
                                      width: 1),
                                  borderRadius: BorderRadius.circular(
                                      defaultBorderRadius)),
                              child: Icon(Icons.add,
                                  color: context.colorScheme.secondary))),
                      SizedBox(height: defaultPadding / 2),
                      Text("Hình ảnh Banner", style: context.textStyleSmall)
                    ])))
        : Container(
            height: 155,
            width: double.infinity,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(defaultBorderRadius),
                image: DecorationImage(
                    image: NetworkImage(image), fit: BoxFit.cover)));
  }
}
