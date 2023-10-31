// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'invoices_bloc.dart';

abstract class InvoicesEvent extends Equatable {
  const InvoicesEvent();

  @override
  List<Object> get props => [];
}

class _InitInvoices extends InvoicesEvent {
  List<Invoice> invoices;
  _InitInvoices({
    required this.invoices,
  });

  @override
  List<Object> get props => [invoices];
}

class NewInvoice extends InvoicesEvent {
  int month;
  int year;
  double fixRate;
  double floatingNt;
  double floatingVT;
  NewInvoice({
    required this.month,
    required this.year,
    required this.fixRate,
    required this.floatingNt,
    required this.floatingVT,
  });

  @override
  List<Object> get props => [fixRate, floatingNt, floatingVT, month, year];
}

class UpdateInvoice extends InvoicesEvent {
  Invoice invoice;
  UpdateInvoice({
    required this.invoice,
  });

  @override
  List<Object> get props => [invoice];
}

class DeleteInvoice extends InvoicesEvent {
  Invoice invoice;
  DeleteInvoice({
    required this.invoice,
  });

  @override
  List<Object> get props => [invoice];
}
