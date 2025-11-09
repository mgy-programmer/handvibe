import 'package:flutter/material.dart';
import 'package:handvibe/model_view/services/language_localizations.dart';
import 'package:handvibe/utility/color_bank.dart';
import 'package:handvibe/utility/text_font.dart';
import 'package:handvibe/view/molecule/custom_dropdown.dart';

class FAQPage extends StatefulWidget {
  const FAQPage({super.key});

  @override
  State<FAQPage> createState() => _FAQPageState();
}

class _FAQPageState extends State<FAQPage> {
  int openedOption = -1;
  List<String> questions = ["question_one", "question_two", "question_three", "question_four", "question_five"];
  List<String> answer = ["answer_one", "answer_two", "answer_three", "answer_four", "answer_five"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorBank().primary,
        title: Text(
          AppLocalizations.of(context)!.translate("faq"),
          style: TextFont().ralewayRegularMethod(
            18,
            ColorBank().white,
            context,
          ),
        ),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios,
            color: ColorBank().white,
            size: 22,
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: questions.length,
        itemBuilder: (context, index) {
          return CustomDropdown(
            openedOption: openedOption,
            onTap: () {
              setState(() {
                if (openedOption == index) {
                  openedOption = -1;
                } else {
                  openedOption = index;
                }
              });
            },
            question: AppLocalizations.of(context)!.translate(questions[index]),
            answer: AppLocalizations.of(context)!.translate(answer[index]),
            index: index,
          );
        },
      ),
    );
  }
}
