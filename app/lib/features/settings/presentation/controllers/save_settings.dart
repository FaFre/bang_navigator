import 'package:bang_navigator/features/settings/data/repositories/settings_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'save_settings.g.dart';

@Riverpod()
class SaveSettingsController extends _$SaveSettingsController {
  @override
  FutureOr<void> build() {}

  Future<void> save(UpdateSettingsFunc updateSettings) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref
          .read(settingsRepositoryProvider.notifier)
          .updateSettings(updateSettings),
    );
  }
}
