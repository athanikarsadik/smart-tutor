import 'dart:io';
import 'dart:typed_data';
import 'package:google_generative_ai/google_generative_ai.dart';

void main() async {
  try {
    final model = GenerativeModel(
      model: 'gemini-1.5-flash-latest',
      apiKey: '',
    );
    // Load image from file system and convert to Uint8List
    Uint8List imageBytes = await loadFileAsUint8List(
        "C:\\Users\\Sadik\\Desktop\\socratica\\assets\\images\\test.png");

    // Define prompt and content (text + image)
    // const prompt = 'what the image contains';

    final content = [
      Content("user", [TextPart("Hello, how are you!")]),
      Content("model", [TextPart("I am fine, how about you!")]),
      Content("user", [
        TextPart(
            "I'll give you images from now, you have to generate story out of it, okay?")
      ]),
      Content("model", [TextPart("Yeah sure, please give me image.")]),
      Content.data("image/png", imageBytes),
      Content("user", [TextPart("Here you go")]),
      Content("model", [
        TextPart(
            """The image is a screenshot of a mobile phone screen showing an app for sending gift cards.  The user is in the process of filling out the form to send a gift card.  They have entered the amount of the gift card, the quantity of gift cards, and the recipient's email address.  They are now entering the recipient's phone number. The user has selected December 18th as the date for the gift card to be sent.  They have also selected to send the gift card via email.  They are about to click the "Send" button to complete the process.

This scenario could be part of a larger story about a person who is sending a gift card to a friend or family member. Perhaps they are celebrating a birthday, anniversary, or other special occasion. The gift card could be for a specific store or restaurant, or it could be a general-purpose gift card that can be used anywhere.

This story could be a heartwarming tale of friendship and generosity, or it could be a more suspenseful story about a secret gift or a last-minute gift for someone who has forgotten a special occasion.

What kind of story do you want to write?  Do you want a story with happy ending or a story with a twist?  Do you want a story about a loving relationship or a story about a difficult relationship?

Tell me more and we can build a story together!""")
      ]),
    ];

    print("content loaded..");

    // Generate content using the model
    // final response = await model.generateContent(content);
    final chat = model.startChat(history: content);
    final response = await chat.sendMessage(Content("user", [
      TextPart(
          "I don't really liked it, can you change it a little bit and mention moral, also compare this with previous one.")
    ]));
    print("response: ${response.text}");
  } catch (e) {
    print("exception: $e");
  }
}

// Method to load file from the filesystem and convert it to Uint8List
Future<Uint8List> loadFileAsUint8List(String path) async {
  File file = File(path);
  return await file.readAsBytes();
}
