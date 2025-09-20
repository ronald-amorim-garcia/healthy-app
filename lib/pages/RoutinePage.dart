import 'package:healthy_app/commons.dart';

class RoutinePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final routine = Provider.of<RoutineProvider>(context);

    void submitForm() {
      String message = "";

      if (routine.college) {
        message += "Faculdade/escola: ${routine.daysPerWeekCollege.round()} dias por semana\n";
      }
      if (routine.work) {
        message += "Trabalho: ${routine.daysPerWeekWork.round()} dias por semana\n";
      }
      if (routine.physicalActivity) {
        message +=
        "Atividade física: ${routine.daysPerWeekActivity.round()} dias por semana\n";
      }
      if (message.isEmpty) {
        message = "Nenhuma atividade selecionada";
      }

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.check_circle, color: Colors.green, size: 60),

                  const SizedBox(height: 16),
                  Text(
                    "Rotina Salva!",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[700],
                    ),
                  ),

                  const SizedBox(height: 12),
                  Text (
                    message,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),

                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text(
                        "Fechar",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text('Organize sua rotina')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Informe o que você realiza na sua semana '
                  'para que seja possível recomendar sugestões de refeições:',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 20),

            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    LabeledCheckBox(
                      label: 'Faculdade ou escola',
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      value: routine.college,
                      onChanged: (bool newValue) {
                        routine.setCollege(newValue);
                      },
                    ),
                    if (routine.college)
                      DaysOfWeekSlider(
                        value: routine.daysPerWeekCollege,
                        onChanged: (double value) {
                          routine.setDaysPerWeekCollege(value);
                        },
                      ),

                    Divider(),

                    LabeledCheckBox(
                      label: 'Trabalho',
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      value: routine.work,
                      onChanged: (bool newValue) {
                        routine.setWork(newValue);
                      },
                    ),
                    if (routine.work)
                      DaysOfWeekSlider(
                        value: routine.daysPerWeekWork,
                        onChanged: (double value) {
                          routine.setDaysPerWeekWork(value);
                        },
                      ),

                    Divider(),

                    LabeledCheckBox(
                      label: 'Atividade física',
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      value: routine.physicalActivity,
                      onChanged: (bool newValue) {
                        routine.setPhysicalActivity(newValue);
                      },
                    ),
                    if (routine.physicalActivity)
                      DaysOfWeekSlider(
                        value: routine.daysPerWeekActivity,
                        onChanged: (double value) {
                          routine.setDaysPerWeekActivity(value);
                        },
                      ),

                    Divider(),

                    ElevatedButton.icon(
                      onPressed: submitForm,
                      icon: Icon(Icons.check_circle_outline),
                      label: Text('Enviar rotina'),
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
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
}