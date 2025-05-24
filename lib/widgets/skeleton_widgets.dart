import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SkeletonLoader extends StatelessWidget {
  final double width;
  final double height;
  final BorderRadius? borderRadius;

  const SkeletonLoader({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: borderRadius ?? BorderRadius.circular(8),
        ),
      ),
    );
  }
}

class DrugCardSkeleton extends StatelessWidget {
  const DrugCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const SkeletonLoader(width: 40, height: 40),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SkeletonLoader(width: double.infinity, height: 16),
                      const SizedBox(height: 8),
                      SkeletonLoader(
                        width: MediaQuery.of(context).size.width * 0.6,
                        height: 12,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const SkeletonLoader(width: double.infinity, height: 12),
            const SizedBox(height: 8),
            const SkeletonLoader(width: double.infinity, height: 12),
            const SizedBox(height: 8),
            SkeletonLoader(
              width: MediaQuery.of(context).size.width * 0.7,
              height: 12,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const SkeletonLoader(width: 80, height: 24),
                const Spacer(),
                const SkeletonLoader(width: 60, height: 24),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class HealthTipCardSkeleton extends StatelessWidget {
  const HealthTipCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SkeletonLoader(
            width: double.infinity,
            height: 200,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SkeletonLoader(width: double.infinity, height: 18),
                const SizedBox(height: 12),
                const SkeletonLoader(width: double.infinity, height: 14),
                const SizedBox(height: 8),
                const SkeletonLoader(width: double.infinity, height: 14),
                const SizedBox(height: 8),
                SkeletonLoader(
                  width: MediaQuery.of(context).size.width * 0.6,
                  height: 14,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const SkeletonLoader(width: 80, height: 24),
                    const Spacer(),
                    const SkeletonLoader(width: 100, height: 24),
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

class CategoryChipSkeleton extends StatelessWidget {
  const CategoryChipSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: const SkeletonLoader(
        width: 80,
        height: 40,
        borderRadius: BorderRadius.all(Radius.circular(25)),
      ),
    );
  }
}

class StatCardSkeleton extends StatelessWidget {
  const StatCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const SkeletonLoader(width: 32, height: 32),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SkeletonLoader(width: double.infinity, height: 14),
                      const SizedBox(height: 8),
                      SkeletonLoader(
                        width: MediaQuery.of(context).size.width * 0.4,
                        height: 12,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const SkeletonLoader(width: 60, height: 24),
            const SizedBox(height: 8),
            const SkeletonLoader(width: 80, height: 16),
          ],
        ),
      ),
    );
  }
}

class ListSkeleton extends StatelessWidget {
  final int itemCount;
  final Widget itemSkeleton;

  const ListSkeleton({
    super.key,
    required this.itemCount,
    required this.itemSkeleton,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: itemCount,
      itemBuilder: (context, index) => itemSkeleton,
    );
  }
}

class GridSkeleton extends StatelessWidget {
  final int itemCount;
  final Widget itemSkeleton;
  final int crossAxisCount;

  const GridSkeleton({
    super.key,
    required this.itemCount,
    required this.itemSkeleton,
    this.crossAxisCount = 2,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.2,
      ),
      itemCount: itemCount,
      itemBuilder: (context, index) => itemSkeleton,
    );
  }
}
