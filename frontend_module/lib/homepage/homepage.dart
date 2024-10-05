import 'package:flutter/material.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class ListData {
  String user;
  String message;

  ListData({
    required this.user,
    required this.message,
  });
}

class _HomepageState extends State<Homepage> {
  final TextEditingController _controller =
      TextEditingController(); // Controller for the TextField
  final List<ListData> _messages = []; // List to hold the messages
  final ScrollController _scrollController =
      ScrollController(); // Controller for the ListView
  bool _isLoading = false; // State variable to track loading status

  // Simulated API call
  Future<String> _fetchTranslation(String message) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 6));
    return "Translated: $message"; // Simulated API response
  }

  void translate(String originalMessage) async {
    // Call the simulated API in a separate call
    String apiResponse = await _fetchTranslation(originalMessage);
    ListData response = ListData(user: "Translation: ", message: apiResponse);
    // Update the list with the API response
    setState(() {
      _messages.add(response);
      _isLoading = false; // Add API response to the list
    });
    Future.delayed(const Duration(milliseconds: 100), () {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    });
  }

  void _addMessage() async {
    if (_controller.text.isNotEmpty) {
      String originalMessage = _controller.text; // Store the original message
      ListData request =
          ListData(user: "User Input: ", message: originalMessage);
      _controller.clear(); // Clear the TextField

      setState(() {
        _messages.add(request);
        _isLoading = true; // Lock the send button
      });
      // Scroll to the bottom of the list
      Future.delayed(const Duration(milliseconds: 100), () {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      });
      translate(originalMessage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 20,
                ),
                Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: MediaQuery.of(context).size.height * 0.08,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        color: Colors.purple.withOpacity(0.2),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(28))),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    20), // Rounded corners
                              ),
                              elevation: 2,
                            ),
                            child: const Text(
                              "ENGLISH",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1),
                            ),
                          ),
                          Icon(
                            Icons.compare_arrows,
                            size: 38,
                            color: Colors.purple.withOpacity(0.3),
                          ),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    20), // Rounded corners
                              ),
                              elevation: 2,
                            ),
                            child: const Text(
                              "PUNJABI",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                      height: MediaQuery.of(context).size.height * 0.6,
                      margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                      decoration: BoxDecoration(
                          color: Colors.purple.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20)),
                      child: ListView.builder(
                        controller:
                            _scrollController, // Attach the ScrollController
                        itemCount: _messages.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.fromLTRB(8.0, 0, 8, 0),
                            child: Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.purple.withOpacity(0.3),
                                  ),
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(8.0, 8, 8, 8),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          _messages[index].user,
                                          style: const TextStyle(
                                              fontSize: 12,
                                              letterSpacing: 1,
                                              color: Colors.purple
                                              // Label text color
                                              ),
                                        ),
                                        Text(_messages[index].message)
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8)
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height *
                              0.15, // Increased height for long paragraphs
                          width: MediaQuery.of(context).size.width * 0.7,
                          margin: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.purple.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: TextField(
                            controller: _controller, // Attach the controller
                            onSubmitted: (value) => _addMessage(),
                            style: const TextStyle(fontSize: 14),
                            maxLines:
                                null, // Allows the TextField to expand for multiple lines
                            keyboardType: TextInputType
                                .multiline, // Enables multi-line input
                            decoration: InputDecoration(
                              hintText: "Type your text to translate",
                              hintStyle: TextStyle(
                                fontSize: 14,
                                color: Colors.purple
                                    .withOpacity(0.4), // Label text color
                              ),
                              border: InputBorder
                                  .none, // Optional: Remove default borders
                              contentPadding: const EdgeInsets.all(
                                  16), // Padding inside the TextField
                            ),
                          ),
                        ),
                        Container(
                          width: 60,
                          height: 70,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle, // Circular shape
                            color: _isLoading
                                ? Colors.purple.withOpacity(0.5)
                                : Colors.purple, // Background color
                          ),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(4, 0, 0, 0),
                            child: IconButton(
                              iconSize: 30, // Increase the icon size
                              onPressed: _isLoading ? null : _addMessage,
                              icon: const Icon(
                                Icons.send,
                                color: Colors.white,
                              ), // Icon with color
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
