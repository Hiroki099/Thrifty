import 'package:dealura/features/auth/model/user_model.dart';
import 'package:dealura/features/home/model/item_model.dart';
abstract class ProfileRepository {
  Future<UserModel> getMyProfile();
  Future<void> editProfile();
  Future<UserModel> getUserProfile(int userId);
  Future<List<ItemModel>> getMyItems();
  Future<List<ItemModel>> getMyRequests();
  Future<List<ItemModel>> getUserItems(int userId);
  Future<void> deleteItem(int itemId);
  Future<void> deleteRequest(int requestId);
  Future<void> editItem(int itemId);
  Future<void> editRequest(int requestId);
  Future<List<ItemModel>> getUserRequests(int userId);
  Future<void> logOut();
  Future<List<Map<String, dynamic>>> getMyWalletTransactions();
  Future<Map<String, dynamic>> getMyWallet();
}
