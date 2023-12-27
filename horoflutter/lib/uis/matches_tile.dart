import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:horoflutter/business_loc/nestjs_connect.dart';
import 'package:horoflutter/business_loc/profile.dart';
import 'package:horoflutter/ui_loc/chat_controller.dart';

class MatchesTile extends StatelessWidget {
  const MatchesTile(
    this.profile, {
    super.key,
  });

  final Profile profile;

  @override
  Widget build(_) => Container(
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white.withOpacity(0.1),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: InkWell(
            onTap: () {
              if (profile.userId == null) {
                Get.snackbar(
                  'Error',
                  'This user is not registered',
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                );
                return;
              }
              Get.find<ChatController>().openRoom(profile);
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedNetworkImage(
                    imageUrl:
                        Get.find<NestJsConnect>().getProfileUrl(profile.id!),
                    fit: BoxFit.cover,
                    height: Random().nextInt(100).toDouble() + 130,
                    width: double.infinity,
                    errorWidget: (context, url, error) => Center(
                      child: SizedBox(
                        height: 60,
                        width: 60,
                        child: Image.asset('assets/icon.png'),
                      ),
                    ),
                    progressIndicatorBuilder: (context, url, progress) =>
                        Center(
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
                const Gap(10),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        profile.displayName ?? '',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '@${profile.username ?? ''}',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.6),
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        'Age 22 | ${profile.gender ?? ''}',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.3),
                          fontSize: 14,
                        ),
                      ),
                      const Gap(10),
                      Wrap(
                        runSpacing: 10,
                        children: (profile.interests ?? [])
                            .map(
                              (e) => Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 5,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white.withOpacity(
                                    0.1,
                                  ),
                                ),
                                margin: const EdgeInsets.only(
                                  right: 5,
                                ),
                                child: Text(
                                  e,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      )
                    ],
                  ),
                ),
                const Gap(10),
              ],
            ),
          ),
        ),
      );
}