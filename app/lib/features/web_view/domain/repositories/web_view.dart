import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:lensai/features/web_view/presentation/widgets/web_view.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'web_view.g.dart';

@Riverpod(keepAlive: true)
class WebViewTabController extends _$WebViewTabController {
  late Map<Key, WebView> _webViewTabs;

  @override
  WebView? build() {
    _webViewTabs = ref.watch(webViewRepositoryProvider);
    return (stateOrNull != null)
        ? _webViewTabs[stateOrNull!.page.value.key] ??
            _webViewTabs.values.lastOrNull
        : null;
  }

  void showTab(Key? key) {
    state = (key != null) ? _webViewTabs[key] : null;
  }
}

@Riverpod(keepAlive: true)
class WebViewRepository extends _$WebViewRepository {
  @override
  Map<Key, WebView> build() {
    return stateOrNull ?? {};
  }

  void addTab(WebView webView) {
    state = {...state, webView.page.value.key: webView};
  }

  void closeTab(Key key) {
    state = Map.of(state)..remove(key);
  }

  void closeAllTabs() {
    state = {};
  }
}
