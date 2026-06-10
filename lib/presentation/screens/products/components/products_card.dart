import 'package:app_image/app_image.dart';
import 'package:flutter/material.dart';

import '../../../../core/themes/app_sizes.dart';
import '../../../../core/utilities/currency_formatter.dart';
import '../../../../domain/entities/product_entity.dart';

class ProductsCard extends StatelessWidget {
  final ProductEntity product;
  final VoidCallback? onTap;
  final bool enabled;

  const ProductsCard({
    super.key,
    required this.product,
    this.onTap,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: InkWell(
        onTap: enabled ? onTap : null,
        splashColor: Colors.black.withValues(alpha: 0.06),
        splashFactory: InkRipple.splashFactory,
        highlightColor: Colors.black12,
        borderRadius: BorderRadius.circular(12),
        child: Ink(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              width: 1,
              color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.1),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Stack(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: AppImage(
                        image: product.imageUrl,
                        borderRadius: BorderRadius.circular(8),
                        fit: BoxFit.cover,
                        errorWidget: Icon(
                          Icons.image,
                          color: Theme.of(context).colorScheme.surfaceDim,
                          size: 32,
                        ),
                      ),
                    ),
                    product.stock <= 0 ? const _OutOfStock() : const SizedBox.shrink(),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Text(
                    CurrencyFormatter.format(product.price),
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    CurrencyFormatter.format(product.price * 1.1), // Mocked crossed price
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                product.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.grey, fontSize: 13),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.star_border, color: Colors.orange, size: 14),
                      const SizedBox(width: 4),
                      Text('5.0', style: TextStyle(color: Colors.grey.shade400, fontSize: 12)),
                    ],
                  ),
                  Text('${product.sold} Sold', style: TextStyle(color: Colors.grey.shade400, fontSize: 12)),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
                    foregroundColor: Theme.of(context).colorScheme.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    elevation: 0,
                  ),
                  child: const Text('Add Card'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OutOfStock extends StatelessWidget {
  const _OutOfStock();

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        padding: const EdgeInsets.all(6),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white70,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: AppSizes.padding / 4,
            horizontal: AppSizes.padding / 2,
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.remove_circle,
                color: Theme.of(context).colorScheme.outline,
                size: 10,
              ),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  'Out of stock',
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Theme.of(context).colorScheme.outline,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
