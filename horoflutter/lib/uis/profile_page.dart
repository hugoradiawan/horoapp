import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:horoflutter/business_loc/auth_controller.dart';
import 'package:horoflutter/business_loc/nestjs_connect.dart';
import 'package:horoflutter/business_loc/profile.dart';
import 'package:horoflutter/extensions.dart';
import 'package:horoflutter/ui_loc/profile_controller.dart';
import 'package:horoflutter/uis/about/about_tile.dart';
import 'package:horoflutter/uis/background.dart';
import 'package:horoflutter/uis/interest_tile.dart';
import 'package:horoflutter/uis/zoho_chip.dart';
import 'package:socket_io_client/socket_io_client.dart';

class ProfileContent extends StatelessWidget {
  const ProfileContent({super.key, this.hideAppBar = false});

  final bool hideAppBar;

  @override
  Widget build(_) => Scaffold(
        backgroundColor: Colors.transparent,
        appBar: hideAppBar
            ? null
            : AppBar(
                centerTitle: true,
                backgroundColor: Colors.transparent,
                title: InkWell(
                  onTap: () async {
                    Get.find<AuthController>().erase();
                  },
                  child: Obx(
                    () => Text(
                      '@${Get.find<AuthController>().username}',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                actions: [
                  Obx(
                    () =>
                        (Get.find<AuthController>().profile.value?.isEmpty() ??
                                true)
                            ? const SizedBox.shrink()
                            : Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextButton(
                                    onPressed: () => Get.offAll(
                                      () => const HomePage(),
                                      transition: Transition.fadeIn,
                                    ),
                                    child: const Text(
                                      'Continue',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () => Get.offAll(
                                      () => const HomePage(),
                                      transition: Transition.fadeIn,
                                    ),
                                    icon: const Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                  )
                ],
              ),
        body: GetBuilder<ProfileController>(
          init: Get.find<ProfileController>(),
          builder: (pc) => ListView(
            padding: const EdgeInsets.all(8),
            children: [
              Stack(
                alignment: Alignment.bottomLeft,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      height: 230,
                      width: double.infinity,
                      color: Colors.white.withOpacity(0.1),
                      child: Stack(
                        children: [
                          ColoredBox(
                            color: Colors.white.withOpacity(0.1),
                            child: Obx(
                              () => CachedNetworkImage(
                                cacheKey: pc.cacheKey.value.toString(),
                                imageUrl: Get.find<NestJsConnect>().profileUrl,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                errorWidget: (context, url, error) {
                                  Future.delayed(
                                    const Duration(milliseconds: 100),
                                    () => pc.isFetchImageSucceed.value = false,
                                  );
                                  return const SizedBox();
                                },
                              ),
                            ),
                          ),
                          Obx(
                            () => Container(
                              decoration: BoxDecoration(
                                gradient: pc.isFetchImageSucceed.value
                                    ? LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Colors.transparent,
                                          Colors.black.withOpacity(0.5),
                                        ],
                                      )
                                    : null,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Obx(
                      () => Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                '@${pc.profile.value?.username ?? ''}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              if (pc.age != null)
                                Text(
                                  ', ${pc.age}',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                            ],
                          ),
                          if (!(pc.profile.value?.isEmpty() ?? true))
                            Text(
                              pc.profile.value?.gender == null
                                  ? 'ts'
                                  : pc.profile.value!.gender!
                                      ? 'Male'
                                      : 'Female',
                              style: const TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                              ),
                            ),
                          const Gap(15),
                          if (pc.profile.value?.horoscope != null &&
                              pc.profile.value?.zodiac != null)
                            Row(
                              children: [
                                ZohoChip(
                                  iconName: 'assets/hozo/Horoscope.svg',
                                  data: pc.profile.value!.horoscope!,
                                ),
                                const Gap(10),
                                ZohoChip(
                                  iconName: 'assets/hozo/Zodiac.svg',
                                  data: pc.profile.value!.zodiac!,
                                )
                              ],
                            ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              const Gap(20),
              const AboutTile(),
              const Gap(20),
              const InterestTile(),
            ],
          ),
        ),
      );
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(_) => const Background(
        child: ProfileContent(),
      );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(_) => Background(
        child: GetX<HomePageController>(
          init: HomePageController(),
          builder: (hpc) => Scaffold(
            appBar: AppBar(
              centerTitle: true,
              backgroundColor: Colors.transparent,
              leading: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  'assets/icon.png',
                  height: 40,
                ),
              ),
              title: Obx(
                () => Text(
                  '@${Get.find<AuthController>().username}',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
            backgroundColor: Colors.transparent,
            bottomNavigationBar: BottomNavigationBar(
                useLegacyColorScheme: true,
                type: BottomNavigationBarType.fixed,
                fixedColor: Colors.white,
                showUnselectedLabels: true,
                elevation: 0,
                currentIndex: hpc.tabIndex.value,
                backgroundColor: Colors.transparent,
                unselectedItemColor: Colors.white.withOpacity(0.6),
                onTap: (value) {
                  hpc.tabController.animateTo(value);
                },
                items: [
                  const BottomNavigationBarItem(
                    icon: Icon(Icons.message),
                    label: 'Message',
                  ),
                  const BottomNavigationBarItem(
                    icon: Icon(Icons.contact_mail_sharp),
                    label: 'Contact',
                  ),
                  const BottomNavigationBarItem(
                    icon: Icon(Icons.people),
                    label: 'Matches',
                  ),
                  BottomNavigationBarItem(
                    icon: Obx(
                      () => CircleAvatar(
                        radius: 15,
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: ClipOval(
                            child: CachedNetworkImage(
                              cacheKey: Get.find<ProfileController>()
                                  .cacheKey
                                  .value
                                  .toString(),
                              imageUrl: Get.find<NestJsConnect>().profileUrl,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              errorWidget: (context, url, error) {
                                Future.delayed(
                                  const Duration(milliseconds: 100),
                                  () => Get.find<ProfileController>()
                                      .isFetchImageSucceed
                                      .value = false,
                                );
                                return const SizedBox();
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                    label: 'Profile',
                  ),
                ]),
            body: TabBarView(
                physics: const NeverScrollableScrollPhysics(),
                controller: hpc.tabController,
                children: const [
                  ChatListPage(),
                  Center(
                    child:
                        Text('Contact', style: TextStyle(color: Colors.white)),
                  ),
                  MachesPage(),
                  ProfileContent(hideAppBar: true),
                ]),
          ),
        ),
      );
}

class HomePageController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late TabController tabController = TabController(length: 4, vsync: this);
  final RxInt tabIndex = 0.obs;

  @override
  void onInit() {
    Get.put(ChatController());
    tabController.addListener(() => tabIndex.value = tabController.index);
    super.onInit();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }
}

class MachesPage extends StatelessWidget {
  const MachesPage({super.key});

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
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                  ))
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

class MathesTabController extends GetxController {
  final RxList<Profile> matches = <Profile>[].obs;

  @override
  void onInit() {
    matches.listen((p0) => update());
    super.onInit();
  }

  @override
  Future<void> onReady() async {
    matches.assignAll(await Get.find<NestJsConnect>().getProfiles());
    super.onReady();
  }
}

class MatchesTab extends StatelessWidget {
  const MatchesTab({
    super.key,
  });

  @override
  Widget build(_) => Scaffold(
        backgroundColor: Colors.transparent,
        body: GetBuilder<MathesTabController>(
          init: MathesTabController(),
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
            )),
      );
}

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

class MatchesPageController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late TabController tabController = TabController(length: 4, vsync: this);

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }
}

class ChatListPage extends StatelessWidget {
  const ChatListPage({super.key});

  @override
  Widget build(_) => Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: const Text(
            'Messages',
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.search,
                color: Colors.white,
              ),
            ),
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.all(8),
          children: [
            for (int i = 0; i < 20; i++)
              Container(
                margin: const EdgeInsets.symmetric(vertical: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white.withOpacity(0.05),
                ),
                child: ListTile(
                  onTap: () {},
                  leading: CircleAvatar(
                    radius: 25,
                    child: ClipOval(
                      child: CachedNetworkImage(
                        imageUrl: 'https://picsum.photos/seed/$i/500/500',
                        fit: BoxFit.cover,
                        width: double.infinity,
                        progressIndicatorBuilder: (context, url, progress) =>
                            CircularProgressIndicator(
                          value: progress.progress,
                        ),
                      ),
                    ),
                  ),
                  title: Text('Andrew $i',
                      style: const TextStyle(color: Colors.white)),
                  subtitle:
                      const Text('Hi', style: TextStyle(color: Colors.grey)),
                ),
              ),
          ],
        ),
      );
}

class ChatRoomPage extends StatelessWidget {
  const ChatRoomPage({super.key});

  @override
  Widget build(_) => Background(
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: AppBar().preferredSize,
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios_rounded,
                    color: Colors.white,
                  ),
                ),
                CircleAvatar(
                  radius: 25,
                  child: ClipOval(
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: Obx(() => CachedNetworkImage(
                            imageUrl:
                                Get.find<ChatController>().profile.value == null
                                    ? ''
                                    : Get.find<NestJsConnect>().getProfileUrl(
                                        Get.find<ChatController>()
                                            .profile
                                            .value!
                                            .id!),
                            fit: BoxFit.cover,
                            width: double.infinity,
                            progressIndicatorBuilder:
                                (context, url, progress) =>
                                    CircularProgressIndicator(
                              value: progress.progress,
                            ),
                          )),
                    ),
                  ),
                ),
                const Gap(10),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(() => Text(
                          Get.find<ChatController>().profile.value == null
                              ? ''
                              : Get.find<ChatController>()
                                  .profile
                                  .value!
                                  .displayName!,
                          style: const TextStyle(color: Colors.white),
                        )),
                    Text(
                      'Online',
                      style: TextStyle(color: Colors.white.withOpacity(0.5)),
                    ),
                  ],
                ),
              ],
            ),
          ),
          backgroundColor: Colors.transparent,
          body: GetX<ChatController>(
            init: Get.find<ChatController>(),
            builder: (cc) => DashChat(
              currentUser: cc.chatter,
              onSend: cc.sendMessage,
              messages: cc.messages.toList(),
            ),
          ),
        ),
      );
}

class ChatController extends GetxController {
  final Socket socket = io(
    'http://${NestJsConnect.ip}:3002/chat',
    OptionBuilder().setTransports(['websocket']).disableAutoConnect().build(),
  );
  String? roomId;
  final Rxn<Profile> profile = Rxn<Profile>();
  late ChatUser chatter;

  late RxList<ChatMessage> messages = RxList<ChatMessage>(
    <ChatMessage>[],
  );
  @override
  void onInit() {
    socket.onConnect((_) => print('connect'));
    socket.on('message', onMessage);
    socket.on('getRoomId', (data) => roomId = data.toString());
    socket.on('getMessages', onGetMessage);
    socket.onDisconnect((_) => print('disconnect'));
    final Profile? profile = Get.find<AuthController>().profile.value;
    socket.connect();
    if (profile == null) return;
    chatter = ChatUser(
      id: profile.id!,
      firstName: profile.username,
      profileImage: Get.find<NestJsConnect>().profileUrl,
    );
    super.onInit();
  }

  void openRoom(Profile pro) {
    profile.value = pro;
    Get.to(() => const ChatRoomPage());
    socket.emit('openRoom', {
      "users": [chatter.id, pro.id]
    });
  }

  void onGetMessage(dynamic data) {
    final List<dynamic> rawMessages = data;
    messages.assignAll(rawMessages
        .map<ChatMessage>((e) => ChatMessage.fromJson(e))
        .toList()
        .reversed);
  }

  onMessage(dynamic data) {
    print('onMessage');
    final ChatMessage message = ChatMessage.fromJson(data);
    messages.assignAll([message, ...messages]);
  }

  void createRoom(String chattieId, {String? newRoomId}) {
    if (roomId == null) {
      if (newRoomId != null) {
        roomId = newRoomId;
      } else {
        final Random random = Random();
        roomId = random.nextInt(100).toString();
      }
    }
    final ChatRoom room = ChatRoom(
      users: [chatter.id, chattieId],
      messages: [],
    );
    socket.emit('createRoom', room.toJsonWithoutId());
  }

  void joinRoom(String roomId) {
    this.roomId = roomId;
    socket.emit('joinRoom', {
      'roomId': roomId,
      'userId': chatter.id,
    });
  }

  void sendMessage(ChatMessage message) {
    print('send message to $roomId');
    socket.emit('message', {
      'roomId': roomId,
      'user': chatter.toJson(),
      'text': message.text,
      'createdAt': DateTime.now().toUtc().toString(),
    });
  }

  @override
  void dispose() {
    socket.disconnect();
    socket.dispose();
    super.dispose();
  }
}

class ChatRoom {
  ChatRoom({
    this.id,
    required this.users,
    required this.messages,
  });

  final String? id;
  final List<String> users;
  final List<ChatMessage> messages;

  factory ChatRoom.fromJson(Map<String, dynamic> jsonData) => ChatRoom(
        id: jsonData['roomId'].toString(),
        users: jsonData['users'].cast<String>(),
        messages: jsonData['message']
            .map<ChatMessage>((e) => ChatMessage.fromJson(e))
            .toList(),
      );

  Map<String, dynamic> toJsonWithoutId() => <String, dynamic>{
        'users': users,
        'message': messages.map((e) => e.toJson()).toList(),
      };
}

// ListView(
//                   children: [
//                     const Gap(10),
//                     ListTile(
//                       title: const Text(
//                         'Match me with everyone',
//                         style: TextStyle(color: Colors.white),
//                       ),
//                       trailing: ObxValue<RxBool>(
//                         (val) => Switch(
//                           value: val.value,
//                           onChanged: val,
//                         ),
//                         RxBool(false),
//                       ),
//                     ),
//                     GridView.custom(
//                       gridDelegate: SliverWovenGridDelegate.count(
//                         crossAxisCount: 2,
//                         mainAxisSpacing: 8,
//                         crossAxisSpacing: 8,
//                         pattern: [
//                           const WovenGridTile(1),
//                           const WovenGridTile(
//                             5 / 7,
//                             crossAxisRatio: 0.9,
//                             alignment: AlignmentDirectional.centerEnd,
//                           ),
//                         ],
//                       ),
//                       childrenDelegate: SliverChildBuilderDelegate(
//                         (context, index) => Container(),
//                       ),
//                     ),
//                   ],
//                 )