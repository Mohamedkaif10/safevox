import 'package:flutter/material.dart';

class VoiceActivationPage extends StatefulWidget {
  @override
  _VoiceActivationPageState createState() => _VoiceActivationPageState();
}

class _VoiceActivationPageState extends State<VoiceActivationPage> {
  // Sample data for codewords
  final List<Map<String, String>> codewords = [
    {
      'codeword': 'Help me now',
      'message': 'Emergency Alert. [Your Name] needs immediate assistance',
      'isDefault': 'true',
    },
    {
      'codeword': 'Grass is Green',
      'message': 'Custom Message..',
      'isDefault': 'false',
    },
    {
      'codeword': 'Enter the codeword',
      'message': 'Custom Message..',
      'isDefault': 'false',
    },
  ];

  // Controllers for editing codewords and messages
  final List<TextEditingController> codewordControllers = [];
  final List<TextEditingController> messageControllers = [];

  @override
  void initState() {
    super.initState();
    // Initialize controllers for each codeword and message
    for (var codeword in codewords) {
      codewordControllers
          .add(TextEditingController(text: codeword['codeword']));
      messageControllers.add(TextEditingController(text: codeword['message']));
    }
  }

  @override
  void dispose() {
    // Dispose of all controllers
    for (var controller in codewordControllers) {
      controller.dispose();
    }
    for (var controller in messageControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  // Add a new codeword
  void _addCodeword() {
    setState(() {
      codewords.add({
        'codeword': 'Enter the codeword',
        'message': 'Custom Message..',
        'isDefault': 'false',
      });
      codewordControllers
          .add(TextEditingController(text: 'Enter the codeword'));
      messageControllers.add(TextEditingController(text: 'Custom Message..'));
    });
  }

  // Remove a codeword
  void _removeCodeword(int index) {
    setState(() {
      codewords.removeAt(index);
      codewordControllers[index].dispose();
      messageControllers[index].dispose();
      codewordControllers.removeAt(index);
      messageControllers.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Dark background as in the screenshot
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            // Handle back button press
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Enter codewords',
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Subtitle
            Text(
              'Voice activated codewords',
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
            SizedBox(height: 16),
            // List of codewords
            Expanded(
              child: ListView.builder(
                itemCount: codewords.length,
                itemBuilder: (context, index) {
                  final isDefault = codewords[index]['isDefault'] == 'true';
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors
                            .grey[900], // Dark grey background for each card
                        borderRadius: BorderRadius.circular(8),
                        border: isDefault
                            ? Border.all(color: Colors.blue, width: 2)
                            : null,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Codeword input
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: codewordControllers[index],
                                  enabled:
                                      !isDefault, // Disable editing for default codeword
                                  style: TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Enter the codeword',
                                    hintStyle: TextStyle(color: Colors.white54),
                                  ),
                                  onChanged: (value) {
                                    codewords[index]['codeword'] = value;
                                  },
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.mic, color: Colors.white),
                                onPressed: () {
                                  // Handle voice input (e.g., integrate speech-to-text)
                                  print(
                                      'Voice input for codeword ${index + 1}');
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.share, color: Colors.white),
                                onPressed: () {
                                  // Handle share action
                                  print('Share codeword ${index + 1}');
                                },
                              ),
                              if (!isDefault) // Show delete icon only for non-default codewords
                                IconButton(
                                  icon: Icon(Icons.delete, color: Colors.white),
                                  onPressed: () {
                                    _removeCodeword(index);
                                  },
                                ),
                            ],
                          ),
                          SizedBox(height: 8),
                          // Custom message input
                          TextField(
                            controller: messageControllers[index],
                            enabled:
                                !isDefault, // Disable editing for default message
                            style: TextStyle(color: Colors.white70),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Custom Message..',
                              hintStyle: TextStyle(color: Colors.white54),
                            ),
                            onChanged: (value) {
                              codewords[index]['message'] = value;
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            // Add new codeword button
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                icon: Icon(
                  Icons.add_circle,
                  color: Colors.green,
                  size: 40,
                ),
                onPressed: _addCodeword,
              ),
            ),
            // Save button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Handle save action (e.g., save to database or local storage)
                  print('Saved codewords: $codewords');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green, // Button color
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'Save',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
