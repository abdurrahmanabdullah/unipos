import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/di/app_providers.dart';
import '../../providers/main/main_notifier.dart';
import '../welcome/welcome_screen.dart';
import 'components/sidebar_menu.dart';

class MainScreen extends ConsumerStatefulWidget {
  final Widget child;

  const MainScreen({
    super.key,
    required this.child,
  });

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.read(mainNotifierProvider.notifier).initMainProvider();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isLoaded = ref.watch(mainNotifierProvider.select((p) => p.isLoaded));
    final isHasInternet = ref.watch(mainNotifierProvider.select((p) => p.isHasInternet));
    final user = ref.watch(mainNotifierProvider.select((p) => p.user));

    if (!isLoaded) {
      return const WelcomeScreen();
    }

    if (isLoaded && user == null && !isHasInternet) {
      throw Exception(
        'No Internet connection! Internet connection is required for the first time app open or user login',
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 800;

        return Scaffold(
          appBar: isMobile
              ? AppBar(
                  backgroundColor: Theme.of(context).colorScheme.surfaceContainerLowest,
                  iconTheme: const IconThemeData(color: Colors.white),
                  title: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search',
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.surface,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                    ),
                  ),
                  actions: [
                    IconButton(icon: const Icon(Icons.notifications_outlined), onPressed: () {}),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: CircleAvatar(
                        radius: 16,
                        backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=11'),
                      ),
                    ),
                  ],
                )
              : null,
          drawer: isMobile ? const Drawer(child: SidebarMenu()) : null,
          body: Row(
            children: [
              if (!isMobile) const SidebarMenu(),
              Expanded(
                child: Column(
                  children: [
                    if (!isMobile) _buildHeader(context),
                    Expanded(child: widget.child),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLowest,
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Theme.of(context).colorScheme.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
            ),
          ),
          const SizedBox(width: 24),
          Row(
            children: [
              IconButton(icon: const Icon(Icons.wb_sunny_outlined), onPressed: () {}),
              const SizedBox(width: 8),
              IconButton(icon: const Icon(Icons.notifications_outlined), onPressed: () {}),
              const SizedBox(width: 8),
              IconButton(icon: const Icon(Icons.mail_outline), onPressed: () {}),
              const SizedBox(width: 16),
              const CircleAvatar(
                backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=11'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
