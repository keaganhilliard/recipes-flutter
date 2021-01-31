import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:recipes/models/ingredient.dart';
import 'package:recipes/models/instruction.dart';
import 'package:recipes/models/recipe.dart';
import 'package:recipes/notifiers/recipe_notifier.dart';
import 'package:recipes/providers/providers.dart';
import 'package:recipes/utils.dart';
import 'package:recipes/widgets/are_you_sure.dart';

class EditRecipe extends HookWidget {
  final List<Widget> _tabs = [
    Tab(
      text: 'Ingredients',
      icon: Icon(Icons.food_bank),
    ),
    Tab(
      text: 'Instructions',
      icon: Icon(Icons.list),
    ),
    Tab(
      text: 'Notes',
      icon: Icon(Icons.note),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final _index = useState(0);
    final _key = GlobalKey();
    final _formKey = GlobalKey<FormState>();
    final _recipeRepo = useProvider(recipeRepositoryProvider);
    final _recipesState = useProvider(recipesStateProvider);
    final _recipeNotifier = useProvider(recipeStateProvider);
    final _recipeState = useProvider(recipeStateProvider.state);
    final _controller = useTabController(initialLength: _tabs.length);

    _controller.addListener(() {
      _index.value = _controller.index;
    });

    final _saving = useState(false);

    if (_recipeState is RecipeError) {
      return Scaffold(
        body: Center(
          child: Text('${_recipeState.message}'),
        ),
      );
    } else if (_recipeState is RecipeLoaded) {
      final _recipe = _recipeState.recipe;

      return Scaffold(
        appBar: AppBar(
          title: Text('${_recipe.id != null ? 'Edit' : 'Create'} Recipe'),
          actions: [
            if (_recipe.id != null)
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AreYouSure(() async {
                          bool success =
                              await _recipeRepo.deleteRecipeById(_recipe.id);
                          print('$success');
                          _recipesState.getRecipes();
                          Navigator.of(context)..pop()..pop();
                        });
                      });
                },
              ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          icon: _saving.value ? null : Icon(Icons.save),
          label: _saving.value
              ? CircularProgressIndicator(
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                )
              : Text('Save'),
          onPressed: _saving.value
              ? null
              : () async {
                  if (_formKey.currentState.validate()) {
                    _saving.value = true;

                    Recipe result = await _recipeRepo.updateRecipe(_recipe);

                    if (_recipeState.ingredients.isNotEmpty) {
                      await _recipeRepo.updateIngredients(
                        result.id,
                        _recipeState.ingredients,
                      );
                    }

                    if (_recipeState.instructions.isNotEmpty) {
                      await _recipeRepo.updateInstructions(
                        result.id,
                        _recipeState.instructions,
                      );
                    }
                    await _recipeNotifier.refreshRecipe(result.id);
                    _saving.value = false;
                    _recipesState.getRecipes();
                  }
                },
        ),
        body: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: TextFormField(
                              validator: requireValue('This field is required'),
                              initialValue: _recipe.title,
                              onChanged: (val) => _recipe.title = val,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Title',
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: TextFormField(
                              validator: requireValue('This field is required'),
                              initialValue: _recipe.duration,
                              onChanged: (val) => _recipe.duration = val,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Time',
                                  hintText: '3-4 hours'),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: TextFormField(
                              validator: requireValue('This field is required'),
                              initialValue: _recipe.source,
                              onChanged: (val) => _recipe.source = val,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Source',
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: TextFormField(
                              validator: requireValue('This field is required'),
                              initialValue: _recipe.servings,
                              onChanged: (val) => _recipe.servings = val,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Servings',
                                  hintText: '4-6'),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: TextFormField(
                              initialValue: _recipe.description,
                              onChanged: (val) => _recipe.description = val,
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Description',
                              ),
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: Card(
                          clipBehavior: Clip.antiAlias,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              TabBar(
                                labelColor: Theme.of(context).primaryColor,
                                tabs: _tabs,
                                controller: _controller,
                              ),
                              Expanded(
                                child: TabBarView(
                                  key: _key,
                                  controller: _controller,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: ListView(
                                        children: [
                                          for (var i
                                              in _recipeState.ingredients)
                                            IngredientWidget(i, () async {
                                              showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return AreYouSure(() async {
                                                      if (i.id != null) {
                                                        bool success =
                                                            await _recipeRepo
                                                                .deleteIngredientById(
                                                                    i.id);
                                                        print('$success');
                                                      }
                                                      _recipeNotifier
                                                          .removeIngredient(i);
                                                      // _recipeNotifier
                                                      //     .refreshRecipe(
                                                      //         _recipe.id);
                                                      Navigator.of(context)
                                                          .pop();
                                                    });
                                                  });
                                            }),
                                          Padding(
                                            padding: const EdgeInsets.all(16.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                ElevatedButton(
                                                    onPressed: () {
                                                      _recipeNotifier
                                                          .addNewIngredient();
                                                    },
                                                    child: Text(
                                                        '+ Add another ingredient')),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: ListView(
                                        children: [
                                          for (var i
                                              in _recipeState.instructions)
                                            InstructionWidget(
                                              i,
                                              () async {
                                                showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return AreYouSure(
                                                          () async {
                                                        if (i.id != null) {
                                                          bool success =
                                                              await _recipeRepo
                                                                  .deleteInstructionById(
                                                                      i.id);
                                                          print('$success');
                                                        }
                                                        _recipeNotifier
                                                            .removeInstruction(
                                                                i);
                                                        // _recipeNotifier
                                                        //     .refreshRecipe(
                                                        //         _recipe.id);
                                                        Navigator.of(context)
                                                            .pop();
                                                      });
                                                    });
                                              },
                                            ),
                                          Padding(
                                            padding: const EdgeInsets.all(16.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                ElevatedButton(
                                                    onPressed: () {
                                                      _recipeNotifier
                                                          .addNewInstruction();
                                                    },
                                                    child: Text(
                                                        '+ Add another instruction')),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: TextFormField(
                                        initialValue: _recipe.notes,
                                        onChanged: (val) => _recipe.notes = val,
                                        keyboardType: TextInputType.multiline,
                                        maxLines: 6,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          )),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text(''),
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
  }
}

class InstructionWidget extends HookWidget {
  final Instruction _instruction;
  final Function() _onDeletePress;
  InstructionWidget(this._instruction, this._onDeletePress);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(
            bottom: 8.0,
            left: 8.0,
            right: 8.0,
          ),
          child: Text('${_instruction.number}'),
        ),
        Expanded(
          flex: 3,
          child: Padding(
            padding: const EdgeInsets.only(
              bottom: 8.0,
              left: 8.0,
              right: 8.0,
            ),
            child: TextFormField(
              initialValue: _instruction.description,
              onChanged: (val) => _instruction.description = val,
              validator: requireValue('Please enter a value'),
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Type a step here',
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: IconButton(
            color: Theme.of(context).primaryColor,
            icon: Icon(Icons.delete),
            onPressed: _onDeletePress,
          ),
        ),
      ],
    );
  }
}

class IngredientWidget extends HookWidget {
  final Ingredient _ingredient;
  final Function() _onDeletePress;
  IngredientWidget(this._ingredient, this._onDeletePress);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: TextFormField(
                initialValue: _ingredient.quantity,
                onChanged: (val) {
                  _ingredient.quantity = val;
                },
                validator: requireValue('This field is required'),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Quantity',
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: TextFormField(
                initialValue: _ingredient.measurement,
                onChanged: (val) {
                  _ingredient.measurement = val;
                },
                validator: requireValue('This field is required'),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Measurement',
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: TextFormField(
                initialValue: _ingredient.description,
                onChanged: (val) {
                  _ingredient.description = val;
                },
                validator: requireValue('This field is required'),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Ingredient',
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: IconButton(
              color: Theme.of(context).primaryColor,
              icon: Icon(Icons.delete),
              onPressed: _onDeletePress,
            ),
          )
        ],
      ),
    );
  }
}
