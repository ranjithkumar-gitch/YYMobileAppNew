import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:yogayatra/loginscrenns/loginscreen.dart';

class Onboardingscreens extends StatefulWidget {
  const Onboardingscreens({Key? key}) : super(key: key);

  @override
  OnboardingscreensState createState() => OnboardingscreensState();
}

class OnboardingscreensState extends State<Onboardingscreens> {
  final introKey = GlobalKey<IntroductionScreenState>();
  void _onIntroEnd(context) {}

  Widget _column(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            'YogaYatra',
            style: GoogleFonts.poppins(
                color: Colors.black, fontSize: 20, fontWeight: FontWeight.w500),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            'Discover the power within.',
            style: GoogleFonts.poppins(
                color: Colors.black, fontSize: 16, fontWeight: FontWeight.w400),
          ),
        ],
      ),
    );
  }

  Widget _buildImage(String imageUrl,
      [double width = 360, double height = 440]) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          top: 100.0,
          child: Image.network(
            imageUrl,
            width: width,
            height: height,
            fit: BoxFit.cover,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 19.0);
    const pageDecoration = PageDecoration(
      titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
      bodyTextStyle: bodyStyle,
      bodyPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: Colors.white,
      imagePadding: EdgeInsets.zero,
    );

    return Stack(
      children: [
        IntroductionScreen(
          key: introKey,
          globalBackgroundColor: Colors.white,
          allowImplicitScrolling: true,
          autoScrollDuration: 3000,
          infiniteAutoScroll: true,
          pages: [
            PageViewModel(
              body: '',
              title: '',
              image: _buildImage(
                'https://www.yoga-yatra.com/assets/images/bigstock-Girl-In-Yoga-Pose-4887329.19695530_std.jpg',
              ),
              footer: _column(context),
              decoration: pageDecoration,
            ),
            PageViewModel(
              title: "",
              body: "",
              footer: _column(context),
              image: _buildImage(
                  'https://cdn.pixabay.com/photo/2019/10/15/16/11/spiritualism-4552237_640.jpg'),
              decoration: pageDecoration,
            ),
            PageViewModel(
              title: "",
              body: "",
              footer: _column(context),
              image: _buildImage(
                  'https://scontent.fhyd14-1.fna.fbcdn.net/v/t1.6435-9/52487954_2151294488517767_2969974407784562688_n.jpg?_nc_cat=103&ccb=1-7&_nc_sid=c2f564&_nc_ohc=YhDgswREfesAX9fu2dP&_nc_ht=scontent.fhyd14-1.fna&oh=00_AfDJxYVmtPEk3bOTEXnYj-BOdEdotCeSTAU3xjoP6aPiAQ&oe=65E818AA'),
              decoration: pageDecoration,
            ),
            PageViewModel(
                title: "",
                body: "",
                footer: _column(context),
                image: _buildImage(
                    'https://cdn.pixabay.com/photo/2019/10/15/16/11/spiritualism-4552237_640.jpg')),
          ],
          onDone: () => _onIntroEnd(context),
          onSkip: () => _onIntroEnd(context),
          showSkipButton: false,
          showDoneButton: false,
          showNextButton: false,
          skipOrBackFlex: 0,
          nextFlex: 0,
          showBackButton: false,
          skip: const Text('Skip',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Colors.black,
              )),
          next: const Icon(
            Icons.arrow_forward,
            size: 30,
            color: Colors.black,
          ),
          done: const Text('Done',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Colors.black,
              )),
          curve: Curves.fastLinearToSlowEaseIn,
          controlsMargin: const EdgeInsets.all(16),
          controlsPadding: kIsWeb
              ? const EdgeInsets.all(12.0)
              : const EdgeInsets.only(bottom: 70),
          dotsDecorator: DotsDecorator(
            size: Size(10, 10),
            color: Colors.grey.shade400,
            activeSize: Size(22.0, 10.0),
            activeColor: HexColor('#018a3c'),
            activeShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(25.0)),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: SizedBox(
              height: 60,
              width: 190,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LoginScreen()));
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  backgroundColor: HexColor('#018a3c'),
                  elevation: 5,
                ),
                child: Text(
                  'Get Started',
                  style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}







// HexColor('#018a3c')