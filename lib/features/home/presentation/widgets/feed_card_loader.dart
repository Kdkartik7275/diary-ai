import 'package:flutter/material.dart';

class FeedCardLoader extends StatelessWidget {
  const FeedCardLoader({super.key});

  Widget box({double? height, double? width, double radius = 8}) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;

    return Container(
      height: height * .2,
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          box(height: height * .16, width: 100, radius: 16),
          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),

                box(height: 18, width: double.infinity),
                const SizedBox(height: 8),
                box(height: 18, width: 180),

                const SizedBox(height: 10),

                Row(
                  children: [
                    box(height: 28, width: 28, radius: 50),
                    const SizedBox(width: 8),
                    box(height: 14, width: 120),
                  ],
                ),

                const SizedBox(height: 12),

                box(height: 20, width: 70),

                const SizedBox(height: 12),

                Row(
                  children: [
                    box(height: 14, width: 40),
                    const SizedBox(width: 10),
                    box(height: 14, width: 40),
                    const SizedBox(width: 10),
                    box(height: 14, width: 40),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
