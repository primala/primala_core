import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gradient_borders/gradient_borders.dart';
import 'package:nokhte/app/modules/session/widgets/widgets.dart';
export 'block_text_fields_store.dart';

class BlockTextFields extends HookWidget {
  final BlockTextFieldsStore blockTextFieldsStore = BlockTextFieldsStore();
  BlockTextFields({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Container(
        // width: 350,
        // padding: EdgeInsets.symmetric(horizontal: 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: const GradientBoxBorder(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 0, 0, 0), // Deep Purple
                Color.fromARGB(255, 255, 255, 255), // Light Purple
              ],
              stops: [0, 1],
            ),
          ),
        ),
        child: Stack(children: [
          TextFormField(
            keyboardType: TextInputType.multiline,
            maxLines: null,
            decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: 'Type here...',
              hintStyle: TextStyle(color: Color(0xff606060), fontSize: 12),
              contentPadding:
                  EdgeInsets.only(right: 50, left: 20, top: 10, bottom: 10),
            ),
          ),
          Positioned(
              bottom: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // IconButton(icon: Icon(Icons.camera_alt), onPressed: () {}),
                  IconButton(icon: const Icon(Icons.send), onPressed: () {}),
                ],
              ))
        ]),
      ),
    );

    // return Padding(
    //   child: ExtendedTextField(
    //     cursorColor: Colors.black,
    //     // cursorHeight: 15,
    //     maxLines: null,
    //     textAlignVertical: TextAlignVertical.center,
    //     decoration: const InputDecoration(
    //       border: OutlineInputBorder(
    //         borderRadius: BorderRadius.all(Radius.circular(17)),
    //       ),

    //       // suffixIcon:
    //       //     // onTap: () {
    //       //     //   // sendMessage(_textEditingController.text);
    //       //     //   // _textEditingController.clear();

    //       //     const Icon(Icons.send),

    //       suffix: Padding(
    //         padding: EdgeInsets.all(8.0),
    //         child: Icon(Icons.send),
    //       ),
    //       contentPadding: EdgeInsets.only(left: 20.0, bottom: 12.0),
    //       // contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 2.0),
    //     ),

    //     //textDirection: TextDirection.rtl,

    //     style: GoogleFonts.jost(
    //       color: Colors.black,
    //       fontSize: 16,
    //       fontWeight: FontWeight.w400,
    //     ),
    //   ),
    // );
  }
}
