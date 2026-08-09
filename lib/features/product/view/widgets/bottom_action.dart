import 'package:dealura/core/utls/chat_client.dart';
import 'package:dealura/features/chat/view/pages/chat_details_page.dart';
import 'package:dealura/features/home/model/item_model.dart';
import 'package:flutter/material.dart';

Widget bottomAction({
  required String text,
  required ItemModel product,
  required bool isMyProduct,
  bool isRequested = false,
  bool isLoading = false,
  bool isCheckingRequest = false,
  bool isAvailable = true,
  bool purchaseLoading = false,
  VoidCallback? onPurchase,
  VoidCallback? onRequest,
  VoidCallback? onEdit,
  ValueChanged<int>? onBid,
  required BuildContext context,
  TextEditingController? bidController,
}) {
  if (isMyProduct) {
    Color color;

    switch (text) {
      case "Buy now":
        color = const Color(0xffE8A87C); // Sale
        break;

      case "Place bid":
        color = const Color(0xFF8B7EC8); // Auction
        break;

      default:
        color = const Color(0xff5BAB8B); // Donation
    }

    return Container(
      decoration: const BoxDecoration(color: Color(0xffFBF8F2)),
      child: SizedBox(
        height: 53,
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: onEdit,
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          icon: const Icon(Icons.edit_outlined),
          label: const Text(
            "Edit Product",
            style: TextStyle(
              fontFamily: "IBM Plex Sans",
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
  if (text == "Buy now") {
    return Container(
      decoration: const BoxDecoration(color: Color(0xffFBF8F2)),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: (!isAvailable || purchaseLoading) ? null : onPurchase,
              child: Container(
                height: 51,
                width: 293,
                decoration: BoxDecoration(
                  color: isAvailable ? const Color(0xffE8A87C) : Colors.grey,
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: purchaseLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        isAvailable ? text : "Sold",
                        style: const TextStyle(
                          color: Color(0xffFFFFFF),
                          fontSize: 20,
                          fontFamily: "IBM Plex Sans",
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xffD4D0CA), width: 1.5),
            ),
            child: GestureDetector(
              onTap: () {
                openProductChat(context: context, product: product);
              },
              child: const Icon(
                Icons.chat_bubble_outline,
                color: Color(0xffB5B0A8),
              ),
            ),
          ),
        ],
      ),
    );
  } else if (text == "Place bid") {
    return Container(
      decoration: const BoxDecoration(color: Color(0xffFBF8F2)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 159,
            height: 53,
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFF8B7EC8), width: 1.5),
            ),
            child: TextField(
              controller: bidController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: "Enter bid",
                hintStyle: TextStyle(
                  fontFamily: "IBM Plex Sans",
                  fontSize: 14,
                  color: Color(0xffB5B0A8),
                ),
                border: InputBorder.none,
              ),
              style: const TextStyle(
                fontFamily: "IBM Plex Sans",
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Color(0xff8B7EC8),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              final amount = int.tryParse(bidController!.text);

              if (amount == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Enter a valid amount")),
                );
                return;
              }

              onBid?.call(amount);
            },
            child: Container(
              width: 129,
              height: 53,
              decoration: ShapeDecoration(
                color: const Color(0xFF8B7EC8),
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 1.50, color: const Color(0xFF8B7EC8)),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Center(
                child: Text(
                  text,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontFamily: "IBM Plex Sans",
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xffD4D0CA), width: 1.5),
            ),
            child: GestureDetector(
              onTap: () {
                openProductChat(context: context, product: product);
              },
              child: const Icon(
                Icons.chat_bubble_outline,
                color: Color(0xffB5B0A8),
              ),
            ),
          ),
        ],
      ),
    );
  } else {
    return Container(
      decoration: const BoxDecoration(color: Color(0xffFBF8F2)),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: isCheckingRequest || isLoading ? null : onRequest,
              child: Container(
                height: 51,
                width: 293,
                decoration: BoxDecoration(
                  color: const Color(0xff5BAB8B),
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,

                child: isCheckingRequest || isLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        isRequested ? "Cancel request" : "Request this item",

                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontFamily: "IBM Plex Sans",
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xffD4D0CA), width: 1.5),
            ),
            child: GestureDetector(
              onTap: () {
                openProductChat(context: context, product: product);
              },
              child: const Icon(
                Icons.chat_bubble_outline,
                color: Color(0xffB5B0A8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> openProductChat({
  required BuildContext context,
  required ItemModel product,
}) async {
  try {
    print('CHAT OPEN START: Item ID: ${product.id}');
    print('CHAT OPEN: currentUserId from global: $currentUserId');
    print('CHAT OPEN: Stream currentUser: ${streamClient.state.currentUser?.id}');
    
    // Update currentUserId from streamClient if it's null
    if (currentUserId == null && streamClient.state.currentUser != null) {
      currentUserId = streamClient.state.currentUser?.id;
      print('CHAT OPEN: Updated currentUserId from streamClient: $currentUserId');
    }
    
    if (currentUserId == null) {
      print('CHAT OPEN ERROR: User not logged in');
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Please log in to chat')));
      }
      return;
    }

    final sellerId = product.owner?.id?.toString();

    if (sellerId == null) {
      print('CHAT OPEN ERROR: Seller ID is missing');
      throw Exception('Seller ID is missing');
    }

    if (sellerId == currentUserId) {
      print('CHAT OPEN ERROR: User trying to chat with themselves');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You cannot chat with yourself')),
      );
      return;
    }

    print('CHAT OPEN: Current user: $currentUserId, Seller: $sellerId');

    final ids = [currentUserId!, sellerId]..sort();

    final channelId = 'item-${product.id}-${ids[0]}-${ids[1]}';

    print('CHAT OPEN: Creating channel with ID: $channelId');

    final channel = streamClient.channel('messaging', id: channelId);

    print('CHAT OPEN: Creating channel...');
    await channel.create();
    print('CHAT OPEN: Channel created successfully');

    print('CHAT OPEN: Adding members: [$currentUserId, $sellerId]');
    await channel.addMembers([currentUserId!, sellerId]);
    print('CHAT OPEN: Members added successfully');

    print('CHAT OPEN: Watching channel...');
    await channel.watch();
    print('CHAT OPEN: Channel watched successfully');

    if (!context.mounted) return;

    print('CHAT OPEN: Navigating to chat details...');
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ChatDetailsPage(channel: channel)),
    );
  } catch (e) {
    print('CHAT OPEN ERROR: $e');
    if (!context.mounted) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Failed to open chat: $e')));
  }
}
