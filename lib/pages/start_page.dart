import 'package:fluffy_mvp/models/login_model.dart';
import 'package:fluffy_mvp/services/login_service.dart';
import 'package:fluffy_mvp/widgets/profile_image.dart';
import 'package:fluffy_mvp/pages/phone_num_page.dart';
import 'package:fluffy_mvp/widgets/alert.dart';
import 'package:flutter/material.dart';

class StartPage extends StatefulWidget {
  const StartPage({
    super.key,
  });

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  TextEditingController textEditingController = TextEditingController();
  int selectedIndex = 0;

  Future<bool> checkValidNickname(
    String nickname,
  ) async {
    if (nickname.isEmpty || nickname.length > 25) {
      await alert(context, "유효하지 않은 닉네임", "닉네임의 길이는 1자 이상 25자 이하입니다.");
    } else if (!await LoginService.checkNickname(nickname)) {
      await alert(context, "유효하지 않은 닉네임", "중복된 닉네임 입니다.");
    } else {
      return true;
    }
    return false;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
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
            ProfileImage(
              indexChanged: (newIndex) {
                setState(() {
                  selectedIndex = newIndex;
                });
              },
            ),
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
            const SizedBox(
              height: 40,
            ),
            TextButton(
              onPressed: () async {
                if (await checkValidNickname(textEditingController.text)) {
                  Login login = Login(
                    nickname: textEditingController.text,
                    profileImageIndex: selectedIndex,
                  );

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PhoneNumPage(
                        login: login,
                      ),
                    ),
                  );
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
