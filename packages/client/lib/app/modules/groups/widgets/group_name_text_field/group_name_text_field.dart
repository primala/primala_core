import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/groups/groups.dart';
export 'group_name_text_field_store.dart';

class GroupNameTextField extends StatelessWidget {
  final GroupNameTextFieldStore store;

  const GroupNameTextField({
    super.key,
    required this.store,
  });

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 200,
            decoration: BoxDecoration(
              border: Border.all(
                color: store.hasError ? Colors.red : Colors.transparent,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextField(
              controller: store.controller,
              enabled: store.isEnabled,
              onSubmitted: store.onSubmit,
              onChanged: store.validateGroupName,
              style: GoogleFonts.jost(color: Colors.white),
              cursorColor: Colors.white,
              decoration: InputDecoration(
                hintText: 'Group Name',
                hintStyle:
                    GoogleFonts.jost(color: Colors.white.withOpacity(0.5)),
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
                fillColor: Colors.black.withOpacity(.6),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 1,
                  // vertical: 12.0,
                ),
                // border: InputBorder.none,
              ),
            ),
          ),
          if (store.hasError)
            Padding(
              padding: const EdgeInsets.only(left: 0, top: 4.0),
              child: Jost(
                store.errorMessage,
                fontColor: Colors.red,
                fontSize: 12.0,
              ),
            ),
        ],
      ),
    );
  }
}
