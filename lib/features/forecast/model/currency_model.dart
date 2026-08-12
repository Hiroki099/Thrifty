class CurrencyModel {
  final String? date;
  final String? base;
  final String? quote;
  final double? rate;

  const CurrencyModel({this.date, this.base, this.quote, this.rate});

  factory CurrencyModel.fromJson(Map<String, dynamic> json) {
    return CurrencyModel(
      date: json['date'] as String?,
      base: json['base'] as String?,
      quote: json['quote'] as String?,
      rate: (json['rate'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'date': date, 'base': base, 'quote': quote, 'rate': rate};
  }
}
