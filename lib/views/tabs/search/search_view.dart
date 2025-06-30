import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instaclone/views/components/constants/strings.dart';
import 'package:instaclone/views/components/search_grid_view.dart';
import 'package:instaclone/views/extentions/dissmis_keyboard.dart';

class SearchView extends HookConsumerWidget {
  const SearchView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useTextEditingController();
    final searchTerm = useState('');

    useEffect(() {
      controller.addListener(() {
        searchTerm.value = controller.text;
      });
      return null;
    }, [controller]);

    return Container(
      color: const Color(0xFF121212), // dark background
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextField(
                controller: controller,
                textInputAction: TextInputAction.search,
                style: const TextStyle(color: Colors.white),
                cursorColor: Colors.white,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFF1E1E1E), // darker input box
                  hintText: Strings.enterYourSearchTerm,
                  hintStyle: TextStyle(color: Colors.grey.shade500),
                  labelStyle: const TextStyle(color: Colors.white),
                  suffixIcon: IconButton(
                    onPressed: () {
                      controller.clear();
                      dismissKeyboard();
                    },
                    icon: const Icon(Icons.clear, color: Colors.white70),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade700),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade700),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
          SearchGridView(searchTerm: searchTerm.value),
        ],
      ),
    );
  }
}
