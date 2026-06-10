import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:go_router/go_router.dart';

import '../../../core/themes/app_sizes.dart';
import '../../../domain/entities/product_entity.dart';
import '../../providers/products/products_notifier.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_empty_state.dart';
import '../../widgets/app_loading_more_indicator.dart';
import '../../widgets/app_progress_indicator.dart';
import '../../widgets/app_text_field.dart';
import 'components/products_card.dart';

class ProductsScreen extends ConsumerStatefulWidget {
  const ProductsScreen({super.key});

  @override
  ConsumerState<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends ConsumerState<ProductsScreen> {
  final scrollController = ScrollController();
  final searchFieldController = TextEditingController();

  @override
  void initState() {
    scrollController.addListener(scrollListener);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(productsNotifierProvider.notifier).getAllProducts();
    });
    super.initState();
  }

  @override
  void dispose() {
    scrollController.removeListener(scrollListener);
    scrollController.dispose();
    searchFieldController.dispose();
    super.dispose();
  }

  void scrollListener() async {
    final productsState = ref.read(productsNotifierProvider);
    if (scrollController.offset == scrollController.position.maxScrollExtent) {
      await ref
          .read(productsNotifierProvider.notifier)
          .getAllProducts(
            offset: productsState.allProducts?.length,
            contains: searchFieldController.text,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final allProducts = ref.watch(productsNotifierProvider.select((s) => s.allProducts));
    final isLoadingMore = ref.watch(productsNotifierProvider.select((s) => s.isLoadingMore));

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLowest,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 800;
          return SingleChildScrollView(
            controller: scrollController,
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  runSpacing: 16,
                  spacing: 16,
                  children: [
                    Text(
                      'Item Sales',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    AppButton(
                      width: 160,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      onTap: () => context.go('/products/product-create'),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.add, size: 16, color: Colors.white),
                          const SizedBox(width: 8),
                          Text('Add Product', style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Colors.white)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      SizedBox(width: isMobile ? 250 : 300, child: _buildSummaryCard(context, 'Total Order', '৳ 764.00', '+47%', Colors.cyan.shade100)),
                      const SizedBox(width: 16),
                      SizedBox(width: isMobile ? 250 : 300, child: _buildSummaryCard(context, 'New Order', '৳ 364.00', '+36%', Colors.pink.shade100)),
                      const SizedBox(width: 16),
                      SizedBox(width: isMobile ? 250 : 300, child: _buildSummaryCard(context, 'Pending Order', '৳ 382.00', '+40%', Colors.blue.shade100)),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                isMobile
                    ? Column(
                        children: [
                          _buildChartSection(context),
                          const SizedBox(height: 24),
                          _buildTopSellingSection(context),
                        ],
                      )
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(flex: 2, child: _buildChartSection(context)),
                          const SizedBox(width: 24),
                          Expanded(flex: 1, child: _buildTopSellingSection(context)),
                        ],
                      ),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Item List',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: SizedBox(
                          width: isMobile ? 200 : 300,
                          child: _SearchField(controller: searchFieldController),
                        ),
                      ),
                    ),
                  ],
                ),
            const SizedBox(height: 16),
            if (allProducts == null)
              const Center(child: AppProgressIndicator())
            else if (allProducts.isEmpty)
              AppEmptyState(
                subtitle: 'No products available, add product to continue',
                buttonText: 'Add Product',
                onTapButton: () => context.go('/products/product-create'),
              )
            else
              AnimationLimiter(
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 250,
                    childAspectRatio: 0.8,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: allProducts.length,
                  itemBuilder: (context, i) {
                    final crossAxisCount = (MediaQuery.of(context).size.width / 250).floor();
                    return AnimationConfiguration.staggeredGrid(
                      position: i,
                      duration: const Duration(milliseconds: 375),
                      columnCount: crossAxisCount > 0 ? crossAxisCount : 1,
                      child: ScaleAnimation(
                        child: FadeInAnimation(
                          child: _ProductCard(product: allProducts[i]),
                        ),
                      ),
                    );
                  },
                ),
              ),
            AppLoadingMoreIndicator(isLoading: isLoadingMore),
          ],
        ),
      );
    },
    ),
    );
  }

  Widget _buildChartSection(BuildContext context) {
    return Container(
      height: 300,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Sales Trends', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          Expanded(child: _buildChart()),
        ],
      ),
    );
  }

  Widget _buildTopSellingSection(BuildContext context) {
    return Container(
      height: 300,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Top Selling Products', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.separated(
              itemCount: 4,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                return Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade800,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.fastfood, color: Colors.orange),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Sample Burger', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          Text('4,325 Orders', style: TextStyle(color: Colors.grey.shade400, fontSize: 12)),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(BuildContext context, String title, String amount, String pct, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.analytics, color: Colors.black54),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(color: Colors.grey, fontSize: 12)),
              const SizedBox(height: 4),
              Row(
                children: [
                  Text(amount, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                  const SizedBox(width: 8),
                  Text(pct, style: const TextStyle(color: Colors.green, fontSize: 12)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChart() {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: 70,
        barTouchData: BarTouchData(enabled: false),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (double value, TitleMeta meta) {
                const style = TextStyle(color: Colors.grey, fontSize: 10);
                String text;
                switch (value.toInt()) {
                  case 0: text = 'Jan'; break;
                  case 1: text = 'Feb'; break;
                  case 2: text = 'Mar'; break;
                  case 3: text = 'Apr'; break;
                  case 4: text = 'May'; break;
                  case 5: text = 'Jun'; break;
                  case 6: text = 'Jul'; break;
                  case 7: text = 'Aug'; break;
                  case 8: text = 'Sep'; break;
                  case 9: text = 'Oct'; break;
                  case 10: text = 'Nov'; break;
                  case 11: text = 'Dec'; break;
                  default: text = ''; break;
                }
                return SideTitleWidget(meta: meta, child: Text(text, style: style));
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 28,
              getTitlesWidget: (value, meta) {
                if (value % 20 != 0) return const SizedBox.shrink();
                return Text('${value.toInt()}k', style: const TextStyle(color: Colors.grey, fontSize: 10));
              },
            ),
          ),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        gridData: FlGridData(show: false),
        borderData: FlBorderData(show: false),
        barGroups: [
          BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: 50, color: Colors.cyan, width: 8, borderRadius: BorderRadius.circular(4))]),
          BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 60, color: Colors.cyan, width: 8, borderRadius: BorderRadius.circular(4))]),
          BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: 40, color: Colors.cyan, width: 8, borderRadius: BorderRadius.circular(4))]),
          BarChartGroupData(x: 3, barRods: [BarChartRodData(toY: 55, color: Colors.cyan, width: 8, borderRadius: BorderRadius.circular(4))]),
          BarChartGroupData(x: 4, barRods: [BarChartRodData(toY: 65, color: Colors.cyan, width: 8, borderRadius: BorderRadius.circular(4))]),
          BarChartGroupData(x: 5, barRods: [BarChartRodData(toY: 45, color: Colors.cyan, width: 8, borderRadius: BorderRadius.circular(4))]),
          BarChartGroupData(x: 6, barRods: [BarChartRodData(toY: 50, color: Colors.cyan, width: 8, borderRadius: BorderRadius.circular(4))]),
          BarChartGroupData(x: 7, barRods: [BarChartRodData(toY: 60, color: Colors.cyan, width: 8, borderRadius: BorderRadius.circular(4))]),
          BarChartGroupData(x: 8, barRods: [BarChartRodData(toY: 40, color: Colors.cyan, width: 8, borderRadius: BorderRadius.circular(4))]),
          BarChartGroupData(x: 9, barRods: [BarChartRodData(toY: 55, color: Colors.cyan, width: 8, borderRadius: BorderRadius.circular(4))]),
          BarChartGroupData(x: 10, barRods: [BarChartRodData(toY: 65, color: Colors.cyan, width: 8, borderRadius: BorderRadius.circular(4))]),
          BarChartGroupData(x: 11, barRods: [BarChartRodData(toY: 45, color: Colors.cyan, width: 8, borderRadius: BorderRadius.circular(4))]),
        ],
      ),
    );
  }
}

class _SearchField extends ConsumerWidget {
  final TextEditingController controller;

  const _SearchField({required this.controller});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppTextField(
      controller: controller,
      hintText: 'Search...',
      type: AppTextFieldType.search,
      textInputAction: TextInputAction.search,
      onEditingComplete: () {
        FocusScope.of(context).unfocus();
        ref.read(productsNotifierProvider.notifier).resetProducts();
        ref.read(productsNotifierProvider.notifier).getAllProducts(contains: controller.text);
      },
      onTapClearButton: () {
        ref.read(productsNotifierProvider.notifier).getAllProducts(contains: controller.text);
      },
    );
  }
}

class _ProductCard extends StatelessWidget {
  final ProductEntity product;

  const _ProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    return ProductsCard(
      product: product,
      onTap: () => context.go('/products/product-detail/${product.id}'),
    );
  }
}
