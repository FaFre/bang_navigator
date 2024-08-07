import 'package:lensai/features/search_browser/domain/entities/modes.dart';
import 'package:lensai/features/share_intent/domain/entities/shared_content.dart';

final _baseUrl = Uri.https('kagi.com');

Uri assistantUri({
  required String prompt,
  required AssistantMode assistantMode,
  ResearchVariant? researchVariant,
  ChatModel? chatModel,
}) =>
    _baseUrl.replace(
      pathSegments: [
        'assistant',
      ],
      queryParameters: {
        'mode': assistantMode.value.toString(),
        'q': prompt,
        ...switch (assistantMode) {
          AssistantMode.research => {
              'sub_mode': researchVariant!.value.toString(),
            },
          AssistantMode.code => {},
          AssistantMode.chat => {
              'sub_mode': chatModel!.value.toString(),
            },
          AssistantMode.custom => {},
        },
      },
    );

Uri summarizerUri({
  required SharedContent document,
  required SummarizerMode mode,
}) =>
    _baseUrl.replace(
      pathSegments: [
        'summarizer',
        //TODO: check if really necessary
        'index.html',
      ],
      queryParameters: {
        'summary': mode.value,
        if (document case SharedUrl(url: final url)) 'url': url.toString(),
      },
      fragment: switch (document) {
        SharedText(text: final text) => text,
        _ => null,
      },
    );
