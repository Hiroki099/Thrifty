import 'package:dealura/features/forecast/model/currency_model.dart';
import 'package:dealura/features/forecast/repository/forecast_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ExchangePage extends StatefulWidget {
  const ExchangePage({super.key});

  @override
  State<ExchangePage> createState() => _ExchangePageState();
}

class _ExchangePageState extends State<ExchangePage>
    with SingleTickerProviderStateMixin {
  final ForecastRepository _repository = ForecastRepository();

  List<CurrencyModel> currencies = [];

  bool isLoading = true;
  String? errorMessage;

  late AnimationController _animationController;

  static const Color backgroundColor = Color(0xffFAF6F0);
  static const Color primaryColor = Color(0xffE8A87C);
  static const Color textColor = Color(0xff24211E);
  static const Color secondaryTextColor = Color(0xff8A8580);
  static const Color softColor = Color(0xffF3EDE4);
  static const Color borderColor = Color(0xffEFE9E2);

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _loadCurrencies();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadCurrencies() async {
    if (mounted) {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });
    }

    try {
      final result = await _repository.getForecast();

      if (!mounted) return;

      setState(() {
        currencies = result;
        isLoading = false;
      });

      _animationController.forward(from: 0);
    } catch (e) {
      debugPrint('CURRENCY ERROR: $e');

      if (!mounted) return;

      setState(() {
        isLoading = false;
        errorMessage = 'Unable to load exchange rates';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: RefreshIndicator(
          color: primaryColor,
          backgroundColor: Colors.white,
          onRefresh: _loadCurrencies,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 25, 16, 30),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    _buildHeader(),
                    const SizedBox(height: 28),

                    if (isLoading)
                      _buildLoading()
                    else if (errorMessage != null)
                      _buildError()
                    else
                      _buildContent(),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: SvgPicture.asset(
            'assets/images/go_back.svg',
            width: 20,
            height: 20,
          ),
        ),

        const SizedBox(width: 13),

        const Expanded(
          child: Text(
            'exchange',
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.w400,
              fontFamily: 'DM Serif Display',
              color: textColor,
            ),
          ),
        ),
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: isLoading ? null : _loadCurrencies,
            borderRadius: BorderRadius.circular(22),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Icon(
                Icons.refresh_rounded,
                size: 21,
                color: isLoading ? secondaryTextColor : textColor,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContent() {
    if (currencies.isEmpty) {
      return _buildEmpty();
    }

    final date = currencies.first.date;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeroCard(),

        const SizedBox(height: 25),

        Row(
          children: [
            const Text(
              'today\'s rates',
              style: TextStyle(
                fontFamily: 'IBM Plex Sans',
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),

            const Spacer(),

            if (date != null)
              Text(
                _formatDate(date),
                style: const TextStyle(
                  fontFamily: 'IBM Plex Sans',
                  fontSize: 11,
                  color: secondaryTextColor,
                ),
              ),
          ],
        ),

        const SizedBox(height: 12),

        ...List.generate(currencies.length, (index) {
          final currency = currencies[index];

          return _AnimatedCurrencyCard(
            animation: _animationController,
            index: index,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _buildCurrencyCard(currency),
            ),
          );
        }),

        const SizedBox(height: 10),

        _buildInfoCard(),
      ],
    );
  }

  Widget _buildHeroCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 21, 20, 20),
      decoration: BoxDecoration(
        color: textColor,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: primaryColor.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: const Center(
                  child: Text(
                    'SYP',
                    style: TextStyle(
                      fontFamily: 'IBM Plex Sans',
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: primaryColor,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 12),

              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Syrian Pound',
                      style: TextStyle(
                        fontFamily: 'IBM Plex Sans',
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Base currency',
                      style: TextStyle(
                        fontFamily: 'IBM Plex Sans',
                        fontSize: 11,
                        color: Color(0xffB5B0A8),
                      ),
                    ),
                  ],
                ),
              ),

              const Icon(
                Icons.swap_horiz_rounded,
                color: primaryColor,
                size: 24,
              ),
            ],
          ),

          const SizedBox(height: 20),

          const SizedBox(height: 4),

          const Text(
            'Compare today\'s exchange rates',
            style: TextStyle(
              fontFamily: 'IBM Plex Sans',
              fontSize: 12,
              color: Color(0xffB5B0A8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrencyCard(CurrencyModel currency) {
    final quote = currency.quote ?? '---';
    final rate = currency.rate ?? 0;

    final info = _currencyInfo(quote);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.025),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          // Currency icon
          Container(
            width: 47,
            height: 47,
            decoration: BoxDecoration(
              color: softColor,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Center(
              child: Text(
                info.symbol,
                style: const TextStyle(
                  fontFamily: 'IBM Plex Sans',
                  fontSize: 19,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
            ),
          ),

          const SizedBox(width: 12),

          // Currency name
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  info.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'IBM Plex Sans',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  quote,
                  style: const TextStyle(
                    fontFamily: 'IBM Plex Sans',
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                    color: secondaryTextColor,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 10),
          // Rate
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                _formatRate(1 / rate),
                style: const TextStyle(
                  fontFamily: 'IBM Plex Sans',
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 3),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: softColor,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            size: 19,
            color: secondaryTextColor,
          ),

          const SizedBox(width: 10),

          const Expanded(
            child: Text(
              'Exchange rates are provided for reference and may differ from the rate offered by banks or exchange offices.',
              style: TextStyle(
                fontFamily: 'IBM Plex Sans',
                fontSize: 11,
                height: 1.45,
                color: secondaryTextColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoading() {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 175,
          decoration: BoxDecoration(
            color: textColor,
            borderRadius: BorderRadius.circular(22),
          ),
        ),

        const SizedBox(height: 25),

        ...List.generate(
          5,
          (index) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Container(
              height: 76,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: borderColor),
              ),
            ),
          ),
        ),

        const SizedBox(height: 5),

        const CircularProgressIndicator(strokeWidth: 2, color: primaryColor),
      ],
    );
  }

  Widget _buildError() {
    return Padding(
      padding: const EdgeInsets.only(top: 100),
      child: Column(
        children: [
          Container(
            width: 78,
            height: 78,
            decoration: BoxDecoration(
              color: softColor,
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Icon(
              Icons.currency_exchange_rounded,
              size: 38,
              color: secondaryTextColor,
            ),
          ),

          const SizedBox(height: 18),

          const Text(
            'Something went wrong',
            style: TextStyle(
              fontFamily: 'IBM Plex Sans',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),

          const SizedBox(height: 7),
          const Text(
            'We couldn\'t load the latest exchange rates.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'IBM Plex Sans',
              fontSize: 13,
              color: secondaryTextColor,
            ),
          ),

          const SizedBox(height: 20),

          ElevatedButton(
            onPressed: _loadCurrencies,
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: textColor,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Try again',
              style: TextStyle(
                fontFamily: 'IBM Plex Sans',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmpty() {
    return Padding(
      padding: const EdgeInsets.only(top: 120),
      child: Column(
        children: [
          Container(
            width: 78,
            height: 78,
            decoration: BoxDecoration(
              color: softColor,
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Icon(
              Icons.currency_exchange_rounded,
              size: 38,
              color: secondaryTextColor,
            ),
          ),
          const SizedBox(height: 18),
          const Text(
            'No exchange rates available',
            style: TextStyle(
              fontFamily: 'IBM Plex Sans',
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  String _formatRate(double rate) {
    if (rate == 0) return '—';

    if (rate >= 1) {
      return rate.toStringAsFixed(2);
    }

    if (rate >= 0.01) {
      return rate.toStringAsFixed(4);
    }

    return rate.toStringAsFixed(6);
  }

  String _formatDate(String date) {
    final parsed = DateTime.tryParse(date);

    if (parsed == null) return date;

    return '${parsed.day.toString().padLeft(2, '0')}/'
        '${parsed.month.toString().padLeft(2, '0')}/'
        '${parsed.year}';
  }

  _CurrencyInfo _currencyInfo(String currency) {
    switch (currency) {
      case 'USD':
        return const _CurrencyInfo(name: 'US Dollar', symbol: '\$');

      case 'EUR':
        return const _CurrencyInfo(name: 'Euro', symbol: '€');

      case 'AED':
        return const _CurrencyInfo(name: 'UAE Dirham', symbol: 'د.إ');

      case 'TRY':
        return const _CurrencyInfo(name: 'Turkish Lira', symbol: '₺');

      case 'EGP':
        return const _CurrencyInfo(name: 'Egyptian Pound', symbol: '£');

      case 'SAR':
        return const _CurrencyInfo(name: 'Saudi Riyal', symbol: '﷼');

      default:
        return _CurrencyInfo(name: currency, symbol: currency);
    }
  }
}

class _CurrencyInfo {
  final String name;
  final String symbol;

  const _CurrencyInfo({required this.name, required this.symbol});
}

class _AnimatedCurrencyCard extends StatelessWidget {
  const _AnimatedCurrencyCard({
    required this.animation,
    required this.index,
    required this.child,
  });
  final Animation<double> animation;
  final int index;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final start = (index * 0.08).clamp(0.0, 0.7);
    final end = (start + 0.3).clamp(0.0, 1.0);

    final curvedAnimation = CurvedAnimation(
      parent: animation,
      curve: Interval(start, end, curve: Curves.easeOutCubic),
    );

    return AnimatedBuilder(
      animation: curvedAnimation,
      child: child,
      builder: (context, child) {
        return Opacity(
          opacity: curvedAnimation.value,
          child: Transform.translate(
            offset: Offset(0, 12 * (1 - curvedAnimation.value)),
            child: child,
          ),
        );
      },
    );
  }
}
