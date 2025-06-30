import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instaclone/views/components/dialogs/alert_dialog_model.dart';
import 'package:instaclone/views/components/dialogs/logout_dialog.dart';
import 'package:instaclone/views/main/main_view.dart';

import '../../state/auth/providers/auth_state_provider.dart';
import '../../state/image_upload/helpers/image_picker_helper.dart';
import '../../state/image_upload/modals/file_type.dart';
import '../../state/post_settings/providers/post_settings_provider.dart';
import '../../state/providers/is_list_view_provider.dart';
import '../components/constants/strings.dart';
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

  Widget _getCurrentPage() {
    switch (_page) {
      case 0:
        return const HomeView();
      case 1:
        return const SearchView();
      case 4:
        return const UserPostView();
      default:
        return const HomeView();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isListView = ref.watch(isListViewProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.black,
        title: const Text(
          Strings.appName,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              final videoFile = await ImagePickerhelper.pickVideoFromgallery();
              if (videoFile == null) return;
              ref.refresh(postSettingProvider);
              if (!mounted) return;
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CreateNewPostView(
                    fileToPost: videoFile,
                    fileType: FileType.video,
                  ),
                ),
              );
            },
            icon: const FaIcon(FontAwesomeIcons.film, color: Colors.white),
          ),
          IconButton(
            onPressed: () async {
              final imageFile = await ImagePickerhelper.pickImageFromgallery();
              if (imageFile == null) return;
              ref.refresh(postSettingProvider);
              if (!mounted) return;
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CreateNewPostView(
                    fileToPost: imageFile,
                    fileType: FileType.image,
                  ),
                ),
              );
            },
            icon: const Icon(Icons.add_photo_alternate_outlined,
                color: Colors.white),
          ),
          IconButton(
            onPressed: () async {
              final shouldLogout = await const LogoutDialog().present(context);
              if (shouldLogout == true) {
                await ref.read(authStateProvider.notifier).logout();
              }
            },
            icon: const FaIcon(Icons.logout, color: Colors.white),
          ),
          IconButton(
            onPressed: () {
              ref.watch(isListViewProvider.notifier).state = !isListView;
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const MainView()),
              );
            },
            icon: const Icon(Icons.view_list, color: Colors.white),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(child: _getCurrentPage()),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        currentIndex: _page,
        onTap: (index) {
          setState(() {
            _page = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.compare), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.local_movies), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
        ],
      ),
    );
  }
}
