import 'package:final_project/consts/app_color.dart';
import 'package:final_project/models/ai_agent_model.dart';
import 'package:flutter/material.dart';

const aiAgentsList = [
  AiAgentModel(
    id: 'claude-3-haiku-20240307',
    name: 'Claude 3 Haiku',
    thumbnail: 'assets/icon/claude_3_haiku.png',
  ),
  AiAgentModel(
    id: 'claude-3-sonnet-20240229',
    name: 'Claude 3 Sonnet',
    thumbnail: 'assets/icon/claude_3_sonnet.png',
  ),
  AiAgentModel(
    id: 'gemini-1.5-flash-latest',
    name: 'Gemini 1.5 Flash',
    thumbnail: 'assets/icon/gemini_flash.png',
  ),
  AiAgentModel(
    id: 'gemini-1.5-pro-latest',
    name: 'Gemini 1.5 Pro',
    thumbnail: 'assets/icon/gemini_pro.png',
  ),
  AiAgentModel(
    id: 'gpt-4o',
    name: 'GPT-4o',
    thumbnail: 'assets/icon/gpt_4o.png',
  ),
  AiAgentModel(
    id: 'gpt-4o-mini',
    name: 'GPT-4o mini',
    thumbnail: 'assets/icon/gpt_4o_mini.png',
  ),
];

class DropdownModelAI extends StatefulWidget {
  const DropdownModelAI({
    super.key,
    this.onModelSelected,
  });
  final Function(AiAgentModel)? onModelSelected;

  @override
  State<DropdownModelAI> createState() => _DropdownModelAIState();
}

class _DropdownModelAIState extends State<DropdownModelAI> {
  AiAgentModel? _selectedValue = const AiAgentModel(
    id: 'gpt-4o-mini',
    name: 'GPT-4o mini',
    thumbnail: 'assets/icon/gpt_4o_mini.png',
  );

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 195,
      height: 40,
      child: DropdownButtonFormField<AiAgentModel>(
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
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        ),
        dropdownColor: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(12),
        onChanged: (AiAgentModel? newValue) {
          setState(() => _selectedValue = newValue);

          if (newValue != null && widget.onModelSelected != null) {
            widget.onModelSelected!(newValue);
          }
        },
        items: aiAgentsList
            .map<DropdownMenuItem<AiAgentModel>>((AiAgentModel value) {
          return DropdownMenuItem<AiAgentModel>(
            value: value,
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image.asset(
                    value.thumbnail,
                    width: 24,
                    height: 24,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  value.name,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
