import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'terminal_controller.dart';
import '../../themes/app_theme.dart';

class TerminalView extends GetView<TerminalController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Terminal'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: GetBuilder<TerminalController>(
        init: TerminalController(),
        builder: (controller) {
          return Column(
            children: [
              Expanded(
                child: Container(
                  color: Colors.black,
                  padding: EdgeInsets.all(8),
                  child: ListView.builder(
                    itemCount: controller.output.length,
                    itemBuilder: (context, index) {
                      return Text(
                        controller.output[index],
                        style: TextStyle(color: Colors.green, fontFamily: 'Courier'),
                      );
                    },
                  ),
                ),
              ),
              Container(
                color: Colors.black,
                padding: EdgeInsets.all(8),
                child: Row(
                  children: [
                    Text('\$_', style: TextStyle(color: Colors.green, fontFamily: 'Courier')),
                    Expanded(
                      child: TextField(
                        controller: controller.inputController,
                        style: TextStyle(color: Colors.white, fontFamily: 'Courier'),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Ingrese un comando',
                          hintStyle: TextStyle(color: Colors.grey[600]),
                        ),
                        onSubmitted: controller.ejecutarComando,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}