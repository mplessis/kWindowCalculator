import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Surface d'une fenêtre",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF44618c)),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: "Surface d'une fenêtre"),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _formKey = GlobalKey<FormState>();
  final _focus = FocusNode();
  final _focusWidth = FocusNode();

  final TextEditingController lengthController = TextEditingController();
  final TextEditingController widthController = TextEditingController();
  String surface = "";
  bool isMillimeter = false;

  @override
  void initState() {
    super.initState();
    _focus.addListener(() {
      if (!_focus.hasFocus) {
        _formKey.currentState!.validate();
      }
    });

    _focusWidth.addListener(() {
      if (!_focusWidth.hasFocus) {
        _formKey.currentState!.validate();
      }
    });
  }

  void calculateSurface() {

    if(isInputValuesInvalid()) {
      showOkAlertDialog(
          context: context,
          title: 'Erreur de saisie',
          message:
          'Veuillez entrer des valeurs pour la longueur et la largeur.');
      return;
    }

    double length = double.parse(lengthController.text);
    double width = double.parse(widthController.text);

    setState(() {
      if (isMillimeter) {
        length /= 1000;
        width /= 1000;
      } else {
        length /= 100;
        width /= 100;
      }
      surface = (length * width).toStringAsFixed(2);
    });
  }

  bool isInputValuesInvalid() => lengthController.text.isEmpty || widthController.text.isEmpty;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: <Widget>[
            _buildSwitchToDefineUnit(),
            _buildForm(),
            Padding(
              padding: const EdgeInsets.only(top: 30.0),
              child: ElevatedButton(
                onPressed: calculateSurface,
                child: const Text('Calculer la surface'),
              ),
            ),
            Expanded(
                child: Center(
                    child: Text('Surface de la fenêtre : $surface m²',
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary)))),
          ],
        ),
      ),
    );
  }

  String displayUnit() => isMillimeter ? 'mm' : 'cm';

  Widget _buildSwitchToDefineUnit(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text('Centimètres',
            style: isMillimeter
                ? const TextStyle(fontSize: 16)
                : TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Theme.of(context).colorScheme.primary)),
        Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 15.0),
          child: Switch(
              value: isMillimeter,
              onChanged: (value) {
                setState(() {
                  isMillimeter = value;
                });
              }),
        ),
        Text('Millimètres',
            style: isMillimeter
                ? TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Theme.of(context).colorScheme.primary)
                : const TextStyle(fontSize: 16)),
      ],
    );
  }

  Widget _buildForm(){
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: TextFormField(
              focusNode: _focus,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez entrer une valeur pour la longueur';
                }
                return null;
              },
              controller: lengthController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  labelText: 'Longeur (${displayUnit()})'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: TextFormField(
              focusNode: _focusWidth,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez entrer une valeur pour la largeur';
                }
                return null;
              },
              controller: widthController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  labelText: 'Largeur (${displayUnit()})'),
            ),
          ),
        ],
      ),
    );
  }
}
