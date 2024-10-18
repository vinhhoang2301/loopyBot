import 'package:final_project/consts/app_color.dart';
import 'package:flutter/material.dart';

class DropdownModelAI extends StatefulWidget {
  const DropdownModelAI({super.key});

  @override
  State<DropdownModelAI> createState() => _DropdownModelAIState();
}

class _DropdownModelAIState extends State<DropdownModelAI> {
  ModelAIItem? _selectedValue;

  // todo: fetch from server
  final List<ModelAIItem> _items = const [
    ModelAIItem(
      modalName: 'GPT-4o mini',
      iconPath: 'assets/icon/gpt_4o_mini.png',
    ),
    ModelAIItem(
      modalName: 'GPT-4o',
      iconPath: 'assets/icon/gpt_4o.png',
    ),
    ModelAIItem(
      modalName: 'Gemini 1.5 Flash',
      iconPath: 'assets/icon/gemini_flash.png',
    ),
    ModelAIItem(
      modalName: 'Gemini 1.5 Pro',
      iconPath: 'assets/icon/gemini_pro.png',
    ),
    ModelAIItem(
      modalName: 'Claude 3 Haiku',
      iconPath: 'assets/icon/claude_3_haiku.png',
    ),
    ModelAIItem(
      modalName: 'Claude 3 Sonnet',
      iconPath: 'assets/icon/claude_3_sonnet.png',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 195,
      height: 40,
      child: DropdownButtonFormField<ModelAIItem>(
        value: _selectedValue,
        hint: const Text('Select an item'),
        decoration: InputDecoration(
          filled: true,
          fillColor: AppColors.backgroundColor2,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(24.0),
            borderSide: const BorderSide(color: Colors.transparent),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(24.0),
            borderSide: const BorderSide(color: Colors.transparent),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
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
            child: ModelAIItem(
              modalName: value.modalName,
              iconPath: value.iconPath,
            ),
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
    required this.iconPath,
  });

  final String modalName;
  final String iconPath;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: Image.asset(
            iconPath,
            width: 24,
            height: 24,
          ),
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
