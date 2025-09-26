import 'package:healthy_app/commons.dart';

class RecipePage extends StatelessWidget {
  const RecipePage({super.key});

  @override
  Widget build(BuildContext context) {
    final recipes = {
      "Café da manhã": [
        {
          "title": "Smoothie de Frutas Vermelhas",
          "image":
              "https://images.unsplash.com/photo-1600891964599-f61ba0e24092",
          "description":
              "Bebida nutritiva feita com morango, mirtilo, framboesa e iogurte natural.",
        },
        {
          "title": "Omelete Proteica",
          "image":
              "https://images.unsplash.com/photo-1600891964599-f61ba0e24092",
          "description":
              "Ovos batidos com espinafre, cogumelos e queijo leve, ideal para café da manhã saudável.",
        },
      ],
      "Almoço": [
        {
          "title": "Salada Mediterrânea",
          "image":
              "https://images.unsplash.com/photo-1600891964599-f61ba0e24092",
          "description":
              "Uma salada fresca com tomate, pepino, azeitona e queijo feta. Perfeita para dias quentes.",
        },
        {
          "title": "Frango Grelhado com Legumes",
          "image":
              "https://images.unsplash.com/photo-1600891964599-f61ba0e24092",
          "description":
              "Frango temperado com ervas, acompanhado de legumes grelhados e azeite de oliva.",
        },
      ],
      "Jantar": [
        {
          "title": "Sopa de Legumes",
          "image":
              "https://images.unsplash.com/photo-1600891964599-f61ba0e24092",
          "description":
              "Sopa leve e nutritiva feita com abóbora, cenoura e batata-doce.",
        },
      ],
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text("Receitas"),
        centerTitle: true,
        elevation: 2,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              color: Colors.deepPurple.shade50,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 3,
              margin: const EdgeInsets.only(bottom: 24),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  "Com base na sua rotina, estas são as melhores receitas para encaixar no seu dia a dia:",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.deepPurple.shade900,
                    fontWeight: FontWeight.w500,
                    height: 1.4,
                  ),
                ),
              ),
            ),
            ...recipes.entries.map((entry) {
              final sectionTitle = entry.key;
              final sectionRecipes = entry.value;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    sectionTitle,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Column(
                    children: sectionRecipes.map((recipe) {
                      return GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return RecipeDetailDialog(
                                title: recipe["title"]!,
                                description: recipe["description"]!,
                                imageUrl: recipe["image"]!,
                                youtubeUrl:
                                    "https://www.youtube.com/watch?v=v_cpPMjE0vU", // Example
                              );
                            },
                          );
                        },
                        child: Card(
                          margin: const EdgeInsets.only(bottom: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 5,
                          shadowColor: Colors.deepPurple.shade100,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(16),
                                    ),
                                    child: Image.network(
                                      recipe["image"]!,
                                      height: 180,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Positioned(
                                    top: 8,
                                    right: 8,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.black45,
                                        shape: BoxShape.circle,
                                      ),
                                      padding: const EdgeInsets.all(6),
                                      child: const Icon(
                                        Icons.play_arrow,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(12),
                                child: Text(
                                  recipe["title"]!,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),
                ],
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
