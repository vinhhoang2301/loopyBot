import 'package:final_project/consts/app_color.dart';
import 'package:final_project/consts/app_routes.dart';
import 'package:flutter/material.dart';

class KBItem extends StatelessWidget {
  const KBItem({
    super.key,
    required this.id,
    required this.kbName,
    required this.createdAt,
    required this.delete,
    required this.isDeleteLoading,
    this.firstAction,
  });

  final String id;
  final String kbName;
  final DateTime createdAt;
  final void Function() delete;
  final bool isDeleteLoading;

  final IconButton? firstAction;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          Navigator.of(context).pushNamed('${AppRoutes.kbDetails}/$id'),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: AppColors.secondaryColor.withOpacity(0.7),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/icon/kb_icon.png',
              height: 64,
              width: 64,
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          kbName,
                          style: const TextStyle(fontSize: 18),
                        ),
                        Row(
                          children: [
                            if (firstAction != null) firstAction!,
                            IconButton(
                              icon: isDeleteLoading
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: AppColors.primaryColor,
                                      ),
                                    )
                                  : const Icon(
                                      Icons.delete_outline,
                                      color: Colors.red,
                                    ),
                              onPressed: () {
                                delete.call();
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                            '${createdAt.month}/${createdAt.day}/${createdAt.year}'),
                      ],
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
