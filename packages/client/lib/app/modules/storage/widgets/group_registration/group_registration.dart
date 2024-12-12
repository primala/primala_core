import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nokhte/app/core/hooks/hooks.dart';
import 'package:nokhte/app/core/types/types.dart';
import 'package:nokhte/app/modules/storage/storage.dart';
export 'group_registration_store.dart';

class GroupRegistration extends HookWidget {
  final GroupRegistrationStore store;

  const GroupRegistration({
    super.key,
    required this.store,
  });

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      store.setWidgetVisibility(false);
      return () => store.dispose();
    }, []);

    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    return Observer(builder: (context) {
      return AnimatedOpacity(
        opacity: useWidgetOpacity(store.showWidget),
        duration: Seconds.get(1),
        child: Padding(
          padding: EdgeInsets.only(bottom: bottomPadding * .5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildTextField(
                controller: store.groupNameController,
                placeholder: 'group name',
                // onChanged: store.setGroupName,
                onSubmitted: store.onSubmit,
              ),
              const SizedBox(height: 20),
              _buildTextField(
                controller: store.groupHandleController,
                placeholder: 'handle',
                // onChanged: store.setGroupHandle,
                onSubmitted: store.onSubmit,
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String placeholder,
    // required Function(String) onChanged,
    required Function onSubmitted,
  }) {
    return TextField(
      controller: controller,
      // onChanged: onChanged,
      onSubmitted: (_) {
        if (placeholder == 'handle') {
          onSubmitted();
        }
      },
      textAlign: TextAlign.center,
      style: GoogleFonts.jost(
        color: Colors.white,
        fontSize: 18,
      ),
      decoration: InputDecoration(
        hintText: placeholder,
        hintStyle: GoogleFonts.jost(
          color: Colors.white.withOpacity(0.5),
          fontSize: 18,
        ),
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
        contentPadding: EdgeInsets.zero,
      ),
    );
  }
}
