import 'package:flutter/material.dart';

///自定义简单DropDownButton
class GoblinDropDown extends StatefulWidget {
  const GoblinDropDown(
      {Key? key,
      required this.dropDownItemTexts,
      this.initIndex = 0,
      this.onChanged})
      : super(key: key);
  final List<String> dropDownItemTexts;
  final ValueChanged<String>? onChanged; //注意类型为可空，构造函数里才可以不加required
  final int initIndex;

  @override
  State<GoblinDropDown> createState() => _GoblinDropDownState();
}

class _GoblinDropDownState extends State<GoblinDropDown> {
  String dropdownValue = "";
  @override
  void initState() {
    super.initState();
    dropdownValue = widget.dropDownItemTexts[widget.initIndex];
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      verticalDirection: VerticalDirection.up,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        const Text("同时下载："),
        SizedBox(
          width: 50,
          child: DropdownButtonHideUnderline(
            //外面包裹一层，隐去默认的下划线
            child: DropdownButton<String>(
              value: dropdownValue,
              alignment: AlignmentDirectional.center,
              icon: const Icon(Icons.arrow_drop_down),
              style: const TextStyle(color: Colors.blueGrey),
              hint: Center(
                child: Text(dropdownValue),
              ),
              items: widget.dropDownItemTexts
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Center(child: Text(value)),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  dropdownValue = newValue!; //须做非空断言
                  widget.onChanged!(newValue);
                });
              },
            ),
          ),
        )
      ],
    );
  }
}
