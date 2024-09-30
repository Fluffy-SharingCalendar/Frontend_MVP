import 'package:fluffy_mvp/pages/calendar_page.dart';
import 'package:fluffy_mvp/models/login_model.dart';
import 'package:fluffy_mvp/services/login_service.dart';
import 'package:fluffy_mvp/widgets/alert.dart';
import 'package:flutter/material.dart';

class PhoneNumPage extends StatefulWidget {
  const PhoneNumPage({
    super.key,
    this.login,
  });

  final Login? login;

  @override
  State<PhoneNumPage> createState() => _PhoneNumPageState();
}

class _PhoneNumPageState extends State<PhoneNumPage> {
  TextEditingController textEditingController = TextEditingController();
  bool isValid = false;

  bool checkValidNickname(String nickname) {
    return nickname.isNotEmpty;
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
            const Text("글 작성을 통해 여러분의 의견을 들려주세요👂"),
            const Text("의견을 남겨주신 분 중 총 3분께 커피 기프티콘을 드립니다!"),
            const Text("이벤트 참여를 원하시면 전화번호를 기입해주시고, 원하지 않으신다면 빈칸으로 남겨주세요."),
            const SizedBox(
              height: 50,
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
                  hintText: "ex. 01012345678",
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(
              height: 15.0,
            ),
            const Text(
              "수요조사 기간이 끝난 후 전화전호 정보는 모두 폐기됩니다.",
              style: TextStyle(
                color: Colors.indigoAccent,
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            TextButton(
              onPressed: () async {
                widget.login!.phoneNumber = textEditingController.text;

                bool loginSuccess = await LoginService.login(widget.login!);

                if (loginSuccess) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CalendarPage(),
                    ),
                  );
                } else {
                  alert(context, "로그인 실패", "로그인에 실패했습니다.");
                }
              },
              child: const Text(
                "확인했습니다! 🙆🏻‍♀️",
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
