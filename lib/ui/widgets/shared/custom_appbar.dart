import 'package:flutter/material.dart';

class CustomAppbar extends StatelessWidget {
  const CustomAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    final colorTheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: SizedBox(
          width: double.infinity,
          child: Row(
            children: [
              Icon(Icons.movie_outlined, color: colorTheme.primary),
              const SizedBox(width: 5),
              Text('Cinemapedia', style: textTheme.titleMedium),
              const Spacer(),
              IconButton(onPressed: () {
                
              }, icon: const Icon(Icons.search))
            ],
          ),
        ),
      ),
    );
  }
}
