import 'package:flutter/material.dart';
import 'package:navada_mobile_app/src/providers/product_detail_provider.dart';
import 'package:navada_mobile_app/src/screens/product_detail/product_detail_view_model.dart';
import 'package:provider/provider.dart';

import '../../models/request/request_dto_model.dart';
import '../../widgets/colors.dart';
import '../../widgets/screen_size.dart';
import '../../widgets/text_style.dart';

class ProductDetailRequests extends StatefulWidget {
  const ProductDetailRequests({Key? key}) : super(key: key);

  @override
  ProductDetailRequestsState createState() => ProductDetailRequestsState();
}

class ProductDetailRequestsState extends State<ProductDetailRequests> {
  final ScreenSize screenSize = ScreenSize();

  @override
  Widget build(BuildContext context) {
    List<RequestDtoContentModel> requestList =
        Provider.of<ProductDetailProvider>(context, listen: false)
            .requestDtoList;

    return SizedBox(
      width: screenSize.getSize(160.0),
      height: screenSize.getSize(40.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            elevation: 0.0,
            primary: navy,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0))),
        child: const R18Text(
          text: '교환 수락하기',
          textColor: Colors.white,
        ),
        onPressed: () {
          _showRequestListSheet(
              Provider.of<ProductDetailViewModel>(context, listen: false).like,
              requestList);
        },
      ),
    );
  }

  // void _showRequestListSheet(List<RequestDtoContentModel> requestList) {
  //   showModalBottomSheet(
  //       context: context,
  //       shape:
  //           RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
  //       builder: (BuildContext context) {
  //         return StatefulBuilder(
  //             builder: (BuildContext context, StateSetter setState) {
  //           return Column(
  //             children: [
  //               const SizedBox(height: 20.0),
  //               Container(
  //                 width: screenSize.getSize(42.0),
  //                 height: screenSize.getSize(5.0),
  //                 decoration: BoxDecoration(
  //                     color: const Color(0xFFE2E2E2),
  //                     borderRadius: BorderRadius.circular(15.0)),
  //               ),
  //               const SizedBox(height: 20.0),
  //               Expanded(child: _requestListView(requestList)),
  //               const SizedBox(height: 20.0),
  //               _acceptRequestButton(),
  //               const SizedBox(height: 20.0),
  //             ],
  //           );
  //         });
  //       });
  // }

  void _showRequestListSheet(
      bool like, List<RequestDtoContentModel> requestList) {
    showModalBottomSheet(
        context: context,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        builder: (context) {
          return RequestListSheet(initialLike: like, requestList: requestList);
        });
  }
}

class RequestListSheet extends StatelessWidget {
  bool initialLike;
  List<RequestDtoContentModel> requestList;
  ScreenSize screenSize = ScreenSize();

  RequestListSheet(
      {Key? key, required this.initialLike, required this.requestList})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ignore: avoid_print
    print("sheet build!");

    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
              create: (context) => ProductDetailViewModel(initialLike))
        ],
        builder: (context, child) {
          return Center(
            child: Column(
              children: [
                const SizedBox(height: 20.0),
                Container(
                  width: screenSize.getSize(42.0),
                  height: screenSize.getSize(5.0),
                  decoration: BoxDecoration(
                      color: const Color(0xFFE2E2E2),
                      borderRadius: BorderRadius.circular(15.0)),
                ),
                const SizedBox(height: 20.0),
                Expanded(
                  child: _requestListView(requestList),
                ),
                const SizedBox(height: 20.0),
                _acceptRequestButton(),
                const SizedBox(height: 20.0),
              ],
            ),
          );
        });
  }

  Widget _requestListView(List<RequestDtoContentModel> requestList) {
    ScrollController scrollController = ScrollController();

    return SizedBox(
      width: screenSize.getSize(342.0),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Scrollbar(
            controller: scrollController,
            radius: const Radius.circular(10.0),
            thumbVisibility: true,
            child: ListView.builder(
                controller: scrollController,
                itemCount: requestList.length,
                itemBuilder: (context, index) {
                  return _buildItem(context, requestList[index]);
                })),
      ),
    );
  }

  Widget _buildItem(context, RequestDtoContentModel request) {
    return SizedBox(
      height: screenSize.getSize(100.0),
      width: screenSize.getSize(320.0),
      child: Column(
        children: [
          const SizedBox(height: 15.0),
          Expanded(
            child: Row(
              children: [
                const SizedBox(width: 11.0),
                SizedBox(
                  height: screenSize.getSize(70.0),
                  width: screenSize.getSize(70.0),
                  child: Image.asset(
                    'assets/images/test.jpeg',
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 11.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 3.0),
                      B14Text(text: request.acceptorProductName),
                      Expanded(child: Container()),
                      R14Text(
                        text: "원가 ${request.acceptorProductCost}원",
                        textColor: Colors.black.withOpacity(0.5),
                      ),
                      const SizedBox(height: 2.0),
                      R14Text(
                        text:
                            "희망가격 ${request.acceptorProductCost - request.acceptorProductCostRange}원 ~ ${request.acceptorProductCost + request.acceptorProductCostRange}원",
                        textColor: Colors.black.withOpacity(0.5),
                      ),
                      const SizedBox(height: 3.0),
                    ],
                  ),
                ),
                SizedBox(
                  width: screenSize.getSize(20.0),
                  height: screenSize.getSize(20.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Provider.of<ProductDetailViewModel>(context,
                              listen: false)
                          .setSelectedRequestId(request.requestId);
                    },
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(10.0),
                        elevation: 0.0,
                        primary: Provider.of<ProductDetailViewModel>(context)
                                    .selectedRequestId ==
                                request.requestId
                            ? green
                            : Colors.white,
                        shape: const CircleBorder(
                            side: BorderSide(width: 2.5, color: grey153))),
                    child: Container(),
                  ),
                ),
                const SizedBox(width: 11.0),
              ],
            ),
          ),
          const SizedBox(height: 15.0),
          Container(
            width: screenSize.getSize(320.0),
            height: 1.0,
            color: const Color(0xFFE2E2E2),
          )
        ],
      ),
    );
  }

  Widget _acceptRequestButton() {
    return SizedBox(
      width: screenSize.getSize(327.0),
      height: screenSize.getSize(50.0),
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
            elevation: 0.0,
            primary: navy,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(27.0))),
        child: const R18Text(
          text: '교환 수락하기',
          textColor: Colors.white,
        ),
      ),
    );
  }
}
