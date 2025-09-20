import 'package:healthy_app/commons.dart';

class CustomSlider extends StatelessWidget {
  const CustomSlider({
    super.key,
    required this.text,
    required this.sliderValue,
    required this.sliderMax,
    required this.sliderMin,
    required this.sliderDivision,
    required this.sliderOnChanged,
  });

  final String text;
  final double sliderValue;
  final double sliderMax;
  final double sliderMin;
  final int sliderDivision;
  final ValueChanged<double> sliderOnChanged;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text(text),
          Slider(
            value: sliderValue,
            min: sliderMin,
            max: sliderMax,
            divisions: sliderDivision,
            label: sliderValue.round().toString(),
            onChanged: (double value) {
              sliderOnChanged(value);
            },
          ),
        ],
      ),
    );
  }
}

class DaysOfWeekSlider extends StatelessWidget {
  const DaysOfWeekSlider({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final double value;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return CustomSlider(
      text: 'Quantidade de dias por semana',
      sliderValue: value,
      sliderMax: 7,
      sliderMin: 1,
      sliderDivision: 6,
      sliderOnChanged: onChanged,
    );
  }
}
