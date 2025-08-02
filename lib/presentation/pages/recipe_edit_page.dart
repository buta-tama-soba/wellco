import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../core/themes/app_colors.dart';
import '../../core/themes/app_text_styles.dart';
import '../../core/constants/app_constants.dart';
import '../../data/datasources/app_database.dart';
import '../providers/database_provider.dart';

/// レシピ編集ページ
class RecipeEditPage extends ConsumerStatefulWidget {
  final ExternalRecipeTableData recipe;

  const RecipeEditPage({
    super.key,
    required this.recipe,
  });

  @override
  ConsumerState<RecipeEditPage> createState() => _RecipeEditPageState();
}

class _RecipeEditPageState extends ConsumerState<RecipeEditPage> {
  final _formKey = GlobalKey<FormState>();
  
  late TextEditingController _titleController;
  late TextEditingController _tagsController;
  late TextEditingController _memoController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.recipe.title);
    _tagsController = TextEditingController(text: widget.recipe.tags ?? '');
    _memoController = TextEditingController(text: widget.recipe.memo ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'レシピ編集',
          style: AppTextStyles.headline2,
        ),
        actions: [
          // 削除ボタン
          Consumer(
            builder: (context, ref, child) {
              final saveState = ref.watch(recipeRegistrationProvider);
              
              return saveState.isLoading
                  ? const SizedBox.shrink()
                  : TextButton(
                      onPressed: _showDeleteConfirmation,
                      child: Text(
                        '削除',
                        style: AppTextStyles.body1.copyWith(
                          color: AppColors.error,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    );
            },
          ),
          // 保存ボタン
          Consumer(
            builder: (context, ref, child) {
              final saveState = ref.watch(recipeRegistrationProvider);
              
              return saveState.isLoading
                  ? Padding(
                      padding: EdgeInsets.all(16.w),
                      child: SizedBox(
                        width: 20.w,
                        height: 20.w,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.w,
                          valueColor: AlwaysStoppedAnimation(AppColors.primary),
                        ),
                      ),
                    )
                  : TextButton(
                      onPressed: _saveChanges,
                      child: Text(
                        '保存',
                        style: AppTextStyles.body1.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(AppConstants.paddingM.w),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // URL表示（編集不可）
                _buildUrlSection(),
                SizedBox(height: AppConstants.paddingL.h),
                
                // レシピプレビュー
                _buildRecipePreview(),
                SizedBox(height: AppConstants.paddingL.h),
                
                // タイトル入力
                _buildTitleField(),
                SizedBox(height: AppConstants.paddingM.h),
                
                // タグ入力
                _buildTagsField(),
                SizedBox(height: AppConstants.paddingM.h),
                
                // メモ入力
                _buildMemoField(),
                SizedBox(height: AppConstants.paddingL.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUrlSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'レシピURL',
          style: AppTextStyles.headline3,
        ),
        SizedBox(height: AppConstants.paddingS.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(AppConstants.paddingM.w),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppConstants.radiusM.r),
            border: Border.all(color: AppColors.primary.withOpacity(0.2)),
          ),
          child: Text(
            widget.recipe.url,
            style: AppTextStyles.body2.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRecipePreview() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppConstants.radiusL.r),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.2),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(AppConstants.paddingM.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // サイト名
            if (widget.recipe.siteName != null)
              Text(
                widget.recipe.siteName!,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.primary,
                ),
              ),
            
            // 現在のタイトル表示
            if (widget.recipe.title.isNotEmpty) ...[
              SizedBox(height: 4.h),
              Text(
                widget.recipe.title,
                style: AppTextStyles.headline3,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            
            // 説明
            if (widget.recipe.description != null) ...[
              SizedBox(height: 8.h),
              Text(
                widget.recipe.description!,
                style: AppTextStyles.body2.copyWith(
                  color: AppColors.textSecondary,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            
            // 画像
            if (widget.recipe.imageUrl != null) ...[
              SizedBox(height: AppConstants.paddingM.h),
              ClipRRect(
                borderRadius: BorderRadius.circular(AppConstants.radiusM.r),
                child: CachedNetworkImage(
                  imageUrl: widget.recipe.imageUrl!,
                  width: double.infinity,
                  height: 180.h,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: AppColors.surface,
                    child: Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2.w,
                        valueColor: AlwaysStoppedAnimation(AppColors.primary),
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: AppColors.surface,
                    child: Icon(
                      Icons.image_not_supported,
                      size: 48.w,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTitleField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'タイトル',
          style: AppTextStyles.headline3,
        ),
        SizedBox(height: AppConstants.paddingS.h),
        TextFormField(
          controller: _titleController,
          decoration: InputDecoration(
            hintText: 'レシピのタイトル',
            prefixIcon: Icon(Icons.title, size: 20.w),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'タイトルを入力してください';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildTagsField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'タグ（カンマ区切り）',
          style: AppTextStyles.headline3,
        ),
        SizedBox(height: AppConstants.paddingS.h),
        TextFormField(
          controller: _tagsController,
          decoration: InputDecoration(
            hintText: '和食, 簡単, 15分',
            prefixIcon: Icon(Icons.tag, size: 20.w),
          ),
        ),
      ],
    );
  }

  Widget _buildMemoField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'メモ',
          style: AppTextStyles.headline3,
        ),
        SizedBox(height: AppConstants.paddingS.h),
        TextFormField(
          controller: _memoController,
          decoration: InputDecoration(
            hintText: 'このレシピのポイントなど',
            prefixIcon: Icon(Icons.note, size: 20.w),
          ),
          maxLines: 3,
        ),
      ],
    );
  }

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) return;

    final recipeNotifier = ref.read(recipeRegistrationProvider.notifier);
    
    await recipeNotifier.updateExternalRecipe(
      recipeId: widget.recipe.id,
      title: _titleController.text,
      tags: _tagsController.text,
      memo: _memoController.text,
    );
    
    // 保存状態を監視
    final saveState = ref.read(recipeRegistrationProvider);
    
    saveState.when(
      data: (_) {
        // 成功メッセージを表示
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('レシピを更新しました'),
            backgroundColor: AppColors.success,
          ),
        );
        
        // 画面を閉じる
        Navigator.pop(context);
      },
      loading: () {
        // ローディング中は何もしない（UIで表示済み）
      },
      error: (error, _) {
        // エラーメッセージを表示
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('更新に失敗しました: $error'),
            backgroundColor: AppColors.error,
          ),
        );
      },
    );
  }

  Future<void> _showDeleteConfirmation() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text(
          'レシピを削除',
          style: AppTextStyles.headline3,
        ),
        content: Text(
          'このレシピを削除しますか？\nこの操作は取り消せません。',
          style: AppTextStyles.body2,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              'キャンセル',
              style: AppTextStyles.body2.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              '削除',
              style: AppTextStyles.body2.copyWith(
                color: AppColors.error,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );

    if (result == true) {
      await _deleteRecipe();
    }
  }

  Future<void> _deleteRecipe() async {
    final recipeNotifier = ref.read(recipeRegistrationProvider.notifier);
    
    await recipeNotifier.deleteExternalRecipe(widget.recipe.id);
    
    // 削除状態を監視
    final deleteState = ref.read(recipeRegistrationProvider);
    
    deleteState.when(
      data: (_) {
        // 成功メッセージを表示
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('レシピを削除しました'),
            backgroundColor: AppColors.success,
          ),
        );
        
        // 画面を閉じる
        Navigator.pop(context);
      },
      loading: () {
        // ローディング中は何もしない（UIで表示済み）
      },
      error: (error, _) {
        // エラーメッセージを表示
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('削除に失敗しました: $error'),
            backgroundColor: AppColors.error,
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _tagsController.dispose();
    _memoController.dispose();
    super.dispose();
  }
}