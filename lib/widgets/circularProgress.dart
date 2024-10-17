import 'package:flutter/material.dart';

class CircularProgress extends StatefulWidget {
  const CircularProgress({super.key});

  @override
  State<CircularProgress> createState() => _CircularProgressState();
}

class _CircularProgressState extends State<CircularProgress> {
  double progress = 0.0;
   
   
  
    
        // onReceiveProgress: (received, total) {
        //   if (total != -1) {
        //     setState(() {
        //       progress = (received / total) * 100;
        //     });
        //   }
        
    


  
  @override
  Widget build(BuildContext context) {
    var progress=0;
    return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 100,
                    width: 100,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CircularProgressIndicator(
                          value: progress / 100,
                          backgroundColor: Colors.grey[300],
                          color: Colors.blue,
                          strokeWidth: 8,
                        ),
                        Text(
                          '${progress.toStringAsFixed(0)}%',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Loading...',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            );
  }
}