import 'package:fluffy_mvp/widgets/profile_image.dart';
import 'package:fluffy_mvp/pages/phone_num_page.dart';
import 'package:fluffy_mvp/models/profile_image_list.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class StartPage extends StatefulWidget {
  const StartPage({
    super.key,
  });

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  TextEditingController textEditingController = TextEditingController();
  bool isValid = false;

  List<String> profileImageList = ProfileImageList.profileImages;
  Random random = Random();
  late int index;

  bool checkValidNickname(String nickname) {
    return nickname.isNotEmpty;
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      index = random.nextInt(profileImageList.length);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 120.0,
            ),
            const Text(
              "Fluffy",
              style: TextStyle(
                fontSize: 30.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            const Text("추억을 공유하는 캘린더, 플러피입니다🫧"),
            const Text("현재 MVP로 수요도 조사를 진행 중입니다."),
            const Text("원활한 이용을 위해 PC 전체화면을 권장합니다."),
            const SizedBox(
              height: 50,
            ),
            const ProfileImage(),
            const SizedBox(
              height: 30.0,
            ),
            Container(
              width: 500.0,
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 3.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: TextField(
                controller: textEditingController,
                decoration: const InputDecoration(
                  hintText: "플러피에서 사용할 닉네임을 입력해주세요.",
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(
              height: 15.0,
            ),
            isValid
                ? const Text("")
                : const Text(
                    "닉네임은 최소 한 글자 이상이어야 합니다.",
                    style: TextStyle(
                      color: Colors.indigoAccent,
                    ),
                  ),
            const SizedBox(
              height: 40,
            ),
            TextButton(
              onPressed: () {
                if (checkValidNickname(textEditingController.text)) {
                  isValid = true;
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PhoneNumPage(),
                    ),
                  );
                } else {
                  isValid = false;
                }
              },
              child: const Text(
                "이 닉네임으로 할래요 🙋🏻‍♀️",
                style: TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.w300,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
