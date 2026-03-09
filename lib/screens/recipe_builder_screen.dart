import 'package:flutter/material.dart';

class RecipeBuilderScreen extends StatefulWidget {
  const RecipeBuilderScreen({super.key});

  @override
  State<RecipeBuilderScreen> createState() => _RecipeBuilderScreenState();
}

class _RecipeBuilderScreenState extends State<RecipeBuilderScreen> {
  int currentStep = 0;

  String mealType = '';
  List<String> dietaryPreferences = [];
  List<String> allergies = [];
  String servingSize = '';
  List<String> ingredients = [];

  final List<String> allergenOptions = [
    'Nuts',
    'Shellfish',
    'Eggs',
    'Dairy',
    'Wheat',
    'Soy'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFFFAF5), Color(0xFFFFE3C1)],
          ),
        ),
        child: Stack(
          children: [
            // Progress and Back Button
            Positioned(
              left: 16,
              right: 16,
              top: 54,
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Expanded(
                    child: Container(
                      height: 12,
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: const LinearProgressIndicator(
                          value: 0.8,
                          backgroundColor: Colors.white,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Color(0xFF33985B)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Main Content
            Positioned(
              left: 16,
              right: 16,
              top: 100,
              bottom: 90,
              child: _buildCurrentStep(),
            ),

            // Generate Recipe Button
            Positioned(
              left: 16,
              right: 16,
              bottom: 40,
              child: ElevatedButton(
                onPressed: () {/* Generate Recipe */},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF48600),
                  foregroundColor: const Color(0xFF191919),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.auto_awesome, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Generate Recipe',
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: 'DM Sans',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentStep() {
    switch (currentStep) {
      case 0:
        return _buildMealTypeStep();
      case 1:
        return _buildDietaryPreferencesStep();
      case 2:
        return _buildAllergiesStep();
      case 3:
        return _buildServingSizeStep();
      case 4:
        return _buildIngredientsStep();
      default:
        return _buildConfirmationScreen();
    }
  }

  Widget _buildMealTypeStep() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("What meal are you making today?",
            style: TextStyle(fontSize: 20)),
        const SizedBox(height: 20),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            _buildVisualButton("🥞 Breakfast", "Breakfast"),
            _buildVisualButton("🥗 Lunch", "Lunch"),
            _buildVisualButton("🍝 Dinner", "Dinner"),
            _buildVisualButton("🍪 Snack/Dessert", "Snack/Dessert"),
          ],
        ),
      ],
    );
  }

  Widget _buildDietaryPreferencesStep() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Do you have any specific dietary needs?",
            style: TextStyle(fontSize: 20)),
        const SizedBox(height: 20),
        Column(
          children: [
            _buildToggleOption("Vegetarian"),
            _buildToggleOption("Vegan"),
            _buildToggleOption("Gluten-Free"),
            _buildToggleOption("Dairy-Free"),
            ListTile(
              title: const Text("Other"),
              trailing: const Icon(Icons.edit),
              onTap: () {
                _showInputDialog("Enter other dietary restrictions", (value) {
                  setState(() {
                    dietaryPreferences.add(value);
                  });
                });
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAllergiesStep() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Do you have any food allergies?",
            style: TextStyle(fontSize: 20)),
        const SizedBox(height: 20),
        Column(
          children: allergenOptions.map((allergen) {
            return _buildCheckboxOption(allergen);
          }).toList(),
        ),
        ElevatedButton(
          onPressed: () {
            setState(() {
              allergies.clear();
              currentStep++;
            });
          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
          child: const Text("No Allergies"),
        ),
      ],
    );
  }

  Widget _buildServingSizeStep() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("How many people are you serving?",
            style: TextStyle(fontSize: 20)),
        const SizedBox(height: 20),
        Wrap(
          spacing: 10,
          children: [
            _buildPillButton("🧑‍🍳 1", "1"),
            _buildPillButton("👩‍🍳 2", "2"),
            _buildPillButton("👨‍👩‍👧‍👦 4", "4"),
            _buildPillButton("🍽️ 8+", "8+"),
          ],
        ),
      ],
    );
  }

  Widget _buildIngredientsStep() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Which ingredients would you like to include?",
            style: TextStyle(fontSize: 20)),
        const SizedBox(height: 20),
        Wrap(
          spacing: 10,
          children: ingredients.map((ingredient) {
            return Chip(label: Text(ingredient));
          }).toList(),
        ),
        ElevatedButton(
          onPressed: () {
            _showInputDialog("Enter an ingredient", (value) {
              setState(() {
                ingredients.add(value);
              });
            });
          },
          child: const Text("Add Ingredient"),
        ),
        ElevatedButton(
          onPressed: () {
            setState(() {
              currentStep++;
            });
          },
          child: const Text("I’m not sure—Surprise me!"),
        ),
      ],
    );
  }

  Widget _buildConfirmationScreen() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Summary",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        Text("Meal: $mealType"),
        Text("Dietary Needs: ${dietaryPreferences.join(', ')}"),
        Text("Allergies: ${allergies.join(', ')}"),
        Text("Serving Size: $servingSize"),
        Text("Ingredients: ${ingredients.join(', ')}"),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            // Navigate to result or generate recipe
          },
          child: const Text("Generate Recipe 🔥"),
        ),
      ],
    );
  }

  Widget _buildVisualButton(String label, String value) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          mealType = value;
          currentStep++;
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.orange,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      child: Text(label),
    );
  }

  Widget _buildToggleOption(String option) {
    final isSelected = dietaryPreferences.contains(option);
    return SwitchListTile(
      title: Text(option),
      value: isSelected,
      onChanged: (selected) {
        setState(() {
          if (selected) {
            dietaryPreferences.add(option);
          } else {
            dietaryPreferences.remove(option);
          }
        });
      },
    );
  }

  Widget _buildCheckboxOption(String allergen) {
    final isSelected = allergies.contains(allergen);
    return CheckboxListTile(
      title: Text(allergen),
      value: isSelected,
      onChanged: (selected) {
        setState(() {
          if (selected == true) {
            allergies.add(allergen);
          } else {
            allergies.remove(allergen);
          }
        });
      },
    );
  }

  Widget _buildPillButton(String label, String value) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          servingSize = value;
          currentStep++;
        });
      },
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: Colors.orange,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      ),
      child: Text(label),
    );
  }

  void _showInputDialog(String title, Function(String) onSubmitted) {
    showDialog(
      context: context,
      builder: (context) {
        final controller = TextEditingController();
        return AlertDialog(
          title: Text(title),
          content: TextField(
            controller: controller,
          ),
          actions: [
            TextButton(
              onPressed: () {
                onSubmitted(controller.text);
                Navigator.pop(context);
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }
}
