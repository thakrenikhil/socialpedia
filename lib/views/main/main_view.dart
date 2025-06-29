import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instaclone/state/auth/providers/auth_state_provider.dart';
import 'package:instaclone/state/image_upload/helpers/image_picker_helper.dart';
import 'package:instaclone/state/image_upload/modals/file_type.dart';
import 'package:instaclone/state/post_settings/providers/post_settings_provider.dart';
import 'package:instaclone/views/components/constants/strings.dart';
import 'package:instaclone/views/components/dialogs/alert_dialog_model.dart';
import 'package:instaclone/views/components/dialogs/logout_dialog.dart';
import 'package:instaclone/views/create_new_post/create_new_post_view.dart';
import 'package:instaclone/views/main/main_scroll_view.dart';
import 'package:instaclone/views/tabs/home/home_view.dart';
import 'package:instaclone/views/tabs/search/search_view.dart';
import 'package:instaclone/views/tabs/user_posts/user_post_view.dart';

import '../../state/providers/is_list_view_provider.dart';

class MainView extends ConsumerStatefulWidget {
  const MainView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MainViewState();
}

class _MainViewState extends ConsumerState<MainView> {
  @override
  Widget build(BuildContext context) {
    final isListView = ref.watch(isListViewProvider);

    return Scaffold(
      body: DefaultTabController(
          length: 3,
          child: Scaffold(
            appBar: AppBar(
              title: const Text(Strings.appName),
              actions: [
                IconButton(
                    onPressed: () async {
                      final videoFile =
                          await ImagePickerhelper.pickVideoFromgallery();
                      if (videoFile == null) {
                        return;
                      }

                      ref.refresh(postSettingProvider);

                      if (!mounted) {
                        return;
                      }
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => CreateNewPostView(
                                  fileToPost: videoFile,
                                  fileType: FileType.video)));
                    },
                    icon: const FaIcon(FontAwesomeIcons.film)),
                IconButton(
                    onPressed: () async {
                      final imageFile =
                          await ImagePickerhelper.pickImageFromgallery();
                      if (imageFile == null) {
                        return;
                      }

                      ref.refresh(postSettingProvider);

                      if (!mounted) {
                        return;
                      }
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => CreateNewPostView(
                                  fileToPost: imageFile,
                                  fileType: FileType.image)));
                    },
                    icon: const Icon(Icons.add_photo_alternate_outlined)),
                IconButton(
                    onPressed: () async {
                      final shouldLogout = await const LogoutDialog()
                          .present(context)
                          .then((value) => value ?? false);
                      if (shouldLogout) {
                        await ref.read(authStateProvider.notifier).logout();
                      }
                    },
                    icon: const FaIcon(Icons.login_sharp)),
                IconButton(
                    onPressed: () {
                      ref.watch(isListViewProvider.notifier).state = !isListView;

                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MainScrollView(),
                          ));
                    },
                    icon: const FaIcon(Icons.ad_units)),
              ],
              bottom: const TabBar(tabs: [
                Tab(
                  icon: Icon(Icons.home),
                ),
                Tab(
                  icon: Icon(Icons.search),
                ),
                Tab(
                  icon: Icon(Icons.person),
                ),
              ]),
            ),
            body: const TabBarView(
              children: [
                HomeView(),
                SearchView(),
                UserPostView(),
              ],
            ),
          )),
    );
  }
}
