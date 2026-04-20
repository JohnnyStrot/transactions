import 'package:transactions/data/model/entity.dart';
import 'package:transactions/routing/routes.dart';
import 'package:transactions/ui/core/themes/dimens.dart';
import 'package:transactions/ui/list_widgets/data_list_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

abstract class DataListView<
  T extends StrongEntity,
  M extends DataListViewmodel<T>,
  V extends DataListView<T, M, V>
>
    extends StatefulWidget {
  const DataListView({super.key, required this.viewmodel});

  final M viewmodel;

  @override
  State<V> createState();
}

abstract class DataListViewState<
  T extends StrongEntity,
  M extends DataListViewmodel<T>,
  V extends DataListView<T, M, V>
>
    extends State<V>
    with AutomaticKeepAliveClientMixin {
  Widget buildEntry(BuildContext context, T entity);
  Widget buildSearch(BuildContext context);

  String get entityDisplay;
  String get route;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final paging = PagingListener(
      controller: widget.viewmodel.pagingController,
      builder: (context, state, fetchNextPage) {
        return PagedSliverList<int, T>(
          state: state,
          fetchNextPage: fetchNextPage,
          builderDelegate: PagedChildBuilderDelegate(
            itemBuilder: (context, entity, index) => Padding(
              padding: EdgeInsets.only(top: index > 0 ? 10 : 0),
              child: buildEntry(context, entity),
            ),
          ),
        );
      },
    );

    final scroll = CustomScrollView(
      slivers: [
        SliverPadding(
          padding: EdgeInsets.only(
            bottom: Dimens.fabGap,
            right: Dimens.scrollBarGap,
          ),
          sliver: paging,
        ),
      ],
    );

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push("$route${Routes.create}");
        },
        child: Icon(Icons.add),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: Dimens.of(context).paddingScreenHorizontal,
          vertical: Dimens.of(context).paddingScreenVertical,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          spacing: Dimens.paddingVertical,
          children: [
            Text(entityDisplay, style: TextTheme.of(context).headlineSmall),
            buildSearch(context),
            Expanded(child: scroll),
          ],
        ),
      ),
    );
  }

  void delete(T entity) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: const Text('Wirklich löschen?'),
          content: Text(
            'Willst du wirklich $entityDisplay ${entity.displayShort} löschen?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                widget.viewmodel.deleteEntity(entity);

                ctx.pop();
              },
              child: const Text('Ja'),
            ),
            TextButton(
              onPressed: () {
                // Close the dialog
                ctx.pop();
              },
              child: const Text('Nein'),
            ),
          ],
        );
      },
    );
  }
}
