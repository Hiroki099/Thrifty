import 'dart:io';

import 'package:dealura/features/auth/model/user_model.dart';
import 'package:dealura/features/home/model/item_model.dart';
import 'package:dealura/features/product/models/RatingModel.dart';
import 'package:dealura/features/product/models/bid_model.dart';
import 'package:dealura/features/product/models/report_model.dart';
import 'package:dealura/features/product/models/request_model.dart';
import 'package:dealura/features/profile/model/transaction_model.dart';
import 'package:dealura/features/profile/model/wallet_model.dart';

abstract class ProfileRepository {
  Future<UserModel> getMyProfile();
  Future<void> partialEditProfile({
    String? username,
    String? email,
    File? profileImage,
  });
  Future<UserModel> getUserProfile(int userId);
  Future<List<ItemModel>> getMyItems();
  Future<List<ItemModel>> getMyClaims();
  Future<List<ItemModel>> getMyRequests();
  Future<dynamic> deleteAccount();
  Future<void> logOut();
  Future<List<TransactionModel>> getMyWalletTransactions();
  Future<WalletModel> getMyWallet();
  Future<List<RequestModel>> getRecivedRequests();
  Future<Map<String, dynamic>> rejectRequest(int requestId);
  Future<Map<String, dynamic>> acceptRequest(int requestId);
  Future<List<RatingModel>> getMyGivenRatings();
  Future<List<RatingModel>> getMyReceivedRatings();
  Future<void> editRate(int? rateId, String? newComment, int? newRating);
  Future<void> deleteRate(int? rateId);
  Future<List<BidModel>> getMyBids();
  Future<List<ReportModel>> getMyReports();
}
