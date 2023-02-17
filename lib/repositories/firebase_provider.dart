import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:f_logs/model/flog/flog.dart';

import '../models/invoice.dart';
import '../models/user.dart';

class FirebaseProvider {
  FirebaseFirestore inst = FirebaseFirestore.instance;
  CollectionReference<Map<String, dynamic>> userCollection =
      FirebaseFirestore.instance.collection('users');
  CollectionReference<Map<String, dynamic>> invoicesCollection =
      FirebaseFirestore.instance.collection('invoices');

  FirebaseProvider() {
    inst.settings = const Settings(
      persistenceEnabled: true,
      cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
    );
    userCollection = inst.collection('users');
    invoicesCollection = inst.collection('invoices');
  }

  Future<void> addUserToFirebase(User user) async {
    try {
      var snapshot = await userCollection.doc(user.name).get();
      if (snapshot.exists) {
        await updateUser(user);
      } else {
        await userCollection.doc(user.name).set(user.toJson());
      }
    } catch (e) {
      FLog.error(text: '$e');
    }
  }

  Future<void> updateUser(User user) async {
    try {
      await userCollection.doc(user.name).update(user.toJson());
    } catch (e) {
      FLog.error(text: '$e');
    }
  }

  Future deleteUser(User user) async {
    try {
      var snapshot = await userCollection.doc(user.name).get();
      if (snapshot.exists) {
        await userCollection.doc(user.name).delete();
      }
    } catch (e) {
      FLog.error(text: '$e');
    }
  }

  Future<List<User>> getAllUser() async {
    List<User> listUsers = [];
    try {
      var querySnapshot = await userCollection.get();
      for (var doc in querySnapshot.docs) {
        listUsers.add(User.fromJson(doc.data()));
      }
    } catch (e) {
      FLog.error(text: '$e');
    }
    return listUsers;
  }

  Future<void> addInvoiceToFirebase(Invoice invoice) async {
    try {
      var snapshot = await invoicesCollection.doc(invoice.id).get();
      if (snapshot.exists) {
        await updateInvoice(invoice);
      } else {
        await invoicesCollection.doc(invoice.id).set(invoice.toJson());
      }
    } catch (e) {
      FLog.error(text: '$e');
    }
  }

  Future<void> updateInvoice(Invoice invoice) async {
    try {
      await invoicesCollection.doc(invoice.id).update(invoice.toJson());
    } catch (e) {
      FLog.error(text: '$e');
    }
  }

  Future deleteInvoice(Invoice invoice) async {
    try {
      var snapshot = await invoicesCollection.doc(invoice.id).get();
      if (snapshot.exists) {
        await invoicesCollection.doc(invoice.id).delete();
      }
    } catch (e) {
      FLog.error(text: '$e');
    }
  }

  Future<List<Invoice>> getAllInvoice() async {
    List<Invoice> listInvoices = [];
    try {
      var querySnapshot = await invoicesCollection.get();
      for (var doc in querySnapshot.docs) {
        listInvoices.add(Invoice.fromJson(doc.data()));
      }
    } catch (e) {
      FLog.error(text: '$e');
    }
    return listInvoices;
  }
}
