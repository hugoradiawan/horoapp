import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:horoflutter/uis/background.dart';
import 'package:horoflutter/uis/expand_tile.dart';
import 'package:horoflutter/uis/interest_tile.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(_) => Background(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: Colors.transparent,
            title: const Text(
              '@johndoe123',
              style: TextStyle(color: Colors.white),
            ),
          ),
          body: ListView(
            padding: const EdgeInsets.all(8),
            children: [
              Stack(
                alignment: Alignment.bottomLeft,
                children: [
                  Container(
                    height: 230,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "@johndoe123",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
              const Gap(20),
              ExpandTile(
                title: 'About',
                subtitle:
                    "Add in your profile details to help others know you better",
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        FloatingActionButton(
                          elevation: 0,
                          backgroundColor: Colors.white.withOpacity(0.1),
                          onPressed: () {},
                          child: const Icon(
                            Icons.add,
                            color: Colors.white,
                          ),
                        ),
                        const Gap(20),
                        const Text(
                          "Add Image",
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        Expanded(
                            flex: 2,
                            child: Text(
                              "Display Name:",
                              style: TextStyle(color: Colors.white),
                            )),
                        Expanded(flex: 3, child: TextField()),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                            flex: 2,
                            child: Text(
                              "Gender:",
                              style: TextStyle(color: Colors.white),
                            )),
                        Expanded(flex: 3, child: TextField()),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                            flex: 2,
                            child: Text(
                              "Birthday:",
                              style: TextStyle(color: Colors.white),
                            )),
                        Expanded(flex: 3, child: TextField()),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                            flex: 2,
                            child: Text(
                              "Horoscope:",
                              style: TextStyle(color: Colors.white),
                            )),
                        Expanded(flex: 3, child: TextField()),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                            flex: 2,
                            child: Text(
                              "Zodiac:",
                              style: TextStyle(color: Colors.white),
                            )),
                        Expanded(flex: 3, child: TextField()),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                            flex: 2,
                            child: Text(
                              "Height:",
                              style: TextStyle(color: Colors.white),
                            )),
                        Expanded(flex: 3, child: TextField()),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                            flex: 2,
                            child: Text(
                              "Weight:",
                              style: TextStyle(color: Colors.white),
                            )),
                        Expanded(flex: 3, child: TextField()),
                      ],
                    ),
                  ),
                ],
              ),
              const Gap(20),
              const InterestTile(),
            ],
          ),
        ),
      );
}
