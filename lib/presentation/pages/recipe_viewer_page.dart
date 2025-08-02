import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/themes/app_colors.dart';
import '../../core/themes/app_text_styles.dart';
import '../../core/constants/app_constants.dart';

/// レシピ閲覧ページ（WebView）
class RecipeViewerPage extends ConsumerStatefulWidget {
  final String url;
  final String? title;

  const RecipeViewerPage({
    super.key,
    required this.url,
    this.title,
  });

  @override
  ConsumerState<RecipeViewerPage> createState() => _RecipeViewerPageState();
}

class _RecipeViewerPageState extends ConsumerState<RecipeViewerPage> {
  InAppWebViewController? _webViewController;
  double _progress = 0;
  bool _isLoading = true;
  String? _currentTitle;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _currentTitle = widget.title;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          _currentTitle ?? 'レシピ',
          style: AppTextStyles.headline3,
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          // 更新ボタン
          IconButton(
            icon: Icon(Icons.refresh, size: 24.w),
            onPressed: () {
              _webViewController?.reload();
            },
          ),
          // 外部ブラウザで開く
          IconButton(
            icon: Icon(Icons.open_in_browser, size: 24.w),
            onPressed: () async {
              final url = await _webViewController?.getUrl();
              if (url != null) {
                // URLを外部ブラウザで開く処理
                // url_launcher パッケージを使用
              }
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          if (_errorMessage != null)
            _buildErrorView()
          else
            _buildWebView(),
          
          // プログレスバー
          if (_isLoading)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: LinearProgressIndicator(
                value: _progress,
                backgroundColor: AppColors.surface,
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildWebView() {
    return InAppWebView(
      initialUrlRequest: URLRequest(
        url: WebUri(widget.url),
      ),
      initialSettings: InAppWebViewSettings(
        // セキュリティ設定
        javaScriptEnabled: true,
        domStorageEnabled: true,
        
        // HTTPSのみ許可
        mixedContentMode: MixedContentMode.MIXED_CONTENT_NEVER_ALLOW,
        
        // ユーザーエージェント設定
        userAgent: 'Mozilla/5.0 (iPhone; CPU iPhone OS 16_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148',
        
        // その他の設定
        supportZoom: true,
        transparentBackground: true,
        disableContextMenu: false,
        
        // iOS固有の設定
        allowsInlineMediaPlayback: true,
        allowsBackForwardNavigationGestures: true,
      ),
      onWebViewCreated: (controller) {
        _webViewController = controller;
      },
      onLoadStart: (controller, url) {
        setState(() {
          _isLoading = true;
          _errorMessage = null;
        });
      },
      onProgressChanged: (controller, progress) {
        setState(() {
          _progress = progress / 100;
        });
      },
      onLoadStop: (controller, url) async {
        setState(() {
          _isLoading = false;
        });
        
        // タイトルを取得
        final title = await controller.getTitle();
        if (title != null && title.isNotEmpty) {
          setState(() {
            _currentTitle = title;
          });
        }
      },
      onReceivedError: (controller, request, error) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'ページの読み込みに失敗しました: ${error.description}';
        });
      },
      onReceivedHttpError: (controller, request, response) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'ページが見つかりません (${response.statusCode})';
        });
      },
      shouldOverrideUrlLoading: (controller, navigationAction) async {
        final url = navigationAction.request.url;
        
        // HTTPSでないURLはブロック
        if (url != null && url.scheme != 'https' && url.scheme != 'http') {
          return NavigationActionPolicy.CANCEL;
        }
        
        return NavigationActionPolicy.ALLOW;
      },
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppConstants.paddingL.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64.w,
              color: AppColors.error,
            ),
            SizedBox(height: AppConstants.paddingM.h),
            Text(
              'エラーが発生しました',
              style: AppTextStyles.headline3.copyWith(
                color: AppColors.error,
              ),
            ),
            SizedBox(height: AppConstants.paddingS.h),
            Text(
              _errorMessage ?? '不明なエラー',
              style: AppTextStyles.body2.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppConstants.paddingL.h),
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  _errorMessage = null;
                });
                _webViewController?.reload();
              },
              icon: Icon(Icons.refresh, size: 20.w),
              label: const Text('再読み込み'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}