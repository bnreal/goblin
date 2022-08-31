import 'package:flutter/material.dart';

class GoblinCheckbox extends StatefulWidget {
  const GoblinCheckbox({Key? key, required this.label, required this.onChanged})
      : super(key: key);
  final String label;
  final ValueChanged<bool> onChanged;
  @override
  State<GoblinCheckbox> createState() => _GoblinCheckboxState();
}

//带标签的checkbox
class _GoblinCheckboxState extends State<GoblinCheckbox> {
  bool isChecked = false;
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Checkbox(
          value: isChecked,
          onChanged: (newValue) {
            setState(() {
              isChecked = newValue!;
              widget.onChanged(newValue);
            });
          }),
      Text(widget.label),
    ]);
  }
}

//图标选择器：灰色--未选中, 粉红--选中
class GoblinIconCheckBox extends StatefulWidget {
  const GoblinIconCheckBox(
      {Key? key,
      this.toolTip = "",
      this.enabled = true,
      this.initValue = false,
      required this.iconData,
      required this.onClicked})
      : super(key: key);
  final IconData iconData;
  final ValueChanged<bool> onClicked;
  final bool initValue;
  final String? toolTip;
  final bool enabled;
  @override
  State<GoblinIconCheckBox> createState() => _GoblinIconCheckBoxState();
}

class _GoblinIconCheckBoxState extends State<GoblinIconCheckBox> {
  bool value = false;
  @override
  void initState() {
    super.initState();
    value = widget.initValue;
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
        tooltip: widget.toolTip,
        onPressed: () {
          if (widget.enabled) {
            setState(() {
              value = !value;
            });
            widget.onClicked(value);
          }
        },
        icon: Icon(
          widget.iconData,
          color: value ? Colors.pink[300] : Colors.grey,
        ));
  }
}

class GIconCheckBox extends StatelessWidget {
  const GIconCheckBox(
      {Key? key,
      required this.iconData,
      required this.checked,
      required this.onClicked})
      : super(key: key);

  final IconData iconData;
  final bool checked;
  final ValueChanged<bool> onClicked;
  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {
          onClicked(!checked);
        },
        icon: Icon(
          iconData,
          color: checked ? Colors.pink[300] : Colors.grey,
        ));
  }
}
