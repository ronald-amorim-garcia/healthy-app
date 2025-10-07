import 'commons.dart';

void main() {
  runApp(const MyHealthyApp());
}

class MyHealthyApp extends StatelessWidget {
  const MyHealthyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => RoutineProvider()),
      ],
      child: MaterialApp(home: MainHealthyWidget()),
    );
  }
}

class MainHealthyWidget extends StatefulWidget {
  const MainHealthyWidget({super.key});

  @override
  State<MainHealthyWidget> createState() => _MainHealthyState();
}

class _MainHealthyState extends State<MainHealthyWidget> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: Colors.deepPurpleAccent,
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.av_timer_rounded, color: Colors.white),
            icon: Icon(Icons.av_timer_rounded),
            label: 'Rotina',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.food_bank_outlined, color: Colors.white),
            icon: Icon(Icons.food_bank_outlined),
            label: 'Receitas',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.local_restaurant_rounded, color: Colors.white),
            icon: Icon(Icons.local_restaurant_rounded),
            label: 'Restaurantes',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.info_outlined, color: Colors.white,),
            icon: Icon(Icons.info_outlined),
            label: 'Sobre',
          )
        ],
      ),
      body: <Widget>[
        RoutinePage(),
        RecipePage(),
        RestaurantPage(),
        AboutPage()
      ][currentPageIndex],
    );
  }
}
