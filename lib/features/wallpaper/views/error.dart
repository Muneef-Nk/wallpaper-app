import 'package:flutter/material.dart';

class ErrorScreen extends StatelessWidget {
  final Function() onPressed;
  final String message;

  const ErrorScreen(
      {super.key, required this.onPressed, required this.message});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Oops!',
                style: TextStyle(
                  fontSize: 32.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20.0),
              Text(
                message,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: 40.0),
              Image.asset(
                'assets/error.jpg',
                width: 200.0,
              ),
              SizedBox(height: 40.0),
              InkWell(
                borderRadius: BorderRadius.circular(30),
                onTap: () {
                  onPressed();
                },
                child: Ink(
                  width: 200,
                  height: 45,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.purple,
                  ),
                  child: Center(
                    child: Text(
                      "Retry",
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
