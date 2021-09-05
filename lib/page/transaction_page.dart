import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive_sample_transaction/boxes.dart';
import 'package:hive_sample_transaction/model/transaction.dart';
// import 'package:hive_database_example/widget/transaction_dialog.dart';
// import 'package:intl/intl.dart';

class TransactionPage extends StatefulWidget {
  @override
  _TransactionPageState createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  @override
  void dispose() {
    Hive.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('Hive Expense Tracker'),
          centerTitle: true,
        ),
        body: ValueListenableBuilder<Box<Transaction>>(
          valueListenable: Boxes.getTransactions().listenable(),
          builder: (context, box, _) {
            final transactions = box.values.toList().cast<Transaction>();

            return buildContent(transactions);
          },
        ),
        // floatingActionButton: FloatingActionButton(
        //   child: Icon(Icons.add),
        //   onPressed: () => showDialog(
        //     context: context,
        //     builder: (context) => TransactionDialog(
        //       onClickedDone: addTransaction,
        //     ),
        //   ),
        // ),
      );

  Widget buildContent(List<Transaction> transactions) {
    if (transactions.isEmpty) {
      return Center(
        child: Text(
          'No expenses yet!',
          style: TextStyle(fontSize: 24),
        ),
      );
    }
    return Column(
      children: [
        SizedBox(height: 24),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.all(8),
            itemCount: transactions.length,
            itemBuilder: (BuildContext context, int index) {
              final transaction = transactions[index];

              return buildTransaction(context, transaction);
            },
          ),
        ),
      ],
    );
  }
}

Widget buildTransaction(
  BuildContext context,
  Transaction transaction,
) {
  final age = transaction.age.toStringAsFixed(2);

  return Card(
    color: Colors.white,
    child: ExpansionTile(
      tilePadding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      title: Text(
        transaction.name,
        maxLines: 2,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
      subtitle: Text(age),
      // children: [
      //   buildButtons(context, transaction),
      // ],
    ),
  );
}

// Widget buildButtons(BuildContext context, Transaction transaction) => Row(
//   children: [
//     Expanded(
//       child: TextButton.icon(
//         label: Text('Edit'),
//         icon: Icon(Icons.edit),
//         onPressed: () => Navigator.of(context).push(
//           MaterialPageRoute(
//             builder: (context) => TransactionDialog(
//               transaction: transaction,
//               onClickedDone: (name, amount, isExpense) =>
//                   editTransaction(transaction, name, amount, isExpense),
//             ),
//           ),
//         ),
//       ),
//     ),
//     Expanded(
//       child: TextButton.icon(
//         label: Text('Delete'),
//         icon: Icon(Icons.delete),
//         onPressed: () => deleteTransaction(transaction),
//       ),
//     )
//   ],
// );

Future addTransaction(String name, int age) async {
  final transaction = Transaction()
    ..name = name
    ..age = age;

  final box = Boxes.getTransactions();
  box.add(transaction);
  //box.put('mykey', transaction);

  // final mybox = Boxes.getTransactions();
  // final myTransaction = mybox.get('key');
  // mybox.values;
  // mybox.keys;
}

void editTransaction(
  Transaction transaction,
  String name,
  int age,
) {
  transaction.name = name;
  transaction.age = age;

  // final box = Boxes.getTransactions();
  // box.put(transaction.key, transaction);

  transaction.save();
}

void deleteTransaction(Transaction transaction) {
  // final box = Boxes.getTransactions();
  // box.delete(transaction.key);

  transaction.delete();
  //setState(() => transactions.remove(transaction));
}
