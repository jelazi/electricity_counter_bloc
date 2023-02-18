//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:f_logs/model/flog/flog.dart';

import '../models/invoice.dart';
import '../models/user.dart';
import 'package:firedart/firedart.dart';

class FirebaseProvider {
  var userCollection;
  var invoicesCollection;

  FirebaseProvider() {
    userCollection = Firestore.instance.collection('users');
    invoicesCollection = Firestore.instance.collection('invoices');
  }

  Future<void> addUserToFirebase(User user) async {
    try {
      await userCollection.document(user.id).update(user.toJson());
    } catch (e) {
      FLog.error(text: '$e');
    }
  }

  Future<void> updateUser(User user) async {
    try {
      await userCollection.document(user.id).update(user.toJson());
    } catch (e) {
      FLog.error(text: '$e');
    }
  }

  Future deleteUser(User user) async {
    try {
      var snapshot = await userCollection.document(user.id).get();
      if (snapshot != null) {
        await userCollection.document(user.id).delete();
      }
    } catch (e) {
      FLog.error(text: '$e');
    }
  }

  Future<List<User>> getAllUser() async {
    List<User> listUsers = [];
    try {
      var querySnapshot = await userCollection.get();
      for (var doc in querySnapshot) {
        listUsers.add(User.fromJson(doc.map));
      }
    } catch (e) {
      FLog.error(text: '$e');
    }
    return listUsers;
  }

  Future<void> addInvoiceToFirebase(Invoice invoice) async {
    try {
      await invoicesCollection.document(invoice.id).update(invoice.toJson());
    } catch (e) {
      FLog.error(text: '$e');
    }
  }

  Future<void> updateInvoice(Invoice invoice) async {
    try {
      await invoicesCollection.document(invoice.id).update(invoice.toJson());
    } catch (e) {
      FLog.error(text: '$e');
    }
  }

  Future deleteInvoice(Invoice invoice) async {
    try {
      var snapshot = await invoicesCollection.document(invoice.id).get();
      if (snapshot != null) {
        await invoicesCollection.document(invoice.id).delete();
      }
    } catch (e) {
      FLog.error(text: '$e');
    }
  }

  Future<List<Invoice>> getAllInvoice() async {
    List<Invoice> listInvoices = [];
    try {
      var querySnapshot = await invoicesCollection.get();
      for (var doc in querySnapshot) {
        listInvoices.add(Invoice.fromJson(doc.map));
      }
    } catch (e) {
      FLog.error(text: '$e');
    }
    return listInvoices;
  }
}
