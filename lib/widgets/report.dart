import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:recipes/models/recipe.dart';
import 'package:recipes/notifiers/recipes_notifier.dart';
import 'package:recipes/providers/providers.dart';
import 'package:recipes/repositories/recipe_repository.dart';
import 'package:recipes/utils.dart';

class SortState {
  int _index;
  bool _ascending;

  int get index => _index;
  set index(int index) => this._index = index;

  bool get ascending => _ascending;
  set ascending(bool ascending) => this._ascending = ascending;
}

final DateFormat _formatter = DateFormat('MM-dd-yyyy');

class Report extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final recipesState = useProvider(recipesStateProvider.state);
    if (recipesState is RecipesLoaded)
      return PaginatedDataTable(
        showCheckboxColumn: false,
        columns: [
          DataColumn(
            label: Text('Id'),
            onSort: (index, ascending) {},
          ),
          DataColumn(
            label: Text('Title'),
          ),
          DataColumn(
            label: Text('Source'),
          ),
          DataColumn(
            label: Text('Created At'),
          ),
          DataColumn(
            label: Text('Created By'),
          ),
        ],
        // rows: [
        //   for (var _recipe in (recipesState as RecipesLoaded).recipes)
        //     DataRow(
        //       cells: [
        //         DataCell(Text('${_recipe.id}')),
        //         DataCell(Text('${_recipe.title}')),
        //         DataCell(Text('${_formatter.format(_recipe.createdAt)}')),
        //         DataCell(
        //           Text('${_recipe.createdBy}'),
        //         )
        //       ],
        //     )
        // ],
        source: RecipeDataTableSource(
          recipesState.recipes,
          (id) {
            openRecipe(context, id);
          },
        ),
        rowsPerPage:
            recipesState.recipes.length > 10 ? 10 : recipesState.recipes.length,
      );
    else
      return Center(
        child: CircularProgressIndicator(),
      );
  }
}

class RecipeDataTableSource extends DataTableSource {
  final List<Recipe> _recipes;
  final Function(int id) _onRowPress;
  RecipeDataTableSource(this._recipes, this._onRowPress);

  @override
  DataRow getRow(int index) {
    final _recipe = _recipes[index];
    return DataRow.byIndex(
      onSelectChanged: (selected) => _onRowPress(_recipe.id),
      index: index,
      cells: [
        DataCell(Text('${_recipe.id}')),
        DataCell(Text('${_recipe.title}')),
        DataCell(Text('${_recipe.source}')),
        DataCell(Text('${_formatter.format(_recipe.createdAt)}')),
        DataCell(Text('${_recipe.createdBy}')),
      ],
    );
  }

  @override
  int get selectedRowCount => 0;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => _recipes.length;
}
