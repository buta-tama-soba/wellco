# ウェルコ (Wellco)

**あなたの健康パートナー**

パーソナルトレーナー × 料理人 × 励ましサポーター

## コンセプト

ウェルコは、これまでにない特別なアシスタントです。
- **パーソナルトレーナー** として運動をサポート
- **料理人** として栄養バランスの取れた食事を提案
- **励ましサポーター** として目標達成を応援

Wellness（健康）+ Coach（コーチ）= **Wellco（ウェルコ）**

## 主な機能

### 🏠 ホーム画面
- 時刻と記録状況に応じた励ましメッセージ
- 今日の栄養バランス概要
- 体重推移グラフ（1週間移動平均）
- 歩数進捗表示

### 🍽️ 食事管理
- 食品在庫管理
- レシピ検索・提案
- 食事記録
- 栄養バランス分析（カロリー、タンパク質、脂質、炭水化物）

### 🚶‍♂️ 身体・活動
- HealthKit連携による自動データ取得
- 体重・体脂肪率管理
- 歩数・消費カロリー・運動時間・睡眠時間
- 手動入力対応

### ⚙️ 設定
- アプリ設定
- データ管理

## 技術スタック

- **Flutter 3.24+** with Material Design 3
- **State Management**: Riverpod + Flutter Hooks
- **Database**: Drift (SQLite ORM)
- **UI**: ドーパミンデザインカラーパレット
- **Device Integration**: HealthKit (iOS)
- **Responsive**: flutter_screenutil

## 開発環境

### 必要な環境
- Flutter SDK 3.24+
- iOS 14.0+
- Xcode (iOS開発用)

### セットアップ

```bash
# リポジトリのクローン
git clone https://github.com/buta-tama-soba/wellco.git
cd wellco

# 依存関係のインストール
flutter pub get

# iOS依存関係のインストール
cd ios && pod install && cd ..

# アプリの実行
flutter run
```

## ライセンス

このプロジェクトはプライベートプロジェクトです。

## 開発者

[@buta-tama-soba](https://github.com/buta-tama-soba)

---

**Wellco** - あなたの健康な未来をサポートします