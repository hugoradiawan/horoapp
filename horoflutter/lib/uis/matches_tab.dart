import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:horoflutter/ui_loc/matches_tab_controller.dart';
import 'package:horoflutter/uis/matches_tile.dart';

class MatchesTab extends StatelessWidget {
  const MatchesTab({
    super.key,
  });

  @override
  Widget build(_) => Scaffold(
        backgroundColor: Colors.transparent,
        body: GetBuilder<MatchesTabController>(
          init: MatchesTabController(),
          builder: (mtc) => mtc.matches.isEmpty
              ? const SizedBox.shrink()
              : MasonryGridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 4,
                  crossAxisSpacing: 4,
                  itemBuilder: (_, index) {
                    if (index > mtc.matches.length - 1) return const SizedBox();
                    return MatchesTile(mtc.matches[index]);
                  },
                ),
        ),
        floatingActionButton: FloatingActionButton(
          shape: const CircleBorder(),
          onPressed: () {},
          backgroundColor: const Color.fromARGB(255, 255, 118, 250),
          child: const Icon(
            Icons.settings_input_composite_rounded,
            color: Colors.white,
          ),
        ),
      );
}