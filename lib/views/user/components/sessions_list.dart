import 'dart:async';
import 'package:flutter/material.dart';
import '../../../controllers/session_controller.dart';
import '../../../models/session.dart';

class SessionsList extends StatefulWidget {
  final String role;
  final String userId;
  final String name;
  const SessionsList({super.key, required this.role, required this.userId, required this.name});

  @override
  _SessionsListState createState() => _SessionsListState();
}

class _SessionsListState extends State<SessionsList> {
  late StreamController<List<Session>> _sessionsController;

  late List<Session> allSessions;
  List<Session> selectedSessions = [];
  late String sessionName;

  @override
  void initState() {
    super.initState();
    _sessionsController = StreamController<List<Session>>.broadcast();
    fetchActiveSessions().then((sessions) {
      allSessions = sessions;
      _updateUsersList();
    });

  }

  @override
  void dispose() {
    _sessionsController.close();
    super.dispose();
  }

  void _updateUsersList() {
    List<Session> activeSessions = allSessions.where((session) => session.isActive).toList();
    _sessionsController.add(activeSessions);
  }

  Session? selectedSession;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Choose a session to join'),
      content: SingleChildScrollView(
        child: Column(
          children: [
            const Text(
                'You are accepted to be a part of this experience. You can join and participate in any sessions from the list below.'),
            const SizedBox(height: 20),
            Row(
              children: [
                StreamBuilder<List<Session>>(
                  stream: _sessionsController.stream,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('No sessions found.'));
                    }

                    List<Session> activeSessions = snapshot.data!;


                    return Expanded(
                      child: SizedBox(
                        width: 300,
                        child: Column(
                          children: [
                            const Text('Sessions available:'),
                            /*SizedBox(
                              height: 400,
                              child: ListView.builder(
                                itemCount: sessionsForSelectedEvent.length,
                                itemBuilder: (context, index) {
                                  final session = sessionsForSelectedEvent[index];
                                  bool isSelected = selectedSession == session;

                                  String myString = session.name;

                                  return Card(
                                    elevation: 3,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    child: ListTile(
                                      title: Text("Session $lastCharacter"),
                                      onTap: () {
                                        setState(() {
                                          if (widget.role == "Talent") {
                                            if (session.slotTal != 0) {
                                              if (isSelected) {
                                                selectedSession = null;
                                              } else {
                                                selectedSession = session;
                                              }
                                            } else {
                                              const snackBar = SnackBar(
                                                content: Text('Sorry! but the session is full'),
                                              );
                                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                            }
                                          } else if (widget.role == "Entrepreneur") {
                                            if (session.slotEnt != 0) {
                                              if (isSelected) {
                                                selectedSession = null;
                                              } else {
                                                selectedSession = session;
                                              }
                                            } else {
                                              const snackBar = SnackBar(
                                                content: Text('Sorry! but the session is full'),
                                              );
                                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                            }
                                          }

                                        });
                                      },
                                      tileColor: isSelected
                                          ? Colors.blue.withOpacity(0.1)
                                          : null,
                                      leading: isSelected
                                          ? const Icon(Icons.check_circle,
                                          color: chartColor1)
                                          : null,
                                    ),
                                  );
                                },
                              ),
                            ),*/
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('CLOSE'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          onPressed: selectedSession != null
              ? () async {
            bool userExists = await checkUserInSessions(widget.userId);
            if (!userExists) {
              Future.delayed(const Duration(seconds: 1), () async {
                addUserToSession(selectedSession!.name, widget.userId);
                Navigator.of(context).pop();
              });
            } else {
              Navigator.of(context).pop();
              const snackBar = SnackBar(
                content: Text('You are already registered in a session, wait for the admin to accept or refuse your request. Thank you for you patience'),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }
          }
              : null,
          child: const Text('SAVE'),
        ),
      ],
    );
  }
}
