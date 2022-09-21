import 'package:flutter/material.dart';

import '../widgets/custom_elevated_button.dart';
import 'add_user_screen.dart';
import 'pending_payments_screen.dart';
import 'recieved_payments_screen.dart';
import 'view_user_screen.dart';

class DailyCollectionHomeScreen extends StatelessWidget {
  const DailyCollectionHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent.shade700,
        centerTitle: true,
        title: const Text('Daily Collection'),
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomElevatedButton(
              buttonName: 'Add User',
              voidCallback: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddUserScreen(),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            CustomElevatedButton(
              buttonName: 'View Users',
              voidCallback: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ViewUserScreen(),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            CustomElevatedButton(
              buttonName: 'Received Payments',
              voidCallback: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ReceivedPaymentsScreen(),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            CustomElevatedButton(
              buttonName: 'Pending Payments',
              voidCallback: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PendingPaymentsScreen(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
