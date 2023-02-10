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
  Invoice invoice;
  NewInvoice({
    required this.invoice,
  });

  @override
  List<Object> get props => [invoice];
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
