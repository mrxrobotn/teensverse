import '../../../views/admin/components/events_page.dart';
import '../../../views/admin/components/sessions_page.dart';

import '/components/appbar.dart';
import '/components/drawer.dart';
import '/views/admin/components/requests_list.dart';
import '/views/admin/components/users_list.dart';
import 'package:flutter/material.dart';
import '../../responsive_layout.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int currentIndex = 1;
  late Widget currentWidget;

  @override
  void initState() {
    super.initState();
    currentWidget = const SingleChildScrollView(
      child: UsersList(),
    );
  }

  void openRequests() {
    setState(() {
      currentWidget = const SingleChildScrollView(
        child: RequestsList(),
      );
    });
  }

  void openUsers() {
    setState(() {
      currentWidget = const SingleChildScrollView(
        child: UsersList(),
      );
    });
  }

  void openEvents() {
    setState(() {
      currentWidget = const SingleChildScrollView(
        child: EventsPage(),
      );
    });
  }

  void openSessions() {
    setState(() {
      currentWidget = const SingleChildScrollView(
        child: SessionsPage(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return SelectionArea(
      child: ResponsiveLayout(
          tiny: Scaffold(
            appBar: const PreferredSize(
              preferredSize: Size(double.infinity, 80),
              child: MyAppBar(),
            ),
            body: Expanded(child: currentWidget),
            drawer: MyDrawer(displayRequests: openRequests, displayUsers: openUsers, displaySessions: openSessions, displayEvents: openEvents),
          ),
          phone: Scaffold(
            appBar: const PreferredSize(
              preferredSize: Size(double.infinity, 80),
              child: MyAppBar(),
            ),
            body: Expanded(child: currentWidget),
            drawer:
            MyDrawer(displayRequests: openRequests, displayUsers: openUsers, displaySessions: openSessions, displayEvents: openEvents),
          ),
          tablet: Scaffold(
            appBar: const PreferredSize(
              preferredSize: Size(double.infinity, 80),
              child: MyAppBar(),
            ),
            body: Expanded(child: currentWidget),
            drawer:
            MyDrawer(displayRequests: openRequests, displayUsers: openUsers, displaySessions: openSessions, displayEvents: openEvents),
          ),
          largeTablet: Scaffold(
            body: Row(
              children: [
                MyDrawer(displayRequests: openRequests, displayUsers: openUsers, displaySessions: openSessions, displayEvents: openEvents),
                Expanded(child: currentWidget)
              ],
            ),
            drawer:
            MyDrawer(displayRequests: openRequests, displayUsers: openUsers, displaySessions: openSessions, displayEvents: openEvents),
          ),
          computer: Scaffold(
            body: Row(
              children: [
                MyDrawer(displayRequests: openRequests, displayUsers: openUsers, displaySessions: openSessions, displayEvents: openEvents),
                Expanded(child: currentWidget)
              ],
            ),
            drawer:
            MyDrawer(displayRequests: openRequests, displayUsers: openUsers, displaySessions: openSessions, displayEvents: openEvents),
          ),
      )
    );
  }
}
