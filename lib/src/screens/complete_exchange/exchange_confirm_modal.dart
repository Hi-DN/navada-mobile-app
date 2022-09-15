// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:navada_mobile_app/src/models/exchange/exchange_dto_model.dart';
import 'package:navada_mobile_app/src/models/user/user_provider.dart';
import 'package:navada_mobile_app/src/providers/complete_exchange_provider.dart';
import 'package:navada_mobile_app/src/screens/complete_exchange/complete_exchange_view_model.dart';
import 'package:navada_mobile_app/src/widgets/colors.dart';
import 'package:navada_mobile_app/src/widgets/long_circled_btn.dart';
import 'package:navada_mobile_app/src/widgets/screen_size.dart';
import 'package:navada_mobile_app/src/widgets/space.dart';
import 'package:navada_mobile_app/src/widgets/text_style.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class ExchangeConfirmModal extends StatelessWidget {
  ExchangeConfirmModal({Key? key, this.exchange}) : super(key: key);

  final ExchangeDtoModel? exchange;
  late BuildContext? _context;

  @override
  Widget build(BuildContext context) {
    ScreenSize size = ScreenSize();
    _context = context;
    
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CompleteExchangeViewModel(true)),
        ChangeNotifierProvider(create: (context) => CompleteExchangeProvider()),
      ],
      child: Container(
          padding: EdgeInsets.all(size.getSize(15)),
          height: size.getSize(420),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _greyStick(),
              const Space(height: 15),
              _titleSection(),
              const Space(height: 15),
              const _RatingSection(),
              const Space(height: 15),
              _completeExchangeBtn(exchange)
            ],
          ),
        )
    );
  }
  
  Widget _greyStick() {
    ScreenSize size = ScreenSize();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 3,
            width: size.getSize(40),
            decoration: BoxDecoration(
              color: grey216,
              borderRadius: BorderRadius.circular(size.getSize(10)),
              border: Border.all(color: Colors.white, width: 3.0),
              ))
      ]),
    );
  }

  Widget _titleSection() {
    return const R16Text(text: "교환을 완료하시겠습니까?");
  }

  Widget _completeExchangeBtn(ExchangeDtoModel? exchange) {
    int userId = Provider.of<UserProvider>(_context!, listen: false).user.userId;
    bool isAcceptor = (userId == exchange!.acceptorId);

    return Consumer2<CompleteExchangeViewModel, CompleteExchangeProvider>(builder: 
    (BuildContext context, CompleteExchangeViewModel viewModel, CompleteExchangeProvider provider, Widget? _) {
      
      bool isInitial= viewModel.isInitial;
      bool hasConfirmedRating = viewModel.hasConfirmedRating;
      double rating = viewModel.rating;
      
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          LongCircledBtn(
            onTap: () {
              if(!isInitial) {
                if(hasConfirmedRating)
                  provider.rateExchange(exchange.exchangeId, isAcceptor, rating);
                provider.completeExchange(exchange.exchangeId, isAcceptor);
                viewModel.setCompleteFeatureActive(false);
                Navigator.of(context).pop();
              }
            },
            text: "교환 완료하기",
            backgroundColor: isInitial ? grey183 : navy,
          ),
        ],
      );
    });
  }
}

class _RatingSection extends StatelessWidget {
  const _RatingSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScreenSize size = ScreenSize();
    return Padding(
        padding: EdgeInsets.all(size.getSize(10)),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minWidth: double.infinity),
          child: Container(
            height: size.getSize(210),
            padding: EdgeInsets.all(size.getSize(15)),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: grey183, width: 1.0),
            ),
            child: Column(
              children: [
                _titleSection(),
                const Space(height: 30),
                _starSection(),
                const Space(height: 30),
                _confirmBtnSection()
            ]),
          ),
        ),
      );
  }

  Widget _titleSection() {
    return Row(
        mainAxisAlignment: MainAxisAlignment.start, 
        children: const [R16Text(text: "교환 상대에게 별점을 주새요!")]);
  }

  Widget _starSection() {
    ScreenSize size = ScreenSize();
    return Consumer<CompleteExchangeViewModel>(builder: 
    (BuildContext context, CompleteExchangeViewModel viewModel, Widget? _) {
      
      bool isStarGrey = viewModel.isStarGrey;
      
      return RatingBar(
        unratedColor: grey183,
        initialRating: 0,
        direction: Axis.horizontal,
        allowHalfRating: true,
        itemCount: 5,
        updateOnDrag:true,
        glow: false,
        itemSize: size.getSize(50),
        ratingWidget: RatingWidget(
          full: Icon(Icons.star, color: isStarGrey ? grey216 : green),
          half: Icon(Icons.star_half, color: isStarGrey ? grey216 : green),
          empty: Icon(Icons.star_border_outlined, color: isStarGrey ? grey216 : green),
        ),
        itemPadding: const EdgeInsets.symmetric(horizontal: 0),
        onRatingUpdate: (rating) {
          viewModel.setRating(rating);
        },
      );
    });
  }

  Widget _confirmBtnSection() {
    ScreenSize size = ScreenSize();
    return Consumer<CompleteExchangeViewModel>(builder: 
    (BuildContext context, CompleteExchangeViewModel viewModel, Widget? _) {
      
      bool hasConfirmedNoRating = viewModel.hasConfirmedNoRating;
      bool hasConfirmedRating = viewModel.hasConfirmedRating;
      
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          GestureDetector(
            onTap: () {
              viewModel.setConfirmedNoRating(true);

            },
            child: Container(
              alignment: Alignment.center,
              width: size.getSize(115), 
              height: size.getSize(40),
              decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: hasConfirmedNoRating ? grey183 : white,
              border: Border.all(color: grey183, width: 1.0),
            ),
              child: R16Text(text: "안줄래요", textColor: hasConfirmedNoRating ? white : grey183),
            ),
          ),
          Container(
            alignment: Alignment.center,
            width: size.getSize(115), 
            height: size.getSize(40),
            decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: hasConfirmedRating ? green : white,
            border: Border.all(color: green, width: 1.0),
          ),
            child: R16Text(text: "확인", textColor: hasConfirmedRating ? white : grey183),
          )
        ],
      );
    });
  }
}