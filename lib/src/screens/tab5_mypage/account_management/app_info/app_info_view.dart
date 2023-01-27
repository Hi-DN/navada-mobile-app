import 'package:flutter/material.dart';
import 'package:navada_mobile_app/src/models/faq/faq_list_model.dart';
import 'package:navada_mobile_app/src/providers/app_info_provider.dart';
import 'package:navada_mobile_app/src/widgets/custom_appbar.dart';
import 'package:navada_mobile_app/src/widgets/space.dart';
import 'package:navada_mobile_app/src/widgets/text_style.dart';
import 'package:provider/provider.dart';

import 'app_info_view_model.dart';

class AppInfoView extends StatelessWidget {
  const AppInfoView({Key? key}) : super(key: key);

  static const String contactEmail = 'hidnmail@gmail.com';
  static const String contactGitHub = 'https://github.com/Hi-DN';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        titleText: '앱 정보',
        leadingYn: true,
        onTap: () => Navigator.pop(context),
      ),
      body: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => AppInfoProvider()),
          ChangeNotifierProvider(create: (context) => AppInfoViewModel()),
        ],
        builder: (context, child) => Container(
          margin: const EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _faqSection(context),
                const Space(height: 20.0),
                _contactSection(),
                const Space(height: 20.0),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //FAQ
  Widget _faqSection(context) {
    Provider.of<AppInfoProvider>(context, listen: false).fetchFAQList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const B20Text(text: 'FAQ'),
        const R14Text(
          text: '자주 묻는 질문을 확인해보세요.',
          textColor: Color(0XFFA4A4A4),
        ),
        _divider(Colors.black),
        Consumer<AppInfoProvider>(builder: (context, provider, child) {
          return provider.faqList != null
              ? _buildFAQList(provider.faqList!)
              : const CircularProgressIndicator();
        })
      ],
    );
  }

  Widget _buildFAQList(List<FAQ> faqList) {
    return ListView.builder(
        itemCount: faqList.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return _buildOneFAQ(faqList[index]);
        });
  }

  Widget _buildOneFAQ(FAQ faq) {
    return Consumer<AppInfoViewModel>(builder: (context, viewModel, child) {
      return Column(
        children: [
          _faqQuestion(faq),
          viewModel.isFAQAnswerShown[faq.faqId - 1]
              ? _faqAnswer(faq)
              : Container(),
          _divider(const Color(0xFFB7B7B7)),
        ],
      );
    });
  }

  Widget _faqQuestion(FAQ faq) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          B12Text(
            text: 'Q. ${faq.faqQuestion}',
            textColor: const Color(0xFF828282),
          ),
          Consumer<AppInfoViewModel>(
            builder: (context, viewModel, child) {
              int index = faq.faqId - 1;
              return IconButton(
                icon: Icon(viewModel.isFAQAnswerShown[index]
                    ? Icons.keyboard_arrow_up_sharp
                    : Icons.keyboard_arrow_down_sharp),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                iconSize: 18.0,
                color: const Color(0xFF828282),
                onPressed: () {
                  viewModel.toggleAnswerView(index);
                },
              );
            },
          )
        ],
      ),
    );
  }

  Widget _faqAnswer(FAQ faq) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      child: R10Text(
        text: 'A. ${faq.faqAnswer}',
        textColor: const Color(0xFF828282),
        params: const TextParams(overflow: TextOverflow.visible),
      ),
    );
  }

  //Contact
  Widget _contactSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const B20Text(text: 'Contact'),
        _divider(Colors.black),
        _contactItem(Icons.mail_rounded, contactEmail),
        _contactItem(Icons.file_download, contactGitHub)
      ],
    );
  }

  Widget _contactItem(IconData icon, String value) {
    return Container(
      margin: const EdgeInsets.only(top: 10.0),
      child: Row(
        children: [
          Icon(
            icon,
            size: 25.0,
            color: const Color(0xFFB7B7B7),
          ),
          const Space(width: 10.0),
          R16Text(text: value)
        ],
      ),
    );
  }

  Widget _divider(Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Divider(
        height: 1.0,
        thickness: 1.0,
        color: color,
      ),
    );
  }
}
