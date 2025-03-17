import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:legallens/components/document_container.dart';
import 'package:legallens/pages/contracts_page.dart';
import 'package:legallens/pages/corporate_page.dart';
import 'package:legallens/pages/courtdocs_page.dart';
import 'package:legallens/pages/family_page.dart';
import 'package:legallens/pages/finance_page.dart';
import 'package:legallens/pages/intellectual_page.dart';
import 'package:legallens/pages/other_page.dart';
import 'package:legallens/pages/realestate_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Future<void> logoutUser() async {
    try {
      await FirebaseAuth.instance.signOut();
    } on FirebaseAuthException catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Padding(
          padding: EdgeInsets.only(left: size.width * 0.02),
          child: Text('LegalLens'),
        ),
        titleTextStyle: TextStyle(
            fontFamily: 'Lexend',
            color: Theme.of(context).colorScheme.onPrimary,
            fontSize: size.height * 0.03),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: size.height * 0.03),
            child: Builder(
              builder: (context) {
                return IconButton(
                  icon: Icon(Icons.menu),
                  color: Theme.of(context).colorScheme.onPrimary,
                  iconSize: size.height * 0.03,
                  onPressed: () {
                    Scaffold.of(context).openEndDrawer();
                  },
                );
              },
            ),
          )
        ],
      ),
      endDrawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(child: Icon(Icons.abc)),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () async {
                await logoutUser();
              },
            )
          ],
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Container(
        padding: EdgeInsets.all(20),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
          children: [
            DocumentContainer(
                path: 'assets/icons/contract.png',
                text: 'Contracts',
                page: ContractsPage()),
            DocumentContainer(
                path: 'assets/icons/court.png',
                text: 'Court Docs',
                page: CourtdocsPage()),
            DocumentContainer(
                path: 'assets/icons/intellectual.png',
                text: 'Intellectual',
                page: IntellectualPage()),
            DocumentContainer(
                path: 'assets/icons/finance.png',
                text: 'Finance',
                page: FinancePage()),
            DocumentContainer(
                path: 'assets/icons/corporate.png',
                text: 'Corporate',
                page: CorporatePage()),
            DocumentContainer(
                path: 'assets/icons/family.png',
                text: 'Family',
                page: FamilyPage()),
            DocumentContainer(
                path: 'assets/icons/real_estate.png',
                text: 'Real Estate',
                page: RealestatePage()),
            DocumentContainer(
                path: 'assets/icons/other.png',
                text: 'Other',
                page: OtherPage()),
          ],
        ),
      ),
    );
  }
}
