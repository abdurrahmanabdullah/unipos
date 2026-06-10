import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/di/app_providers.dart';
import '../../../../core/themes/app_sizes.dart';

class SidebarMenu extends ConsumerWidget {
  const SidebarMenu({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final location = GoRouterState.of(context).uri.path;

    return Container(
      width: 250,
      color: Theme.of(context).colorScheme.surfaceContainerLowest,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLogo(context),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: AppSizes.padding),
              children: [
                _SidebarItem(
                  icon: Icons.dashboard_outlined,
                  label: 'Dashboard',
                  isSelected: location.startsWith('/products'),
                  onTap: () {
                    context.go('/products');
                    if (MediaQuery.of(context).size.width < 800 && Navigator.of(context).canPop()) {
                      Navigator.of(context).pop();
                    }
                  },
                ),
                _SidebarItem(
                  icon: Icons.inventory_2_outlined,
                  label: 'Products',
                  isSelected: false,
                  onTap: () {},
                ),
                _SidebarItem(
                  icon: Icons.category_outlined,
                  label: 'Category',
                  isSelected: false,
                  onTap: () {},
                ),
                _SidebarItem(
                  icon: Icons.branding_watermark_outlined,
                  label: 'Brands',
                  isSelected: false,
                  onTap: () {},
                ),
                _SidebarItem(
                  icon: Icons.point_of_sale_outlined,
                  label: 'Mobile POS',
                  isSelected: location.startsWith('/home'),
                  onTap: () {
                    context.go('/home');
                    if (MediaQuery.of(context).size.width < 800 && Navigator.of(context).canPop()) {
                      Navigator.of(context).pop();
                    }
                  },
                ),
                _SidebarItem(
                  icon: Icons.receipt_long_outlined,
                  label: 'Transactions',
                  isSelected: location.startsWith('/transactions'),
                  onTap: () {
                    context.go('/transactions');
                    if (MediaQuery.of(context).size.width < 800 && Navigator.of(context).canPop()) {
                      Navigator.of(context).pop();
                    }
                  },
                ),
                _SidebarItem(
                  icon: Icons.settings_outlined,
                  label: 'Profile Settings',
                  isSelected: location.startsWith('/account'),
                  onTap: () => context.go('/account'),
                ),
              ],
            ),
          ),
          _buildPromoBanner(context),
        ],
      ),
    );
  }

  Widget _buildLogo(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSizes.padding * 1.5),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.storefront_outlined,
              color: Theme.of(context).colorScheme.primary,
              size: 24,
            ),
          ),
          const SizedBox(width: AppSizes.padding),
          Expanded(
            child: Text(
              'PoshPointHub',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPromoBanner(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSizes.padding),
      child: Container(
        padding: const EdgeInsets.all(AppSizes.padding),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(AppSizes.radius),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.fastfood, size: 40, color: Colors.orange),
            const SizedBox(height: AppSizes.padding),
            Text(
              'Add Menus',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Manage your food and beverages menus',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.outline,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SidebarItem extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _SidebarItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_SidebarItem> createState() => _SidebarItemState();
}

class _SidebarItemState extends State<_SidebarItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final color = widget.isSelected ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.outline;
    final bgColor = widget.isSelected 
        ? Theme.of(context).colorScheme.primary.withOpacity(0.1) 
        : (_isHovered ? Theme.of(context).colorScheme.primary.withOpacity(0.05) : Colors.transparent);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.padding, vertical: 4),
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.padding, vertical: 12),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(AppSizes.radius),
            ),
            child: Row(
              children: [
                Icon(widget.icon, color: color, size: 20),
                const SizedBox(width: AppSizes.padding),
                Text(
                  widget.label,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: color,
                    fontWeight: widget.isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
