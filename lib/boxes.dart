import 'package:hive/hive.dart';
import 'package:hive_sample_transaction/model/transaction.dart';

class Boxes {
  static Box<Transaction> getTransactions() =>
      Hive.box<Transaction>('transactions');
}
