// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'invoices_bloc.dart';

abstract class InvoicesState extends Equatable {
  Map<String, String> invoices;
  List<String> months;
  List<List<String>> invoicesData;
  InvoicesState({
    required this.invoices,
    required this.months,
    required this.invoicesData,
  });

  @override
  List<Object> get props => [months, invoicesData];
}

class InvoicesInitial extends InvoicesState {
  InvoicesInitial({invoices, months, invoicesData})
      : super(invoices: invoices, invoicesData: invoicesData, months: months);
}
