import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class YatraDetails extends StatelessWidget {
  final Map<String, dynamic> yatraData;

  const YatraDetails({required this.yatraData, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView(
        children: [
          Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Yatra ID: ${yatraData['yatraId']}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text('Number of Yatris: ${yatraData['numberofYatris']}'),
                  Text('Yatra Cost: ₹${yatraData['yatraCost']}'),
                  Text('Total Amount: ₹${yatraData['totalAmount']}'),
                  Text('Taxes: ₹${yatraData['taxes']}'),
                  Text('Paid Amount: ₹${yatraData['paidAmount']}'),
                  Text('Due Amount: ₹${yatraData['dueAmount']}'),
                  Text('Grand Total: ₹${yatraData['grandTotal']}'),
                  SizedBox(height: 8),
                  Text(
                    'Traveler Register: ${DateFormat.yMMMEd().add_jm().format((yatraData['travelerRegister'] as DateTime))}',
                  ),
                  SizedBox(height: 8),
                  Text('Primary Include: ${yatraData['primaryInclude']}'),
                  SizedBox(height: 8),
                  Text('Document IDs:'),
                  Wrap(
                    spacing: 8,
                    children: List<Widget>.generate(
                      (yatraData['docIds'] as List).length,
                      (index) => Chip(label: Text(yatraData['docIds'][index])),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
