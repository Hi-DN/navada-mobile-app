import 'package:flutter/material.dart';
import 'package:navada_mobile_app/src/models/notification/notification_list_model.dart';
import 'package:navada_mobile_app/src/models/user/user_provider.dart';
import 'package:navada_mobile_app/src/providers/notification_provider.dart';
import 'package:navada_mobile_app/src/widgets/colors.dart';
import 'package:navada_mobile_app/src/widgets/custom_appbar.dart';
import 'package:navada_mobile_app/src/widgets/no_elements_screen.dart';
import 'package:navada_mobile_app/src/widgets/space.dart';
import 'package:navada_mobile_app/src/widgets/text_style.dart';
import 'package:provider/provider.dart';

class NotificationView extends StatelessWidget {
  const NotificationView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        titleText: '알림',
        leadingYn: true,
        onTap: () => Navigator.pop(context),
      ),
      body: ChangeNotifierProvider(
        create: (context) => NotificationProvider(),
        builder: (context, child) => _buildBody(context),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    int userId = UserProvider.user.userId!;
    Provider.of<NotificationProvider>(context, listen: false)
        .fetchNotifications(userId);

    return Consumer<NotificationProvider>(builder: (context, provider, child) {
      return provider.notificationListModel != null
          ? provider.notificationList!.isNotEmpty
              ? _buildNotificationList(provider.notificationList!)
              : const NoElements(text: '알림 내역이 존재하지 않습니다:D')
          : const Center(
              child: CircularProgressIndicator(),
            );
    });
  }

  Widget _buildNotificationList(List<NotificationContentModel> notifications) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      child: ListView.builder(
          itemCount: notifications.length,
          itemBuilder: (context, index) {
            return _buildNotificationItem(notifications[index]);
          }),
    );
  }

  Widget _buildNotificationItem(NotificationContentModel notification) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          alignment: Alignment.topRight,
          child: R12Text(
            text: getDateFormat(notification.createdDate!),
            textColor: grey153,
          ),
        ),
        const Space(height: 3.0),
        R14Text(
          text: "[${notification.notificationType!.label}]",
          textColor: grey153,
        ),
        const Space(height: 3.0),
        R14Text(
          text: notification.notificationContent!,
          params: const TextParams(overflow: TextOverflow.visible),
        ),
        const Space(height: 3.0),
        const Divider(thickness: 1.0)
      ],
    );
  }

  String getDateFormat(String createdDt) {
    List<String> date = createdDt.split("T")[0].split("-");
    String month = date[1];
    String day = date[2];

    return "$month월 $day일";
  }
}
