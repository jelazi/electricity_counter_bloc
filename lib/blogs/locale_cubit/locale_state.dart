part of 'locale_cubit.dart';

abstract class LocaleState {
  final Locale locale;
  LocaleState(this.locale);
}

class SelectedLocale extends LocaleState {
  SelectedLocale(Locale locale) : super(locale);
}
