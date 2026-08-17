import 'dart:io';

import 'package:dealura/core/services/notification_services.dart';
import 'package:dealura/core/utls/api_service.dart';
import 'package:dealura/core/utls/save_token.dart';
import 'package:dealura/features/auth/model/user_model.dart';
import 'package:dealura/features/home/model/item_model.dart';
import 'package:dealura/features/product/models/RatingModel.dart';
import 'package:dealura/features/product/models/bid_model.dart';
import 'package:dealura/features/product/models/report_model.dart';
import 'package:dealura/features/product/models/request_model.dart';
import 'package:dealura/features/profile/model/transaction_model.dart';
import 'package:dealura/features/profile/model/wallet_model.dart';
import 'package:dealura/features/profile/repository/profile_repository.dart';
import 'package:dio/dio.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  @override
  Future<UserModel> getMyProfile() async {
    final data = await ApiService().get(endpoint: 'users/myprofile/');

    return UserModel.fromJson(data);
  }

  @override
  Future<UserModel> getUserProfile(int userId) async {
    UserModel user = await ApiService()
        .get(endpoint: 'users/retrieve/$userId/')
        .then((data) => UserModel.fromJson(data));

    return user;
  }

  @override
  Future<List<ItemModel>> getMyItems() async {
    List<ItemModel> items = await ApiService()
        .get(endpoint: 'items/my-items/')
        .then(
          (data) => (data as List).map((e) => ItemModel.fromJson(e)).toList(),
        );

    return items;
  }

  @override
  Future<List<ItemModel>> getMyClaims() async {
    List<ItemModel> items = await ApiService()
        .get(endpoint: 'items/my-claims/')
        .then(
          (data) => (data as List).map((e) => ItemModel.fromJson(e)).toList(),
        );

    return items;
  }

  @override
  Future<dynamic> deleteAccount() async {
    try {
      dynamic response = await ApiService().delete('users/delete/');
      await clearTokens();
      print(response.toString());
      return response;
    } catch (e) {
      print(e);
      return Future.error(e);
    }
  }

  @override
  Future<void> logOut() async {
    try {
      await NotificationService.instance.disconnectStream();
    } catch (e) {
      print('Logout Stream error: $e');
    }

    await clearTokens();
  }

  @override
  Future<void> partialEditProfile({
    String? username,
    String? email,
    File? profileImage,
  }) async {
    try {
      final formData = FormData.fromMap({
        'username': ?username,
        'email': ?email,
        if (profileImage != null)
          'profile_picture': await MultipartFile.fromFile(
            profileImage.path,
            filename: profileImage.path.split('/').last,
          ),
      });

      await ApiService().patch('users/myprofile/', formData, isMultipart: true);
    } catch (e) {
      return Future.error(e);
    }
  }

  @override
  Future<WalletModel> getMyWallet() async {
    try {
      final data = await ApiService().get(endpoint: 'wallet/');
      return WalletModel.fromJson(data);
    } catch (e) {
      print(e);
      return Future.error(e);
    }
  }

  @override
  Future<List<TransactionModel>> getMyWalletTransactions() async {
    try {
      final data = await ApiService().get(endpoint: 'wallet/transactions/');
      return (data as List)
          .map((item) => TransactionModel.fromJson(item))
          .toList();
    } catch (e) {
      print(e);
      return Future.error(e);
    }
  }

  @override
  Future<List<ItemModel>> getMyRequests() async {
    final data = await ApiService().get(
      endpoint: 'items/requests/',
      queryParameters: {'type': 'sent'},
    );

    return (data as List)
        .map((e) => ItemModel.fromJson(e['item'] as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<RequestModel>> getRecivedRequests() async {
    final data = await ApiService().get(
      endpoint: 'items/requests/',
      queryParameters: {'type': 'received'},
    );

    return (data as List)
        .map((e) => RequestModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<Map<String, dynamic>> rejectRequest(int requestId) async {
    final api = ApiService();
    final data = await api.patch('items/requests/$requestId/action/', {
      'status': 'rejected',
    });
    return data;
  }

  @override
  Future<Map<String, dynamic>> acceptRequest(int requestId) async {
    final api = ApiService();
    final data = await api.patch('items/requests/$requestId/action/', {
      'status': 'accepted',
    });
    return data;
  }

  @override
  Future<List<RatingModel>> getMyGivenRatings() async {
    final api = ApiService();
    final data = await api.get(endpoint: 'ratings/my-given-ratings/');
    return (data as List).map((e) => RatingModel.fromJson(e)).toList();
  }

  @override
  Future<List<RatingModel>> getMyReceivedRatings() async {
    final api = ApiService();
    final data = await api.get(endpoint: 'ratings/my-received-ratings/');
    return (data as List).map((e) => RatingModel.fromJson(e)).toList();
  }

  @override
  Future<void> editRate(int? rateId, String? newComment, int? newRating) async {
    final api = ApiService();
    await api.patch('ratings/$rateId/update/', {
      'comment': newComment,
      'rating': newRating,
    });
  }

  @override
  Future<void> deleteRate(int? rateId) async {
    final api = ApiService();
    await api.delete('ratings/$rateId/delete/');
  }

  @override
  Future<List<BidModel>> getMyBids() {
    final api = ApiService();
    return api
        .get(endpoint: 'items/my-bids/')
        .then(
          (data) => (data as List).map((e) => BidModel.fromJson(e)).toList(),
        );
  }

  @override
  Future<List<ReportModel>> getMyReports() async {
    final api = ApiService();
    return await api
        .get(endpoint: 'reports/list/')
        .then(
          (data) => (data as List).map((e) => ReportModel.fromJson(e)).toList(),
        );
  }
}
