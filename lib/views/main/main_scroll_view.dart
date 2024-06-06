import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instaclone/views/components/Animated_text.dart';
import 'package:instaclone/views/components/dialogs/alert_dialog_model.dart';
import 'package:instaclone/views/main/main_view.dart';

import '../../state/auth/providers/auth_state_provider.dart';
import '../../state/image_upload/helpers/image_picker_helper.dart';
import '../../state/image_upload/modals/file_type.dart';
import '../../state/post_settings/providers/post_settings_provider.dart';
import '../../state/providers/is_list_view_provider.dart';
import '../components/constants/strings.dart';
import '../components/dialogs/logout_dialog.dart';
import '../create_new_post/create_new_post_view.dart';
import '../tabs/home/home_view.dart';
import '../tabs/search/search_view.dart';
import '../tabs/user_posts/user_post_view.dart';

class MainScrollView extends ConsumerStatefulWidget {
  const MainScrollView({super.key});

  @override
  ConsumerState createState() => _MainScrollViewState();
}

class _MainScrollViewState extends ConsumerState<MainScrollView> {
  int _page = 0;
  GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  Widget _getCurrentPage() {
    switch (_page) {
      case 0:
        return const HomeView();
      case 1:
        return const SearchView();
      case 4:
        return const UserPostView();
      default:
        return const HomeView(); // Default to HomeView if page index is out of range
    }
  }

  @override
  Widget build(BuildContext context) {
    final isListView = ref.watch(isListViewProvider);

    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        items: const <Widget>[
          Icon(Icons.home, size: 30),
          Icon(Icons.search, size: 30),
          Icon(Icons.compare, size: 30),
          Icon(
            Icons.local_movies_sharp,
            size: 30,
          ),
          Icon(Icons.person, size: 30),
        ],
        onTap: (index) {
          setState(() {
            _page = index;
          });
        },
        color: Colors.black,
        backgroundColor: Colors.white10,
        animationDuration: const Duration(milliseconds: 300),
        buttonBackgroundColor: Colors.blue,
        height: 60,
      ),
      body: Scaffold(
        backgroundColor: Colors.black54,
        appBar: AppBar(
          backgroundColor: Colors.blue.shade300,
          title: const AnimatedText(text: Strings.appName, Colors.black),
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
                icon: const FaIcon(
                  FontAwesomeIcons.film,
                  color: Colors.black,
                )),
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
                icon: const Icon(
                  Icons.add_photo_alternate_outlined,
                  color: Colors.black,
                )),
            IconButton(
                onPressed: () async {
                  final shouldLogout = await const LogoutDialog()
                      .present(context)
                      .then((value) => value ?? false);
                  if (shouldLogout) {
                    await ref.read(authStateProvider.notifier).logout();
                  }
                },
                icon: const FaIcon(
                  Icons.login_sharp,
                  color: Colors.black,
                )),
            IconButton(
                onPressed: () {
                  ref.watch(isListViewProvider.notifier).state = !isListView;

                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MainView(),
                      ));
                },
                icon: const FaIcon(
                  Icons.more_vert_outlined,
                  color: Colors.black,
                )),
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // if (_page == 0)const Center(child: AnimatedText(text: 'My Feed', Colors.white),),

            Expanded(child: _getCurrentPage()),
          ],
        ),
      ),
    );
  }
}
