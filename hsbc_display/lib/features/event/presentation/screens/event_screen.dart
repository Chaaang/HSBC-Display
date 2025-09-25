import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../auth/presentation/components/my_button.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../shared/components/loading_screen.dart';
import '../../../shared/components/snack_bar.dart';
import '../../../signatures/presentation/screens/signature_screen.dart';
import '../cubit/event_cubit.dart';
import '../cubit/event_state.dart';

class EventScreen extends StatefulWidget {
  const EventScreen({super.key});

  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  String? _selectedSignId;
  void getEventList() {
    final eventCubit = context.read<EventCubit>();
    final authCubit = context.read<AuthCubit>();
    final uuid = authCubit.currentUser;
    if (uuid != null) {
      eventCubit.getEventList(uuid);
    }
  }

  @override
  void initState() {
    getEventList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<EventCubit, EventState>(
          builder: (context, state) {
            if (state is EventReady) {
              //return HomeScreen();
              return SignatureScreen();
            }
            if (state is EventLoading) {
              return LoadingScreen();
            } else if (state is EventLoaded) {
              final events = state.events;

              return Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Container(
                      width: 350,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 12,
                            spreadRadius: 2,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Title
                          Text(
                            'Select a Signature',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                              letterSpacing: 1.1,
                              shadows: [
                                Shadow(
                                  blurRadius: 4,
                                  color: Colors.black26,
                                  offset: const Offset(2, 2),
                                ),
                              ],
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20),

                          // Dropdown
                          SizedBox(
                            width: 300,
                            child: DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.grey[100],
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              hint: const Text("Choose a signature"),
                              value: _selectedSignId,
                              items:
                                  events.map((event) {
                                    return DropdownMenuItem<String>(
                                      value: event.id,
                                      child: Text(
                                        event.title1,
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    );
                                  }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedSignId = value;

                                  final selectedEvent = events.firstWhere(
                                    (e) => e.id == value,
                                  );
                                  context.read<EventCubit>().selectEvent(
                                    selectedEvent,
                                  );
                                });
                              },
                            ),
                          ),

                          const SizedBox(height: 24),

                          MyButton(
                            text: 'Continue',
                            onTap: () {
                              if (_selectedSignId != null) {
                                final event = context.read<EventCubit>();

                                event.navigate();
                              } else {
                                showAppSnackBar(
                                  context,
                                  'Please select Event',
                                  type: SnackBarType.info,
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            } else if (state is EventError) {
              return Center(
                child: Text(
                  "Error: ${state.error}",
                  style: const TextStyle(color: Colors.red, fontSize: 16),
                ),
              );
            } else {
              return Center(child: const Text("No data available"));
            }
          },
        ),
      ),
    );
  }
}
