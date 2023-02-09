// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'invoice.g.dart';

@JsonSerializable(explicitToJson: true, anyMap: true)
@HiveType(typeId: 2)
class Invoice extends Equatable {
  @HiveField(0)
  String id;
  @HiveField(1)
  DateTime date;
  @HiveField(2)
  double fixRate;
  @HiveField(3)
  double floatingRateNT;
  @HiveField(4)
  double floatingRateVT;
  Invoice({
    required this.id,
    required this.date,
    required this.fixRate,
    required this.floatingRateNT,
    required this.floatingRateVT,
  });

  @override
  List<Object?> get props => [];

  factory Invoice.fromJson(Map<String, dynamic> json) =>
      _$InvoiceFromJson(json);
  Map<String, dynamic> toJson() => _$InvoiceToJson(this);

  Invoice copyWith({
    String? id,
    DateTime? date,
    double? fixRate,
    double? floatingRateNT,
    double? floatingRateVT,
  }) {
    return Invoice(
      id: id ?? this.id,
      date: date ?? this.date,
      fixRate: fixRate ?? this.fixRate,
      floatingRateNT: floatingRateNT ?? this.floatingRateNT,
      floatingRateVT: floatingRateVT ?? this.floatingRateVT,
    );
  }
}
