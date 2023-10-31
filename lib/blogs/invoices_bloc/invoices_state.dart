// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'invoices_bloc.dart';

class InvoicesState extends Equatable {
  final Map<String, String> invoices;

  final List<List<String>> invoicesData;
  const InvoicesState({
    required this.invoices,
    required this.invoicesData,
  });

  @override
  List<Object> get props => [invoices, invoicesData];

  InvoicesState copyWith({
    Map<String, String>? invoices,
    List<List<String>>? invoicesData,
  }) {
    return InvoicesState(
      invoices: invoices ?? this.invoices,
      invoicesData: invoicesData ?? this.invoicesData,
    );
  }
}

class InvoicesInitial extends InvoicesState {
  const InvoicesInitial({required super.invoices, required super.invoicesData});
}
