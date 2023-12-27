import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:horoflutter/extensions.dart';
import 'package:horoflutter/ui_loc/matches_page_controller.dart';
import 'package:horoflutter/uis/matches_tab.dart';

class MatchesPage extends StatelessWidget {
  const MatchesPage({super.key});

  @override
  Widget build(_) => GetBuilder<MatchesPageController>(
        init: MatchesPageController(),
        builder: (spc) => Scaffold(
          backgroundColor: Colors.transparent,
          appBar: TabBar(
              unselectedLabelColor: Colors.white.withOpacity(0.6),
              labelColor: Colors.white,
              indicatorColor: Colors.white,
              indicatorSize: TabBarIndicatorSize.tab,
              dividerColor: Colors.grey.withOpacity(0.5),
              controller: spc.tabController,
              tabs: const [
                Tab(text: 'Service'),
                Tab(text: 'Matches'),
                Tab(text: 'Explore'),
                Tab(text: 'Favorite'),
              ]),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: TabBarView(controller: spc.tabController, children: [
              Column(
                children: [
                  const Gap(10),
                  TextField(
                    decoration: const InputDecoration().horoTransparent(
                      hintText: 'Search for Services',
                      hintStyle:
                          TextStyle(color: Colors.white.withOpacity(0.5)),
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.white.withOpacity(0.5),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      children: [
                        for (int i = 0; i < 100; i = i + 2)
                          Container(
                            margin: const EdgeInsets.symmetric(
                              vertical: 10,
                            ),
                            height: 160,
                            child: Row(
                              children: [
                                AspectRatio(
                                  aspectRatio: 1,
                                  child: Container(
                                    margin: const EdgeInsets.only(right: 10),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: CachedNetworkImage(
                                        imageUrl:
                                            'https://picsum.photos/seed/${i + 1}/500/500',
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        progressIndicatorBuilder:
                                            (context, url, progress) => Center(
                                          child: SizedBox(
                                            height: 30,
                                            width: 30,
                                            child: CircularProgressIndicator(
                                              value: progress.progress,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Gap(10),
                                      const Text(
                                        'Develop and make 3D Character Design for your game',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const Gap(10),
                                      Text(
                                        'Games | Development',
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.5),
                                          fontSize: 15,
                                        ),
                                      ),
                                      const Gap(10),
                                      Row(
                                        children: [
                                          const Text(
                                            '8.5m',
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                          const Gap(5),
                                          Icon(
                                            Icons.circle,
                                            color: Colors.white.withOpacity(
                                              0.5,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const Gap(10),
                                      Row(
                                        children: [
                                          CircleAvatar(
                                            radius: 15,
                                            child: ClipOval(
                                              child: CachedNetworkImage(
                                                imageUrl:
                                                    'https://picsum.photos/seed/${i + 2}/500/500',
                                                fit: BoxFit.cover,
                                                width: double.infinity,
                                                progressIndicatorBuilder:
                                                    (context, url, progress) =>
                                                        CircularProgressIndicator(
                                                  value: progress.progress,
                                                ),
                                              ),
                                            ),
                                          ),
                                          const Gap(10),
                                          Text(
                                            '@Andrew911',
                                            style: TextStyle(
                                              color: Colors.white.withOpacity(
                                                0.5,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                      ],
                    ),
                  )
                ],
              ),
              const MatchesTab(),
              const Center(
                  child: Text(
                'Explore',
                style: TextStyle(color: Colors.white),
              )),
              const Center(
                  child: Text(
                'Favorite',
                style: TextStyle(color: Colors.white),
              )),
            ]),
          ),
        ),
      );
}