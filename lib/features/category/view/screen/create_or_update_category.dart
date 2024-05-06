import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:overcooked_admin/common/bloc/generic_bloc_state.dart';
import 'package:overcooked_admin/common/dialog/app_alerts.dart';
import 'package:overcooked_admin/common/dialog/progress_dialog.dart';
import 'package:overcooked_admin/common/dialog/retry_dialog.dart';
import 'package:overcooked_admin/common/widget/common_text_field.dart';
import 'package:overcooked_admin/common/widget/empty_widget.dart';
import 'package:overcooked_admin/core/utils/contants.dart';
import 'package:overcooked_admin/core/utils/extensions.dart';
import 'package:overcooked_admin/core/utils/util.dart';
import 'package:overcooked_admin/features/category/bloc/category_bloc.dart';
import 'package:overcooked_admin/features/category/data/model/category_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CreateOrUpdateCategory extends StatefulWidget {
  const CreateOrUpdateCategory(
      {super.key,
      required this.categoryModel,
      required this.mode,
      required this.lenght});
  final CategoryModel categoryModel;
  final int lenght;
  final Mode mode;

  @override
  State<CreateOrUpdateCategory> createState() => _CreateOrUpdateCategoryState();
}

class _CreateOrUpdateCategoryState extends State<CreateOrUpdateCategory> {
  late Mode _mode;
  late CategoryModel _categoryModel;
  Uint8List? _imageFile;
  String _image = '';
  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _desCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _uploadImageProgress = ValueNotifier(0.0);
  final _isUploadImage = ValueNotifier(false);
  var _lenght = 0;
  var _sortNumber = 0;

  @override
  void initState() {
    _mode = widget.mode;
    _lenght = widget.lenght;
    if (_mode == Mode.create) {
      _categoryModel = CategoryModel();
    }
    _initData();
    super.initState();
  }

  void _initData() {
    if (_mode == Mode.update) {
      _categoryModel = widget.categoryModel;
      _nameCtrl.text = _categoryModel.name ?? '';
      _desCtrl.text = _categoryModel.description ?? '';
      _image = _categoryModel.image ?? noImage;
      _sortNumber = _categoryModel.sort ?? 0;
    }
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
                  child: SingleChildScrollView(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _ImageCategory(
                          image: _image,
                          imageFile: _imageFile,
                          onTap: () async =>
                              await pickAndResizeImage().then((value) {
                                setState(() {
                                  _imageFile = value;
                                });
                              })),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 16),
                            _buildTitle('Tên danh mục (*):'),
                            const SizedBox(height: 16),
                            _buildNameCatagory(),
                            const SizedBox(height: 16),
                            _buildTitle('Thứ tự hiển thị (*):'),
                            const SizedBox(height: 16),
                            _buildSortCatagory(),
                            const SizedBox(height: 16),
                            _buildTitle('Mô tả:'),
                            const SizedBox(height: 16),
                            _buildDescriptionCatagory()
                          ]),
                      const SizedBox(height: 32),
                      _buildButton(),
                      const SizedBox(height: 8),
                      Text('(*) không được để trống',
                          style: context.textStyleSmall!.copyWith(
                              fontStyle: FontStyle.italic,
                              color: context.colorScheme.error))
                    ]),
              ))
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

  _buildTitle(String title) =>
      Text(title, style: const TextStyle(fontWeight: FontWeight.bold));

  _buildNameCatagory() => CommonTextField(
      hintText: 'Tên danh mục',
      controller: _nameCtrl,
      prefixIcon: const Icon(Icons.abc),
      validator: (value) =>
          value == null || value.isEmpty ? 'Tên danh mục không hợp lệ' : null,
      onChanged: (p0) {});

  _buildDescriptionCatagory() => CommonTextField(
      controller: _desCtrl,
      hintText: 'Mô tả',
      prefixIcon: const Icon(Icons.description),
      onChanged: (p0) {});

  _buildButton() => FilledButton(
      onPressed: _mode == Mode.create
          ? () => _handelCreateCategory()
          : () => _handelUpdateCategory(),
      child: Text(_mode == Mode.create ? 'Thêm danh mục' : 'Chỉnh sửa'));

  _handelCreateCategory() async {
    final invalid = _formKey.currentState?.validate() ?? false;
    final toast = FToast()..init(context);
    if (invalid) {
      if (_imageFile == null) {
        toast.showToast(child: AppAlerts.errorToast(msg: 'chưa chọn hình'));
      } else {
        _isUploadImage.value = true;
        _image = await uploadImage(
            path: 'category',
            file: _imageFile!,
            progress: _uploadImageProgress);
        _isUploadImage.value = false;
        var newCategory = CategoryModel(
            name: _nameCtrl.text,
            description: _desCtrl.text,
            image: _image,
            sort: _sortNumber);
        _createCategory(newCategory);
      }
    }
  }

  void _updateCategory(CategoryModel categoryModel) {
    context
        .read<CategoryBloc>()
        .add(CategoryUpdated(categoryModel: categoryModel));
    print(categoryModel.toString());
    showDialog(
        context: context,
        builder: (context) => BlocBuilder<CategoryBloc,
                GenericBlocState<CategoryModel>>(
            builder: (context, state) => switch (state.status) {
                  Status.loading => Container(color: Colors.transparent),
                  Status.empty => const EmptyWidget(),
                  Status.failure => RetryDialog(
                      title: state.error ?? '',
                      onRetryPressed: () => context
                          .read<CategoryBloc>()
                          .add(CategoryUpdated(categoryModel: categoryModel))),
                  Status.success => ProgressDialog(
                      descriptrion: 'Chỉnh sửa thành công!',
                      isProgressed: false,
                      onPressed: () {
                        pop(context, 2);
                      })
                }));
  }

  void _createCategory(CategoryModel newCategory) {
    context
        .read<CategoryBloc>()
        .add(CategoryCreated(categoryModel: newCategory));
    showDialog(
        context: context,
        builder: (context) =>
            BlocBuilder<CategoryBloc, GenericBlocState<CategoryModel>>(
                builder: (context, state) => switch (state.status) {
                      Status.loading => Container(color: Colors.transparent),
                      Status.empty => const EmptyWidget(),
                      Status.failure => RetryDialog(
                          title: state.error ?? '',
                          onRetryPressed: () => context
                              .read<CategoryBloc>()
                              .add(
                                  CategoryCreated(categoryModel: newCategory))),
                      Status.success => ProgressDialog(
                          descriptrion: 'Tạo danh mục thành công!',
                          isProgressed: false,
                          onPressed: () {
                            pop(context, 2);
                          })
                    }));
  }

  _handelUpdateCategory() async {
    final invalid = _formKey.currentState?.validate() ?? false;

    if (invalid) {
      if (_imageFile == null) {
        _categoryModel = _categoryModel.copyWith(
            image: _image,
            name: _nameCtrl.text,
            description: _desCtrl.text,
            sort: _sortNumber);
        _updateCategory(_categoryModel);
      } else {
        _isUploadImage.value = true;
        _image = await uploadImage(
            path: 'category',
            file: _imageFile!,
            progress: _uploadImageProgress);
        _isUploadImage.value = false;
        // print('ad $_sortNumber');
        _categoryModel = _categoryModel.copyWith(
            image: _image,
            name: _nameCtrl.text,
            description: _desCtrl.text,
            sort: _sortNumber);
        _updateCategory(_categoryModel);
      }
    }
  }

  _buildAppbar() => AppBar(
          centerTitle: true,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          title: Text(
              _mode == Mode.create ? 'Thêm danh mục' : "Chỉnh sửa danh mục",
              style: context.titleStyleMedium!
                  .copyWith(fontWeight: FontWeight.bold)),
          actions: [
            IconButton(
                onPressed: () => context.pop(),
                icon: const Icon(Icons.highlight_remove_rounded))
          ]);

  _buildSortCatagory() {
    var lstSort = <int>[];
    if (_mode == Mode.create) {
      for (int i = 0; i < _lenght + 1; i++) {
        lstSort.add(i + 1);
      }
      _sortNumber = lstSort.last;
    } else {
      for (int i = 0; i < _lenght; i++) {
        lstSort.add(i + 1);
      }
    }
    return Wrap(
        spacing: 4.0,
        runSpacing: 4.0,
        children: lstSort
            .map((e) => SizedBox(
                height: 25,
                child: FilledButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(
                            _sortNumber == e
                                ? context.colorScheme.errorContainer
                                : context.colorScheme.primaryContainer)),
                    onPressed: () {
                      setState(() {
                        _sortNumber = e;
                      });
                      // print(_sortNumber);
                    },
                    child: Text(e.toString()))))
            .toList());
  }
}

class _ImageCategory extends StatelessWidget {
  const _ImageCategory(
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
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(defaultBorderRadius),
                    image: DecorationImage(
                        image: MemoryImage(imageFile!), fit: BoxFit.cover))));
  }

  Widget _buildImage(BuildContext context) {
    return image == ''
        ? Container(
            height: 200,
            width: 200,
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
                      Text("Hình ảnh Danh mục", style: context.textStyleSmall)
                    ])))
        : Container(
            height: 200,
            width: 200,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(defaultBorderRadius),
                image: DecorationImage(
                    image: NetworkImage(image), fit: BoxFit.cover)));
  }
}
