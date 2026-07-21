import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:transactions/ui/auth/logout/logout_button.dart';
import 'package:transactions/ui/auth/logout/logout_viewmodel.dart';
import 'package:transactions/ui/core/themes/dimens.dart';

import '../../routing/routes.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key, required this.child});

  final Widget child;

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  static const List<NavBarCategory> navbarCategories = [
    NavBarCategory(
      location: Routes.dashboard,
      icon: Icon(Icons.dashboard_outlined),
      activeIcon: Icon(Icons.dashboard),
      label: "Dashboard",
    ),
    NavBarCategory(
      location: Routes.analysis,
      icon: Icon(Icons.analytics_outlined),
      activeIcon: Icon(Icons.analytics),
      label: "Analyse",
    ),
    NavBarCategory(
      icon: Icon(Icons.table_chart_outlined),
      activeIcon: Icon(Icons.table_chart),
      label: 'Daten',
      location: Routes.data,
      subItems: [
        NavBarItem(
          icon: Icon(Icons.receipt_long_outlined),
          activeIcon: Icon(Icons.receipt_long),
          label: 'Transaktionen',
          location: Routes.transactions,
        ),
        NavBarItem(
          icon: Icon(Icons.shopping_basket_outlined),
          activeIcon: Icon(Icons.shopping_basket),
          label: 'Produkt',
          location: Routes.products,
        ),
        NavBarItem(
          icon: Icon(Icons.group_outlined),
          activeIcon: Icon(Icons.group),
          label: 'Transaktions-Partnys',
          location: Routes.transactionPartners,
        ),
        NavBarItem(
          location: Routes.companies,
          icon: Icon(Icons.label_outline),
          activeIcon: Icon(Icons.label),
          label: "Marken",
        ),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final bool displayMobileLayout = MediaQuery.of(context).size.width < 900;

    return Row(
      children: [
        if (!displayMobileLayout)
          const AppDrawer(navbarCategories: navbarCategories, mobile: false),
        Expanded(
          child: Scaffold(
            appBar: AppBar(
              title: displayMobileLayout
                  ? MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () {
                          context.push(Routes.dashboard);
                        },
                        child: Text(
                          "FTVS",
                          style: TextTheme.of(context).headlineSmall!.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    )
                  : null,
              actions: [
                LogoutButton(
                  viewModel: LogoutViewModel(authRepository: context.read()),
                ),
              ],
              backgroundColor: ColorScheme.of(context).primaryContainer,
              actionsPadding: EdgeInsets.only(right: 10),
              leading: displayMobileLayout ? DrawerButton() : null,
            ),
            body: SafeArea(
              child: Align(
                alignment: Alignment.topCenter,
                child: Container(
                  constraints: BoxConstraints(maxWidth: Dimens.contentMaxWidth),
                  child: widget.child,
                ),
              ),
            ),
            drawer: displayMobileLayout
                ? AppDrawer(navbarCategories: navbarCategories, mobile: true)
                : null,
          ),
        ),
      ],
    );
  }
}

class AppDrawer extends StatefulWidget {
  const AppDrawer({
    super.key,
    required this.navbarCategories,
    required this.mobile,
  });

  final List<NavBarCategory> navbarCategories;
  final bool mobile;

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: Border(),
      child: ListView(
        children: [
          DrawerHeader(
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () {
                  context.push(Routes.dashboard);
                },
                child: Text(
                  "FTVS",
                  style: TextTheme.of(
                    context,
                  ).displayMedium!.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          for (var cat in widget.navbarCategories)
            Column(
              children: [
                cat.tile(context, widget.mobile, (nav) {
                  setState(() {
                    if (widget.mobile) {
                      context.pop();
                    }
                    context.go(nav.location);
                  });
                }),
                Divider(),
              ],
            ),
        ],
      ),
    );
  }
}

class NavBarCategory extends NavBarItem {
  final List<NavBarItem>? subItems;

  const NavBarCategory({
    this.subItems,
    required super.location,
    required super.icon,
    required super.label,
    super.activeIcon,
  });

  @override
  Widget tile(
    BuildContext context,
    bool mobile,
    void Function(NavBarItem) onTap,
  ) {
    final matched = GoRouter.of(
      context,
    ).state.matchedLocation.startsWith(location);
    if (subItems != null) {
      return ExpansionTile(
        shape: Border(),
        title: Text(
          label,
          style: TextStyle(fontWeight: matched ? FontWeight.bold : null),
        ),
        leading: matched ? activeIcon : icon,
        initiallyExpanded: true,
        children: [
          for (var nav in subItems!)
            Padding(
              padding: const EdgeInsets.only(left: Dimens.vgap),
              child: nav.tile(context, mobile, onTap),
            ),
        ],
      );
    }
    return ListTile(
      title: Text(
        label,
        style: TextStyle(fontWeight: matched ? FontWeight.bold : null),
      ),
      leading: matched ? activeIcon : icon,
      onTap: () => onTap(this),
    );
  }
}

class NavBarItem {
  final String location;
  final String label;
  final Widget icon;
  final Widget activeIcon;

  const NavBarItem({
    required this.location,
    required this.icon,
    required this.label,
    Widget? activeIcon,
  }) : activeIcon = activeIcon ?? icon;

  Widget tile(
    BuildContext context,
    bool mobile,
    void Function(NavBarItem) onTap,
  ) {
    final matched = GoRouter.of(
      context,
    ).state.matchedLocation.startsWith(location);
    return ListTile(
      title: Text(
        label,
        style: TextStyle(fontWeight: matched ? FontWeight.bold : null),
      ),
      leading: matched ? activeIcon : icon,
      onTap: () => onTap(this),
    );
  }
}
