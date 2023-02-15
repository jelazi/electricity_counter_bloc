// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'entry.dart';

part 'measure.g.dart';

@JsonSerializable(explicitToJson: true, anyMap: true)
class Measure extends Equatable {
  DateTime date;
  List<Entry> entries;
  Measure({
    required this.date,
    required this.entries,
  });

  factory Measure.fromJson(Map<String, dynamic> json) =>
      _$MeasureFromJson(json);
  Map<String, dynamic> toJson() => _$MeasureToJson(this);

  @override
  List<Object?> get props => [date, entries];

  Measure copyWith({
    DateTime? date,
    List<Entry>? entries,
  }) {
    return Measure(
      date: date ?? this.date,
      entries: entries ?? this.entries,
    );
  }
}
