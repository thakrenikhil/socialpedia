import 'dart:io';

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:instaclone/state/auth/providers/user_id_provider.dart';
import 'package:instaclone/state/image_upload/modals/file_type.dart';
import 'package:instaclone/state/image_upload/modals/thumbnails_request.dart';
import 'package:instaclone/state/image_upload/providers/image_upload_provider.dart';
import 'package:instaclone/state/post_settings/models/post_setting.dart';
import 'package:instaclone/state/post_settings/providers/post_settings_provider.dart';
import 'package:instaclone/views/components/constants/strings.dart';
import 'package:instaclone/views/components/file_thumbnail_view.dart';

class CreateNewPostView extends StatefulHookConsumerWidget {
  final File fileToPost;
  final FileType fileType;

  const CreateNewPostView({
    super.key,
    required this.fileToPost,
    required this.fileType,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _State();
}

class _State extends ConsumerState<CreateNewPostView> {
  @override
  Widget build(BuildContext context) {
    final thumbnailRequest =
        ThumbnailRequest(fileType: widget.fileType, file: widget.fileToPost);
    final postSettings = ref.watch(postSettingProvider);
    final postController = useTextEditingController();
    final isPostButtonEnabled = useState(false);
    useEffect(
      () {
        void listener() {
          isPostButtonEnabled.value = postController.text.isNotEmpty;
        }

        postController.addListener(() {
          listener();
        });
        return () {
          postController.removeListener(() {
            listener();
          });
        };
      },
      [Strings.post],
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text(Strings.createNewPost),
        actions: [
          IconButton(
              onPressed: isPostButtonEnabled.value
                  ? () async {
                      final userId = ref.read(userIdProvider);
                      if (userId == null) {
                        return;
                      }
                      final message = postController.text;
                      final isUploaded = await ref
                          .read(imageUploadProvider.notifier)
                          .upload(
                              file: widget.fileToPost,
                              fileType: widget.fileType,
                              message: message,
                              postSettings: postSettings,
                              userId: userId);
                      if (isUploaded && mounted) {
                        Navigator.of(context).pop();
                      }
                    }
                  : null,
              icon: const Icon(Icons.send)),
        ],
      ),
      body: SingleChildScrollView(
          child: Column(
        children: [
          FileThumbnailView(thumbnailRequest: thumbnailRequest),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: Strings.pleaseWriteYourMessageHere,
              ),
              autofocus: true,
              maxLines: null,
              controller: postController,
            ),
          ),
          ...PostSetting.values.map((postSetting) => ListTile(
                title: Text(postSetting.title),
                subtitle: Text(postSetting.description),
                trailing: Switch(
                  value: postSettings[postSetting] ?? false,
                  onChanged: (isOn) {
                    ref
                        .read(postSettingProvider.notifier)
                        .setSetting(postSetting, isOn);
                  },
                ),
              ))
        ],
      )),
    );
  }
}
