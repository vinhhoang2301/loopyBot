import 'package:flutter/material.dart';

class DropdownModelAI extends StatefulWidget {
  const DropdownModelAI({super.key});

  @override
  State<DropdownModelAI> createState() => _DropdownModelAIState();
}

class _DropdownModelAIState extends State<DropdownModelAI> {
  ModelAIItem? _selectedValue;
  final List<ModelAIItem> _items = const [
    ModelAIItem(modalName: 'GPT-3.5'),
    ModelAIItem(modalName: 'GPT-4'),
    ModelAIItem(modalName: 'Claude 2'),
    ModelAIItem(modalName: 'Llama 2'),
    ModelAIItem(modalName: 'Bard'),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      height: 40,
      child: DropdownButtonFormField<ModelAIItem>(
        value: _selectedValue,
        hint: const Text('Select an item'),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey[200],
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(24.0),
            borderSide: const BorderSide(color: Colors.transparent),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(24.0),
            borderSide: const BorderSide(color: Colors.transparent),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
        ),
        dropdownColor: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(12),
        onChanged: (ModelAIItem? newValue) {
          setState(() {
            _selectedValue = newValue;
          });
        },
        items: _items.map<DropdownMenuItem<ModelAIItem>>((ModelAIItem value) {
          return DropdownMenuItem<ModelAIItem>(
            value: value,
            child: ModelAIItem(modalName: value.modalName),
          );
        }).toList(),
      ),
    );
  }
}

class ModelAIItem extends StatelessWidget {
  const ModelAIItem({
    super.key,
    required this.modalName,
  });

  final String modalName;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(
          'assets/icon/kb_icon.png',
          width: 32,
          height: 32,
        ),
        const SizedBox(width: 8),
        Text(
          modalName,
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ],
    );
  }
}
