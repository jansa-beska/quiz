import 'package:flutter/material.dart';

class LoseScreen extends StatelessWidget {
  final String text;
  const LoseScreen({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              primary: const Color(0xFFFFFFFF),
              shape: RoundedRectangleBorder(
                side: const BorderSide(
                  color: Color(0xFF442DE3),
                ),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text(
              'Back',
              style: TextStyle(
                color: Color(0xFF442DE3),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            alignment: Alignment.center,
            child: Image.asset(
              'assets/book.png',
              height: 197,
              width: 236,
            ),
          ),
          const SizedBox(
            height: 24,
          ),
          const Text(
            'No, the answer was...',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontSize: 25,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 25,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
