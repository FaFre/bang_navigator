import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lensai/features/web_view/domain/repositories/web_view.dart';

class TabsActionButton extends HookConsumerWidget {
  final VoidCallback onTap;

  const TabsActionButton({required this.onTap, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tabCount =
        ref.watch(webViewRepositoryProvider.select((tabs) => tabs.length));

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 8.0,
          vertical: 15.0,
        ),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              width: 2.0,
              color: DefaultTextStyle.of(context).style.color!,
            ),
            borderRadius: BorderRadius.circular(5.0),
          ),
          constraints: const BoxConstraints(minWidth: 25.0),
          child: Center(
            child: Text(
              tabCount.toString(),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14.0,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
