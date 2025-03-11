import 'package:flutter/material.dart';

class SlidingSecuritySelector extends StatefulWidget {
  final List<String> labels;
  final ValueChanged<int>? onSelected;
  final int initialIndex;

  const SlidingSecuritySelector({
    super.key,
    required this.labels,
    this.onSelected,
    this.initialIndex = 0,
  });

  @override
  State<SlidingSecuritySelector> createState() =>
      _SlidingSecuritySelectorState();
}

class _SlidingSecuritySelectorState extends State<SlidingSecuritySelector> {
  late int selectedIndex;

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      double buttonWidth = constraints.maxWidth / widget.labels.length;
      return Container(
        height: 35,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Stack(
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              left: selectedIndex * buttonWidth,
              top: 0,
              bottom: 0,
              width: buttonWidth,
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            Row(
              children: List.generate(widget.labels.length, (index) {
                return Expanded(
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        selectedIndex = index;
                      });
                      if (widget.onSelected != null) {
                        widget.onSelected!(index);
                      }
                    },
                    child: Text(
                      widget.labels[index],
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontSize: 14, fontWeight: FontWeight.bold,
                            // color: selectedIndex == index
                            //     ? Colors.white
                            //     : Colors.white70,
                          ),
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      );
    });
  }
}
