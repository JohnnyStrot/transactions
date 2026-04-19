import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:transactions/data/model/entity.dart';

abstract class EntityListEntry<T extends StrongEntity> extends StatelessWidget {
  const EntityListEntry({
    super.key,
    required this.entity,
    required this.onDelete,
  });

  final T entity;

  final void Function(T loc) onDelete;

  String route(T op);

  String entityToString(T opp);

  Widget buildContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10,
      children: [
        Text(
          entityToString(entity),
          overflow: TextOverflow.ellipsis,
          style: TextTheme.of(context).displaySmall!.copyWith(
            fontSize: TextTheme.of(context).bodyLarge!.fontSize,
          ),
        ),
      ],
    );
  }

  Widget buildActionButtons(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      IconButton(
        onPressed: () {
          context.push("${route(entity)}/${entity.id}");
        },
        icon: Icon(Icons.edit),
      ),
      IconButton(
        onPressed: () {
          onDelete(entity);
        },
        icon: Icon(Icons.delete),
      ),
    ],
  );

  Widget buildBorder(BuildContext context, Widget child) => Container(
    decoration: BoxDecoration(
      border: BoxBorder.fromLTRB(
        bottom: BorderSide(
          color: ColorScheme.of(context).primary.withAlpha(60),
          style: BorderStyle.solid,
        ),
      ),
    ),
    padding: EdgeInsets.only(bottom: 10, left: 10),
    child: child,
  );

  @override
  Widget build(BuildContext context) {
    return buildBorder(
      context,
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(child: buildContent(context)),
          buildActionButtons(context),
        ],
      ),
    );
  }
}
