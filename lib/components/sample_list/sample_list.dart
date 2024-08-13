import 'package:flutter/material.dart';

class CardList extends StatefulWidget {
  final Future<void> Function() onTap;
  final String? mainText;
  final String? subText;

  const CardList({
      super.key,
      required this.onTap,
      this.mainText,
      this.subText,
    });

  @override
  State<CardList> createState() => _CardListState();
}

class _CardListState extends State<CardList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 115,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 234, 232, 232),
        borderRadius: BorderRadius.circular(10.0),
      ),
      margin: const EdgeInsets.symmetric(
        vertical: 10.0,
        horizontal: 25.0,
      ),
      child: InkWell(
        splashColor: Colors.blue.withAlpha(30),
        onTap: () async {
          await widget.onTap();
        },
        child: Column(
          children: [
            SizedBox(
              height: 10.0,
            ),
            ListTile(
              title: widget.mainText != null
              ? Text(
                widget.mainText!,
                style: const TextStyle(
                  fontSize: 18.0,
                  color: Colors.black54,
                ),
              )
              : null,
              subtitle: widget.subText != null
              ? Text(
                widget.subText!,
                style: const TextStyle(
                  fontSize: 13.0,
                  color: Colors.black54,
                ),
              )
              : null,
            )
          ],
        ),
      ),
    );
  }
}
