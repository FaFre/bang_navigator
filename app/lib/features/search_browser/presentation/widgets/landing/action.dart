import 'package:bang_navigator/core/routing/routes.dart';
import 'package:bang_navigator/features/search_browser/domain/entities/modes.dart';
import 'package:bang_navigator/features/search_browser/domain/entities/sheet.dart';
import 'package:bang_navigator/features/search_browser/domain/services/create_tab.dart';
import 'package:bang_navigator/features/search_browser/presentation/widgets/error_container.dart';
import 'package:bang_navigator/features/settings/data/models/settings.dart';
import 'package:bang_navigator/features/settings/data/repositories/settings_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class LandingAction extends HookConsumerWidget {
  const LandingAction({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionTokenAvailable = ref.watch(
      settingsRepositoryProvider.select(
        (value) => value.valueOrNull?.kagiSession?.isNotEmpty ?? false,
      ),
    );

    final showEarlyAccessFeatures = ref.watch(
      settingsRepositoryProvider.select(
        (value) => (value.valueOrNull ?? Settings.withDefaults())
            .showEarlyAccessFeatures,
      ),
    );

    return Visibility(
      visible: sessionTokenAvailable,
      replacement: ErrorContainer(
        content: Markdown(
          shrinkWrap: true,
          onTapLink: (text, href, title) async {
            if (href == 'settings') {
              await context.push(SettingsRoute().location);
            }
          },
          data: '## No Kagi Session Provided\n'
              'Please navigate to [Settings](settings) and enter your Kagi Session Token.\n'
              "You must provide a valid session in order to use Kagi's features.",
        ),
      ),
      child: Wrap(
        spacing: 8.0,
        alignment: WrapAlignment.spaceEvenly,
        children: [
          OutlinedButton.icon(
            onPressed: () {
              ref.read(createTabStreamProvider.notifier).createTab(
                    CreateTab(preferredTool: KagiTool.search),
                  );
            },
            icon: const Icon(MdiIcons.searchWeb),
            label: const Text('Search'),
          ),
          OutlinedButton.icon(
            onPressed: () {
              ref.read(createTabStreamProvider.notifier).createTab(
                    CreateTab(preferredTool: KagiTool.summarizer),
                  );
            },
            icon: const Icon(MdiIcons.text),
            label: const Text('Summarizer'),
          ),
          if (showEarlyAccessFeatures)
            OutlinedButton.icon(
              onPressed: () {
                ref.read(createTabStreamProvider.notifier).createTab(
                      CreateTab(preferredTool: KagiTool.assistant),
                    );
              },
              icon: const Icon(MdiIcons.brain),
              label: const Text('Assistant'),
            ),
        ],
      ),
    );
  }
}
