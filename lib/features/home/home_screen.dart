import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:quiz/features/home/application/get_controller.dart';
import 'package:quiz/features/premium/premium_screen.dart';
import 'package:quiz/features/success_and_lose/lose_screen.dart';
import 'package:quiz/features/success_and_lose/success_screen.dart';
import 'package:quiz/features/tutorial/tutorial_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _productIds = {'weekly'};

class HomeScreen extends StatefulWidget {
  final bool isPro;
  const HomeScreen({
    Key? key,
    required this.isPro,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController controller = TextEditingController();
  late bool isPro = widget.isPro;
  late StreamSubscription<dynamic> _subscription;
  List<ProductDetails> _products = [];
  InAppPurchase inAppPurchase = InAppPurchase.instance;
  @override
  void initState() {
    final Stream purchaseUpdated = inAppPurchase.purchaseStream;
    _subscription = purchaseUpdated.listen((purchaseDetailsList) {
      _listenToPurchaseUpdated(purchaseDetailsList);
    }, onDone: () {
      _subscription.cancel();
    }, onError: (error) {});
    super.initState();
    initStoreInfo();
    super.initState();
  }

  void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
      if (purchaseDetails.status == PurchaseStatus.pending) {
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.red,
              content: const Text('Error purchasing subscription'),
              action: SnackBarAction(
                label: 'Close',
                textColor: Colors.white,
                onPressed: () {},
              ),
            ),
          );
        } else if (purchaseDetails.status == PurchaseStatus.purchased ||
            purchaseDetails.status == PurchaseStatus.restored) {
          setState(() {
            isPro = true;
          });
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString(
            date,
            (DateTime.now().add(
              const Duration(days: 7),
            )).toIso8601String(),
          );
        }
        if (purchaseDetails.pendingCompletePurchase) {
          await InAppPurchase.instance.completePurchase(purchaseDetails);
        }
      }
    });
  }

  initStoreInfo() async {
    final bool available = await InAppPurchase.instance.isAvailable();
    if (!available) {}
    ProductDetailsResponse productDetailResponse = await inAppPurchase.queryProductDetails(
      _productIds,
    );
    if (productDetailResponse.error == null) {
      setState(() {
        _products = productDetailResponse.productDetails;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    bool keyboardIsOpened = MediaQuery.of(context).viewInsets.bottom != 0.0;

    return GetBuilder<HomeController>(
      init: HomeController(),
      initState: (homeController) {},
      builder: (homeController) {
        return Scaffold(
          backgroundColor: Colors.white,
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
          floatingActionButton: keyboardIsOpened
              ? null
              : Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 21),
                      child: SizedBox(
                        width: double.infinity,
                        height: 45,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            padding: EdgeInsets.zero,
                            primary: isPro ? const Color(0xFFFFFFFF) : const Color(0xFF442DE3),
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(
                                color: Color(0xFF442DE3),
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () async {
                            await homeController.getQuestion();
                          },
                          child: homeController.isLoading
                              ? CupertinoActivityIndicator(
                                  color: isPro ? const Color(0xFF442DE3) : Colors.white,
                                )
                              : Text(
                                  'Generate',
                                  style: TextStyle(
                                    color: isPro ? const Color(0xFF442DE3) : Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    if (isPro)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 21),
                        child: SizedBox(
                          width: double.infinity,
                          height: 45,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              padding: EdgeInsets.zero,
                              primary: const Color(0xFF442DE3),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () {
                              if (controller.text == homeController.answer) {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => const SuccessScreen(),
                                  ),
                                );
                              } else {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => LoseScreen(
                                      text: homeController.answer,
                                    ),
                                  ),
                                );
                              }
                            },
                            child: const Text(
                              'Send',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: SizedBox(
                height: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top,
                child: Padding(
                  padding: const EdgeInsets.only(right: 18, left: 18, top: 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SvgPicture.asset('assets/leading.svg'),
                          isPro
                              ? CupertinoButton(
                                  padding: EdgeInsets.zero,
                                  child: SvgPicture.asset('assets/lamp.svg'),
                                  onPressed: () async {
                                    await showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        title: Column(
                                          children: [
                                            const Text(
                                              'Hint',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.black,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 8,
                                            ),
                                            Text(
                                              homeController.hint,
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                )
                              : CupertinoButton(
                                  padding: EdgeInsets.zero,
                                  onPressed: () async {
                                    final res = await Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => PremiumScreen(
                                          productDetails: (_products.isEmpty) ? null : _products[0],
                                          onPurchase: _products.isEmpty
                                              ? () async {
                                                  setState(() {
                                                    isPro = true;
                                                  });
                                                  Navigator.pop(context);
                                                }
                                              : () async {
                                                  final res = await inAppPurchase.buyNonConsumable(
                                                    purchaseParam: PurchaseParam(
                                                      productDetails: _products[0],
                                                    ),
                                                  );
                                                  if (res) {
                                                    Navigator.pop(context);
                                                  }
                                                },
                                        ),
                                      ),
                                    );
                                    if (res != null) {
                                      if (res) {
                                        setState(() {
                                          isPro = res;
                                        });
                                      }
                                    }
                                  },
                                  child: SvgPicture.asset('assets/pro.svg'),
                                ),
                        ],
                      ),
                      Stack(
                        alignment: Alignment.topRight,
                        children: [
                          Container(
                            alignment: Alignment.center,
                            width: double.infinity,
                            child: SvgPicture.asset('assets/questions.svg'),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Text(
                        homeController.question,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 22,
                      ),
                      if (isPro)
                        TextField(
                          controller: controller,
                          decoration: InputDecoration(
                            hintText: 'Type your answer...',
                            filled: true,
                            fillColor: const Color(0xFFD9D9D9).withOpacity(0.32),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 0.5,
                                color: Colors.black.withOpacity(0.06),
                              ),
                              gapPadding: 1,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 0.5,
                                color: Colors.black.withOpacity(0.06),
                              ),
                              gapPadding: 1,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 0.5,
                                color: Colors.black.withOpacity(0.06),
                              ),
                              gapPadding: 1,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            disabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 0.5,
                                color: Colors.black.withOpacity(0.06),
                              ),
                              gapPadding: 1,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
