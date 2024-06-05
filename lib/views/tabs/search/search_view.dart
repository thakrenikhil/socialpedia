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
      controller.addListener(
        () {
          searchTerm.value = controller.text;
        },
      );
    }, [controller]);

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.all(8),
            child: TextField(
              controller: controller,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                  labelText: Strings.enterYourSearchTerm,
                  suffixIcon: IconButton(
                      onPressed: () {
                        controller.clear();
                        dismissKeyboard();
                      },
                      icon: Icon(Icons.clear))),
            ),
          ),
        ),
       SearchGridView(searchTerm: searchTerm.value)
      ],
    );
  }
}
