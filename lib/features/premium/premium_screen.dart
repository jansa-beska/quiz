import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class PremiumScreen extends StatelessWidget {
  final ProductDetails? productDetails;
  final Future<void> Function()? onPurchase;
  const PremiumScreen({
    Key? key,
    required this.productDetails,
    required this.onPurchase,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF442DE3),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 21),
        child: SizedBox(
          width: double.infinity,
          height: 45,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              elevation: 0,
              padding: EdgeInsets.zero,
              primary: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () async {
              if (onPurchase != null) await onPurchase!();
            },
            child: const Text(
              'Buy',
              style: TextStyle(
                color: Color(0xFF442DE3),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 21,
            right: 21,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(child: SvgPicture.asset('assets/try_pro.svg')),
              const SizedBox(
                height: 121,
              ),
              Image.asset(
                'assets/get_answer.png',
                height: 77,
                width: 318,
              ),
              const SizedBox(
                height: 13,
              ),
              Image.asset(
                'assets/get_hint.png',
                height: 77,
                width: 318,
              ),
              const SizedBox(
                height: 40,
              ),
              productDetails != null
                  ? Text(
                      productDetails!.price,
                      style: const TextStyle(color: Colors.white, fontSize: 34),
                    )
                  : const Text(
                      '0\$',
                      style: TextStyle(color: Colors.white, fontSize: 34),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
