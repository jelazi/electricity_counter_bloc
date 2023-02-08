// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'edit_dialog.dart';

class DeviceRulesDialog extends StatefulWidget {
  // DeviceRules deviceRules;
  DeviceRulesDialog({
    Key? key,
    //   required this.deviceRules,
  }) : super(key: key);

  @override
  State<DeviceRulesDialog> createState() => _DeviceRulesDialogState();
}

class _DeviceRulesDialogState extends State<DeviceRulesDialog> {
  String selectResolution = 'FullHD';

  List<String> listResolution = ['FullHD', '4K'];
  String selectFps = '30';
  List<String> listFps = ['30', '60'];
  @override
  Widget build(BuildContext context) {
    return Container();
    //TODO
    /* TextEditingController idController =
        TextEditingController(text: widget.deviceRules.deviceId);
    if (widget.deviceRules.maxResolution.isNotEmpty) {
      selectResolution = widget.deviceRules.maxResolution;
    }
    if (widget.deviceRules.maxFps.isNotEmpty) {
      selectFps = widget.deviceRules.maxFps;
    }
    return EditDialog(
      title: 'createDeviceRules'.tr,
      height: 300,
      width: 400,
      okClick: () {
        if (widget.deviceRules.deviceId.isEmpty && idController.text.isEmpty) {
          Get.snackbar('idDevice', 'id is Empty'.tr);
          return;
        }
        DeviceRules deviceRules = DeviceRules(
            deviceId: widget.deviceRules.deviceId.isEmpty
                ? idController.text
                : widget.deviceRules.deviceId,
            maxResolution: selectResolution,
            maxFps: selectFps);
        Get.find<SettingsController>().updateDeviceRules(deviceRules);
        Get.find<SettingsController>().update();
      },
      widgetContent: SizedBox(
          width: 300,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('idDevice'.tr),
                  widget.deviceRules.deviceId.isEmpty
                      ? Row(
                          children: [
                            SizedBox(
                              width: 150,
                              child: TextField(
                                controller: idController,
                              ),
                            ),
                          ],
                        )
                      : SizedBox(
                          height: 40,
                          child: Text(widget.deviceRules.deviceId),
                        ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('maxFps'.tr),
                  SizedBox(
                    width: 150,
                    child: DropdownButtonFormField(
                      value: selectFps,
                      icon: const Icon(Icons.arrow_back),
                      elevation: 16,
                      style: const TextStyle(color: Colors.black),
                      onChanged: (String? newValue) {
                        selectFps = newValue ?? selectFps;
                      },
                      items:
                          listFps.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('maxResolution'.tr),
                  SizedBox(
                    width: 150,
                    child: DropdownButtonFormField(
                      value: selectResolution,
                      icon: const Icon(Icons.arrow_back),
                      elevation: 16,
                      style: const TextStyle(color: Colors.black),
                      onChanged: (String? newValue) {
                        selectResolution = newValue ?? selectResolution;
                      },
                      items: listResolution
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              )
            ],
          )),
    );*/
  }
}
