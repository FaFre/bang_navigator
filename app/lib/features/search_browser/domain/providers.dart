// ignore_for_file: use_setters_to_change_properties

import 'dart:async';

import 'package:bang_navigator/features/search_browser/domain/entities/sheet.dart';
import 'package:bang_navigator/features/search_browser/domain/services/create_tab.dart';
import 'package:flutter/widgets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:rxdart/rxdart.dart';

part 'providers.g.dart';

@Riverpod()
class OverlayDialog extends _$OverlayDialog {
  @override
  Widget? build() {
    return null;
  }

  void show(Widget dialog) {
    state = dialog;
  }

  void dismiss() {
    state = null;
  }
}

@Riverpod()
class BottomSheet extends _$BottomSheet {
  @override
  Sheet? build() {
    return ref.watch(
      createTabStreamProvider.select(
        (value) => value.valueOrNull,
      ),
    );
  }

  void show(Sheet sheet) {
    state = sheet;
  }

  void dismiss() {
    state = null;
  }
}

@Riverpod(keepAlive: true)
class BottomSheetExtend extends _$BottomSheetExtend {
  late StreamController<double> _extentStreamController;

  void add(double extent) {
    _extentStreamController.add(extent);
  }

  @override
  Stream<double> build() {
    _extentStreamController = StreamController();
    ref.onDispose(() async {
      await _extentStreamController.close();
    });

    return _extentStreamController.stream
        .sampleTime(const Duration(milliseconds: 50));
  }
}
