import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../core/themes/app_colors.dart';
import '../../core/themes/app_text_styles.dart';
import '../../core/constants/app_constants.dart';
import '../../core/services/ogp_fetcher_service.dart';
import '../providers/database_provider.dart';
import 'recipe_viewer_page.dart';

/// レシピURL登録ページ
class RecipeUrlRegisterPage extends ConsumerStatefulWidget {
  const RecipeUrlRegisterPage({super.key});

  @override
  ConsumerState<RecipeUrlRegisterPage> createState() => _RecipeUrlRegisterPageState();
}

class _RecipeUrlRegisterPageState extends ConsumerState<RecipeUrlRegisterPage> {
  final _urlController = TextEditingController();
  final _tagsController = TextEditingController();
  final _memoController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  
  final _ogpFetcher = OgpFetcherService();
  
  bool _isLoading = false;
  OgpData? _ogpData;
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'レシピURL登録',
          style: AppTextStyles.headline2,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(AppConstants.paddingM.w),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // URL入力フィールド
                _buildUrlField(),
                SizedBox(height: AppConstants.paddingM.h),
                
                // OGPプレビュー
                if (_ogpData != null) ...[
                  _buildOgpPreview(),
                  SizedBox(height: AppConstants.paddingL.h),
                ],
                
                // エラーメッセージ
                if (_errorMessage != null) ...[
                  _buildErrorMessage(),
                  SizedBox(height: AppConstants.paddingM.h),
                ],
                
                // タグ入力
                _buildTagsField(),
                SizedBox(height: AppConstants.paddingM.h),
                
                // メモ入力
                _buildMemoField(),
                SizedBox(height: AppConstants.paddingL.h),
                
                // 保存ボタン
                _buildSaveButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUrlField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'レシピURL',
          style: AppTextStyles.headline3,
        ),
        SizedBox(height: AppConstants.paddingS.h),
        TextFormField(
          controller: _urlController,
          decoration: InputDecoration(
            hintText: 'https://example.com/recipe',
            prefixIcon: Icon(Icons.link, size: 20.w),
            suffixIcon: _isLoading
                ? Padding(
                    padding: EdgeInsets.all(12.w),
                    child: SizedBox(
                      width: 20.w,
                      height: 20.w,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.w,
                        valueColor: AlwaysStoppedAnimation(AppColors.primary),
                      ),
                    ),
                  )
                : IconButton(
                    icon: Icon(Icons.search, size: 24.w),
                    onPressed: _fetchOgpData,
                  ),
          ),
          keyboardType: TextInputType.url,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'URLを入力してください';
            }
            if (!Uri.tryParse(value)!.hasScheme) {
              return '有効なURLを入力してください';
            }
            return null;
          },
          onFieldSubmitted: (_) => _fetchOgpData(),
        ),
      ],
    );
  }

  Widget _buildOgpPreview() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppConstants.radiusL.r),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.2),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppConstants.radiusL.r),
          onTap: () {
            // プレビューでWebViewを開く
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RecipeViewerPage(
                  url: _urlController.text,
                  title: _ogpData?.title,
                ),
              ),
            );
          },
          child: Padding(
            padding: EdgeInsets.all(AppConstants.paddingM.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // サイト名
                if (_ogpData!.siteName != null)
                  Text(
                    _ogpData!.siteName!,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                
                // タイトル
                if (_ogpData!.title != null) ...[
                  SizedBox(height: 4.h),
                  Text(
                    _ogpData!.title!,
                    style: AppTextStyles.headline3,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                
                // 説明
                if (_ogpData!.description != null) ...[
                  SizedBox(height: 8.h),
                  Text(
                    _ogpData!.description!,
                    style: AppTextStyles.body2.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                
                // 画像
                if (_ogpData!.imageUrl != null) ...[
                  SizedBox(height: AppConstants.paddingM.h),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(AppConstants.radiusM.r),
                    child: CachedNetworkImage(
                      imageUrl: _ogpData!.imageUrl!,
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
        ),
      ),
    );
  }

  Widget _buildErrorMessage() {
    return Container(
      padding: EdgeInsets.all(AppConstants.paddingM.w),
      decoration: BoxDecoration(
        color: AppColors.error.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppConstants.radiusM.r),
        border: Border.all(
          color: AppColors.error.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline,
            size: 20.w,
            color: AppColors.error,
          ),
          SizedBox(width: AppConstants.paddingS.w),
          Expanded(
            child: Text(
              _errorMessage!,
              style: AppTextStyles.body2.copyWith(
                color: AppColors.error,
              ),
            ),
          ),
        ],
      ),
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

  Widget _buildSaveButton() {
    final saveState = ref.watch(recipeRegistrationProvider);
    
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: (_ogpData != null && !saveState.isLoading) ? _saveRecipe : null,
        icon: saveState.isLoading 
          ? SizedBox(
              width: 20.w,
              height: 20.w,
              child: CircularProgressIndicator(
                strokeWidth: 2.w,
                valueColor: const AlwaysStoppedAnimation(Colors.white),
              ),
            )
          : Icon(Icons.save, size: 20.w),
        label: saveState.isLoading 
          ? const Text('保存中...')
          : const Text('レシピを保存'),
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 16.h),
        ),
      ),
    );
  }

  Future<void> _fetchOgpData() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _ogpData = null;
    });
    
    try {
      final ogpData = await _ogpFetcher.fetchOgpData(_urlController.text);
      
      setState(() {
        _ogpData = ogpData;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceAll('Exception: ', '');
        _isLoading = false;
      });
    }
  }

  Future<void> _saveRecipe() async {
    if (_ogpData == null) return;
    
    // データベースに保存
    final recipeNotifier = ref.read(recipeRegistrationProvider.notifier);
    
    await recipeNotifier.saveExternalRecipe(
      url: _urlController.text,
      title: _ogpData!.title ?? 'タイトルなし',
      description: _ogpData!.description,
      imageUrl: _ogpData!.imageUrl,
      siteName: _ogpData!.siteName,
      tags: _tagsController.text.isNotEmpty ? _tagsController.text : null,
      memo: _memoController.text.isNotEmpty ? _memoController.text : null,
    );
    
    // 保存状態を監視
    final saveState = ref.read(recipeRegistrationProvider);
    
    saveState.when(
      data: (_) {
        // 成功メッセージを表示
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('レシピを保存しました'),
            backgroundColor: AppColors.success,
          ),
        );
        
        // 画面を閉じる
        Navigator.pop(context);
      },
      loading: () {
        // ローディング中は何もしない（UIで表示）
      },
      error: (error, _) {
        // エラーメッセージを表示
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('保存に失敗しました: $error'),
            backgroundColor: AppColors.error,
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _urlController.dispose();
    _tagsController.dispose();
    _memoController.dispose();
    super.dispose();
  }
}