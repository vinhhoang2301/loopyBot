import 'package:final_project/consts/app_color.dart';
import 'package:final_project/models/ai_agent_model.dart';
import 'package:final_project/models/ai_assistant_model.dart';
import 'package:flutter/material.dart';

const aiAgentsList = <AiAgentModel>[
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
    required this.currentModel,
    required this.personalAssistant,
    required this.onModelSelected,
  });

  final dynamic currentModel;
  final List<AiAssistantModel> personalAssistant;
  final Function(dynamic newValue) onModelSelected;

  @override
  State<DropdownModelAI> createState() => _DropdownModelAIState();
}

class _DropdownModelAIState extends State<DropdownModelAI> {
  dynamic _selectedValue;

  @override
  void initState() {
    super.initState();

    _selectedValue = widget.currentModel;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: DropdownButtonFormField<dynamic>(
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
        onChanged: (dynamic newValue) {
          setState(() {
            _selectedValue = newValue;
          });
          widget.onModelSelected(_selectedValue);
        },
        items: [
          if (widget.personalAssistant.isNotEmpty) ...[
            const DropdownMenuItem(
              enabled: false,
              child: Text('AI Assistants'),
            ),
            ...widget.personalAssistant.map<DropdownMenuItem<dynamic>>((AiAssistantModel value) {
              return DropdownMenuItem<dynamic>(
                value: value,
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Image.asset(
                        'assets/icon/chatbot.png',
                        width: 24,
                        height: 24,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      value.assistantName!,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
              );
            }),
          ],
          const DropdownMenuItem(
            enabled: false,
            child: Text('AI Agents'),
          ),
          ...aiAgentsList.map<DropdownMenuItem<dynamic>>((AiAgentModel value) {
            return DropdownMenuItem<dynamic>(
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
          }),
        ],
      ),
    );
  }
}
