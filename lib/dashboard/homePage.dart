import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:motion_tab_bar_v2/motion-tab-bar.dart';
import 'package:yogayatra/dashboard/advst_screen.dart';
import 'package:yogayatra/dashboard/allyatraslist.dart';
import 'package:yogayatra/dashboard/myyatraslist.dart';
import 'package:yogayatra/dashboard/notificationPage.dart';
import 'package:yogayatra/sharedpreferences/sharedpreferances.dart';
import 'package:yogayatra/sidemenu/sidemenusScreen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  late TabController _tabController;

  late final String firstName;
  late final String lastName;
  late final String profilePic;
  late final String creditNote;
  late final String mobileNumber;
  late final String gender;
  late final String userId;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    firstName = SharedPrefServices.getFirstName() ?? '';
    lastName = SharedPrefServices.getLastName() ?? '';
    profilePic = SharedPrefServices.getProfilePic() ?? '';
    creditNote = SharedPrefServices.getCreditNote() ?? '0.00';
    mobileNumber = SharedPrefServices.getMobileNumber() ?? '';
    gender = SharedPrefServices.getGender() ?? '';
    userId = SharedPrefServices.getUserId() ?? '';
  }

  void _showCreditDialog() {
    double credit =
        double.tryParse(creditNote.isNotEmpty ? creditNote : '0.00') ?? 0.00;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Your Wallet Amount',
            style:
                GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          content: Text(
            'Your wallet balance is ₹${credit.toStringAsFixed(2)}',
            style: GoogleFonts.poppins(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Close', style: GoogleFonts.poppins(fontSize: 16)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    String firstLetter = firstName.isNotEmpty ? firstName[0].toUpperCase() : '';

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.green,
        leading: Padding(
          padding: const EdgeInsets.fromLTRB(10, 8, 8, 8),
          child: GestureDetector(
            onTap: () => scaffoldKey.currentState?.openDrawer(),
            child: profilePic.isNotEmpty
                ? CircleAvatar(
                    radius: 35,
                    backgroundColor: Colors.white,
                    backgroundImage: NetworkImage(profilePic),
                  )
                : CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    child: Text(
                      firstLetter,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
          ),
        ),
        title: Text(
          'YogaYatra',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NotificationPage()),
            ),
            icon:
                const Icon(Icons.notifications, color: Colors.white, size: 25),
          ),
          IconButton(
            onPressed: _showCreditDialog,
            icon: const Icon(Icons.credit_card, color: Colors.white, size: 25),
          ),
        ],
      ),
      drawer: const SideMenuScreen(),
      body: TabBarView(
        controller: _tabController,
        children: [
          const MyYatrasListScreen(),
          AllYatrasList(),
          const AdvstScreen(),
        ],
      ),
      bottomNavigationBar: MotionTabBar(
        initialSelectedTab: "My Yatras",
        labels: const ["My Yatras", "All Yatras", "Advst"],
        icons: const [Icons.temple_hindu, Icons.temple_hindu, Icons.campaign],
        tabSize: 50,
        tabBarHeight: 60,
        textStyle: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w500,
        ),
        tabIconColor: Colors.grey,
        tabSelectedColor: Colors.green,
        tabIconSize: 28,
        tabBarColor: Colors.white,
        onTabItemSelected: (int index) {
          setState(() => _tabController.index = index);
        },
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
