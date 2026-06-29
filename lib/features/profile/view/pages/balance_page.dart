import 'package:dealura/features/profile/model/transaction_model.dart';
import 'package:dealura/features/profile/model/wallet_model.dart';
import 'package:dealura/features/profile/repository/profile_repository_impl.dart';
import 'package:dealura/features/profile/view/pages/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class BalancePage extends StatefulWidget {
  const BalancePage({super.key});

  @override
  State<BalancePage> createState() => _BalancePageState();
}

class _BalancePageState extends State<BalancePage> {
  WalletModel? wallet;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  List<TransactionModel> transactions = [];
  List<TransactionModel> actions = [];
  List<TransactionModel> topups = [];

  Future<void> loadData() async {
    try {
      final results = await Future.wait([
        ProfileRepositoryImpl().getMyWallet(),
        ProfileRepositoryImpl().getMyWalletTransactions(),
      ]);

      wallet = results[0] as WalletModel;
      transactions = results[1] as List<TransactionModel>;

      actions = transactions.where((e) => e.kind == "purchase").toList();

      topups = transactions.where((e) => e.kind == "admin_topup").toList();

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      debugPrint(e.toString());
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(right: 16.0, left: 16.0, top: 64.0),
          child: Column(
            children: [
              Row(
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
                  SizedBox(width: 13),
                  const Text(
                    "balance",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                      fontFamily: "DM Serif Display",
                    ),
                  ),
                ],
              ),
              SizedBox(height: 26),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 28, vertical: 28),
                width: 361,
                height: 182,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Color(0xffE8A87C), width: 1.5),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Available Balance",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        fontFamily: "IBM Plex Sans",
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${formatBalance((wallet!.balance!))} SYP",
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.w400,
                            fontFamily: "IBM Plex Sans",
                          ),
                        ),
                        SvgPicture.asset(
                          'assets/images/wallet.svg',
                          width: 80,
                          height: 80,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: 26),
              DefaultTabController(
                length: 2,
                child: SizedBox(
                  height: 500,
                  child: Column(
                    children: [
                      const TabBar(
                        indicatorSize: TabBarIndicatorSize.tab,
                        indicatorColor: Color(0xffE8A87C),
                        indicatorWeight: 2,
                        labelColor: Colors.black,
                        unselectedLabelColor: Color(0xff8A8580),
                        labelStyle: TextStyle(
                          fontFamily: "IBM Plex Sans",
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                        tabs: [
                          Tab(text: "Transactions"),
                          Tab(text: "Transfers"),
                        ],
                      ),
                      Expanded(
                        child: TabBarView(
                          children: [
                            actions.isEmpty
                                ? emptyState("No transactions yet")
                                : ListView.separated(
                                    itemCount: actions.length,
                                    separatorBuilder: (_, _) =>
                                        const Divider(color: Color(0xffE5E2DC)),
                                    itemBuilder: (context, index) {
                                      final transaction = actions[index];

                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 12,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              transaction.description ?? '',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 14,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              "${formatBalance(transaction.amount ?? '0')} SYP",
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                            topups.isEmpty
                                ? emptyState("No transfers yet")
                                : ListView.separated(
                                    itemCount: topups.length,
                                    separatorBuilder: (_, _) =>
                                        const Divider(color: Color(0xffE5E2DC)),
                                    itemBuilder: (context, index) {
                                      final transaction = topups[index];

                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 12,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              transaction.description ?? '',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 14,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              "admin gave you ${formatBalance(transaction.amount ?? '0')} SYP",
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget emptyState(String message) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.receipt_long_outlined,
          size: 60,
          color: Color(0xffB5B0A8),
        ),
        const SizedBox(height: 16),
        Text(
          message,
          style: const TextStyle(
            fontSize: 16,
            fontFamily: "IBM Plex Sans",
            color: Color(0xff8A8580),
          ),
        ),
      ],
    ),
  );
}
