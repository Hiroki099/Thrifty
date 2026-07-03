import 'dart:io';

import 'package:dealura/core/utls/api_service.dart';
import 'package:dealura/core/utls/save_token.dart';
import 'package:dealura/features/auth/model/user_model.dart';
import 'package:dealura/features/home/model/item_model.dart';
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
        if (username != null) 'username': username,
        if (email != null) 'email': email,
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
}
