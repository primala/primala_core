import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class InvitationTextField extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onChange;

  const InvitationTextField({
    super.key,
    required this.controller,
    required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
      ),
      child: Container(
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: Colors.black,
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(30),
          ),
          child: TextField(
            controller: controller,
            onChanged: onChange,
            scrollPadding: EdgeInsets.zero,
            style: GoogleFonts.jost(color: Colors.black),
            decoration: InputDecoration(
              isDense: true,
              border: InputBorder.none,
              hintText: 'search emails here',
              hintStyle: GoogleFonts.jost(color: Colors.white54),
              prefixIcon: Padding(
                padding: const EdgeInsets.all(8),
                child: Image.asset(
                  'assets/groups/magnifying_glass_icon.png',
                  height: 10,
                  width: 10,
                ),
              ),
            ),
          )),
    );
  }
}
