import 'package:flutter/material.dart';

class RecordingsPage extends StatefulWidget {
  @override
  _RecordingsPageState createState() => _RecordingsPageState();
}

class _RecordingsPageState extends State<RecordingsPage> {
  // Sample data for recordings
  final List<Map<String, String>> recordings = [
    {
      'timestamp': '2025-09-10_16:21:37',
      'name': 'Recording 1',
    },
    {
      'timestamp': '2024-10-10_23:21:37',
      'name': 'Recording 2',
    },
    {
      'timestamp': '2024-05-02_02:21:37',
      'name': 'Recording 3',
    },
    {
      'timestamp': '2025-01-28_19:21:37',
      'name': 'Recording 4',
    },
  ];

  // Track which recording is currently playing
  int? _playingIndex;

  // Remove a recording
  void _removeRecording(int index) {
    setState(() {
      recordings.removeAt(index);
      if (_playingIndex == index) {
        _playingIndex = null; // Stop playing if the removed recording was playing
      } else if (_playingIndex != null && _playingIndex! > index) {
        _playingIndex = _playingIndex! - 1; // Adjust the playing index if necessary
      }
    });
  }

  // Toggle play/pause for a recording
  void _togglePlay(int index) {
    setState(() {
      if (_playingIndex == index) {
        _playingIndex = null; // Pause if the same recording is tapped
      } else {
        _playingIndex = index; // Play the selected recording
      }
    });
    // In a real app, you would integrate an audio player here (e.g., using the `audioplayers` package)
    print('Toggled play/pause for ${recordings[index]['name']}');
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
          'Recordings',
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: recordings.length,
          itemBuilder: (context, index) {
            final isPlaying = _playingIndex == index;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[900], // Dark grey background for each card
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    // Play/Pause buttons
                    IconButton(
                      icon: Icon(
                        isPlaying ? Icons.pause : Icons.play_arrow,
                        color: Colors.white,
                        size: 30,
                      ),
                      onPressed: () {
                        _togglePlay(index);
                      },
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.fast_rewind,
                        color: Colors.white,
                        size: 30,
                      ),
                      onPressed: () {
                        // Handle rewind (e.g., seek backward in the audio)
                        print('Rewind for ${recordings[index]['name']}');
                      },
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.fast_forward,
                        color: Colors.white,
                        size: 30,
                      ),
                      onPressed: () {
                        // Handle fast forward (e.g., seek forward in the audio)
                        print('Fast forward for ${recordings[index]['name']}');
                      },
                    ),
                    // Recording name and timestamp
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            recordings[index]['timestamp']!,
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            recordings[index]['name']!,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Delete icon
                    IconButton(
                      icon: Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        _removeRecording(index);
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}