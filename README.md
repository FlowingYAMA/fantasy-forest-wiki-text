# 空想森林攻略 · 纯文字版

与 `fantasy_forest_wiki` 功能相同，但**不包含任何游戏内 PNG 素材**，仅打包 `wiki_data.json`。

- 列表/详情用 Material 图标与文字徽章代替图片
- 法阵仍用 JSON 几何数据绘制连线（非游戏贴图）
- 可与完整版同时安装（包名不同）

## 构建

```powershell
cd D:\Myapp\fantasy_forest_wiki_text
D:\Flutter\flutter\bin\flutter.bat pub get
D:\Flutter\flutter\bin\flutter.bat build apk --release
```

APK：`build\app\outputs\flutter-apk\app-release.apk`

## 同步数据

从 train 脚本重新生成 JSON 后复制：

```powershell
copy C:\Users\jly05\Desktop\train\fantasy-forest-wiki\assets\game\wiki_data.json D:\Myapp\fantasy_forest_wiki_text\assets\game\wiki_data.json
```

或运行 `build_flutter_data.py` 指向本项目的 `assets/game` 目录。
