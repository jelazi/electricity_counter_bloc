// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'invoices_bloc.dart';

abstract class InvoicesEvent extends Equatable {
  const InvoicesEvent();

  @override
  List<Object> get props => [];
}

class _InitInvoices extends InvoicesEvent {
  final List<Invoice> invoices;
  const _InitInvoices({
    required this.invoices,
  });

  @override
  List<Object> get props => [invoices];
}

class NewInvoice extends InvoicesEvent {
  final int month;
  final int year;
  final double fixRate;
  final double floatingNt;
  final double floatingVT;
  const NewInvoice({
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
  final Invoice invoice;
  const UpdateInvoice({
    required this.invoice,
  });

  @override
  List<Object> get props => [invoice];
}

class DeleteInvoice extends InvoicesEvent {
  final Invoice invoice;
  const DeleteInvoice({
    required this.invoice,
  });

  @override
  List<Object> get props => [invoice];
}
