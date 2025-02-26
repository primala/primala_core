import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_fonts/google_fonts.dart';

class ToggleViewButtons extends HookWidget {
  final Function(bool) onButtonToggled;

  const ToggleViewButtons({
    super.key,
    required this.onButtonToggled,
  });

  @override
  Widget build(BuildContext context) {
    final isCurrentSelected = useState(true);

    return Padding(
      padding: const EdgeInsets.only(top: 10.0, bottom: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildButton(
            text: 'Current',
            isSelected: isCurrentSelected.value,
            onTap: () {
              onButtonToggled(true);
              isCurrentSelected.value = true;
            },
          ),
          const SizedBox(width: 30), // Space between buttons
          _buildButton(
            text: 'Archive',
            isSelected: !isCurrentSelected.value,
            onTap: () {
              onButtonToggled(false);
              isCurrentSelected.value = false;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildButton({
    required String text,
    required bool isSelected,
    required Function onTap,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      width: 120,
      height: 50,
      decoration: BoxDecoration(
        color: isSelected ? Colors.black : Colors.transparent,
        border: Border.all(color: Colors.black, width: 1),
        borderRadius: BorderRadius.circular(30),
      ),
      child: ElevatedButton(
        onPressed: () => onTap(),
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          splashFactory: NoSplash.splashFactory,
          padding: const EdgeInsets.symmetric(vertical: 12.0),
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return FadeTransition(opacity: animation, child: child);
          },
          child: Text(
            text,
            key: ValueKey('$text-$isSelected'),
            style: GoogleFonts.jost(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: isSelected ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
