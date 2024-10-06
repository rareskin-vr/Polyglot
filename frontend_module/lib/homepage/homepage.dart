import 'package:flutter/material.dart';
import 'package:frontend_module/data_model/supported_language.dart';
import '../data_model/message_data.dart';
import '../helper/homepage_widget.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final TextEditingController _controller = TextEditingController();
  List<MessageData> _messages = [];
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;
  Language _selectedLanguage = Language(name: 'Portuguese', code: 'en');
  Language _translationLanguage = Language(name: 'Hindi', code: 'hi');

  void _updateState(List<MessageData> messages, bool isLoading) {
    setState(() {
      _messages = messages;
      _isLoading = isLoading;
    });
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
                        color: Colors.grey.withOpacity(0.2),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(28))),
                    child: Padding(
                      padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.007),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          MessageHelper.buildLanguageSelectionButton(
                              context, UserType.user, _selectedLanguage,
                              (language) {
                            setState(() {
                              _selectedLanguage = language;
                            });
                          }),
                          Icon(
                            Icons.compare_arrows,
                            size:  MediaQuery.of(context).size.height *0.04 ,
                            color: Colors.grey.withOpacity(0.3),
                          ),
                          MessageHelper.buildLanguageSelectionButton(
                              context,
                              UserType.translation,
                              _translationLanguage, (language) {
                            setState(() {
                              _translationLanguage = language;
                            });
                          }),
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
                          color: Colors.grey.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20)),
                      child: ListView.builder(
                        controller:
                            _scrollController, // Attach the ScrollController
                        itemCount: _messages.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.fromLTRB(8.0, 0, 8, 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.grey.withOpacity(0.3),
                                  ),
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(8.0, 8, 8, 8),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          _messages[index].userLabel,
                                          style: const TextStyle(
                                              fontSize: 12,
                                              letterSpacing: 1,
                                              color: Colors.grey
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
                    Row(children: [
                      Container(
                        height: MediaQuery.of(context).size.height *
                            0.15, // Increased height for long paragraphs
                        width: MediaQuery.of(context).size.width * 0.7,
                        margin: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: TextField(
                          controller: _controller, // Attach the controller
                          onSubmitted: (value) {
                            MessageHelper.addMessage(
                                context: context,
                                controller: _controller,
                                scrollController: _scrollController,
                                messages: _messages,
                                updateState: _updateState,
                                selectedLanguage: [
                                  _selectedLanguage,
                                  _translationLanguage
                                ]);
                          },
                          style: const TextStyle(fontSize: 14),
                          maxLines:
                              null, // Allows the TextField to expand for multiple lines
                          keyboardType: TextInputType
                              .multiline, // Enables multi-line input
                          decoration: InputDecoration(
                            hintText: "Type your text to translate",
                            hintStyle: TextStyle(
                              fontSize: 14,
                              color: Colors.grey
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
                          color:
                              Colors.grey.withOpacity(0.2), // Background color
                        ),
                        child: _isLoading
                            ? const Center(
                                child:
                                    CircularProgressIndicator(strokeWidth: 2))
                            : Padding(
                                padding: const EdgeInsets.fromLTRB(3, 0, 0, 0),
                                child: IconButton(
                                  iconSize: 30, // Increase the icon size
                                  onPressed: () {
                                    MessageHelper.addMessage(
                                        context: context,
                                        controller: _controller,
                                        scrollController: _scrollController,
                                        messages: _messages,
                                        updateState: _updateState,
                                        selectedLanguage: [
                                          _selectedLanguage,
                                          _translationLanguage
                                        ]);
                                  },
                                  icon: const Icon(
                                    Icons.send,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                      )
                    ])
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
