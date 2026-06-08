import 'dart:io';

import 'package:dealura/features/auth/model/user_model.dart';
import 'package:dealura/features/home/model/item_model.dart';
import 'package:dealura/features/profile/model/transaction_model.dart';
import 'package:dealura/features/profile/model/wallet_model.dart';

abstract class ProfileRepository {
  Future<UserModel> getMyProfile();
  Future<void> editProfile({
    required String username,
    required String email,
    File? profileImage,
  });
  Future<UserModel> getUserProfile(int userId);
  Future<List<ItemModel>> getMyItems();
  Future<List<ItemModel>> getMyClaims();
  Future<dynamic> deleteAccount();
  Future<void> logOut();
  Future<List<TransactionModel>> getMyWalletTransactions();
  Future<WalletModel> getMyWallet();
}
