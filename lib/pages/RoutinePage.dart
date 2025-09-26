import 'package:healthy_app/commons.dart';

class RoutinePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final routine = Provider.of<RoutineProvider>(context);
    final theme = Theme.of(context);

    void submitForm() {
      String message = "";

      if (routine.college) {
        message +=
        "Faculdade/escola: ${routine.daysPerWeekCollege.round()} dias/semana\n";
      }
      if (routine.work) {
        message += "Trabalho: ${routine.daysPerWeekWork.round()} dias/semana\n";
      }
      if (routine.physicalActivity) {
        message +=
        "Atividade física: ${routine.daysPerWeekActivity.round()} dias/semana\n";
      }

      if (message.isEmpty) message = "Nenhuma atividade selecionada";

      showDialog(
        context: context,
        builder: (context) => Dialog(
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.check_circle, color: theme.colorScheme.secondary, size: 60),
                const SizedBox(height: 16),
                Text(
                  "Rotina Salva!",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.secondary),
                ),
                const SizedBox(height: 12),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16, color: Colors.black87),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text(
                      "Fechar",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    Widget buildActivityCard({
      required String label,
      required bool value,
      required ValueChanged<bool> onChanged,
      Widget? slider,
    }) {
      return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 3,
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              LabeledCheckBox(
                label: label,
                padding: EdgeInsets.zero,
                value: value,
                onChanged: onChanged,
              ),
              if (value) slider ?? const SizedBox.shrink(),
            ],
          ),
        ),
      );
    }

    Widget buildSimpleCard({
      required String label,
      Widget? slider,
    }) {
      return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 3,
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: theme.textTheme.titleMedium),
              ?slider,
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Rotina'),
        centerTitle: true,
        elevation: 2,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              'Informe o que você realiza na sua semana para que possamos recomendar sugestões de refeições:',
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            // Activity Cards with your custom sliders
            buildActivityCard(
              label: 'Faculdade ou escola',
              value: routine.college,
              onChanged: routine.setCollege,
              slider: DaysOfWeekSlider(
                  value: routine.daysPerWeekCollege,
                  onChanged: routine.setDaysPerWeekCollege),
            ),
            buildActivityCard(
              label: 'Trabalho',
              value: routine.work,
              onChanged: routine.setWork,
              slider: DaysOfWeekSlider(
                  value: routine.daysPerWeekWork,
                  onChanged: routine.setDaysPerWeekWork),
            ),
            buildActivityCard(
              label: 'Atividade física',
              value: routine.physicalActivity,
              onChanged: routine.setPhysicalActivity,
              slider: DaysOfWeekSlider(
                  value: routine.daysPerWeekActivity,
                  onChanged: routine.setDaysPerWeekActivity),
            ),

            // Eating habits
            buildSimpleCard(
              label: 'Você costuma:',
              slider: Column(
                children: [
                  RadioGroup<LunchOption>(
                    groupValue: routine.eatingHabits,
                    onChanged: (LunchOption? value) {
                      routine.setEatingHabits(value!);
                    },
                    child:
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListTile(
                              title: const Text('Não informar'),
                              leading: Radio<LunchOption>(value: LunchOption.none),
                            ),
                            ListTile(
                              title: const Text('Cozinhar em casa'),
                              leading: Radio<LunchOption>(value: LunchOption.home),
                            ),
                            ListTile(
                              title: const Text('Pedir delivery'),
                              leading: Radio<LunchOption>(value: LunchOption.delivery),
                            ),
                            ListTile(
                              title: const Text('Comer em restaurante'),
                              leading: Radio<LunchOption>(value: LunchOption.dineIn),
                            ),
                          ]
                      ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton.icon(
              onPressed: submitForm,
              icon: const Icon(Icons.check_circle_outline),
              label: Text('Enviar rotina', style: TextStyle(color: theme.colorScheme.onPrimary)),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                backgroundColor: theme.colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
