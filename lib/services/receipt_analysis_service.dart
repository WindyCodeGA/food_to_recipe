import 'dart:convert';
import 'dart:io';
// import 'package:http/http.dart' as http;
// import 'package:http_parser/http_parser.dart';
import 'package:flutter/foundation.dart';
// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter/foundation.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ReceiptAnalysisService {
  Future<List<String>> analyzeReceipt(File receiptImage) async {
    final apiKey = dotenv.env['OPENAI_API_KEY'] ?? '';

    if (apiKey.isEmpty) {
      throw Exception('Không tìm thấy API Key trong file .env');
    }

    final model = GenerativeModel(
      model: 'gemini-2.5-flash',
      apiKey: apiKey,
    );

    final imageBytes = await receiptImage.readAsBytes();
    const prompt = '''
    You are an AI specialized in analyzing data from supermarket or grocery receipt images.
    Your task is to extract a list of cooking ingredients, food items, beverages, or spices present in the image.
    You MUST STRICTLY adhere to the following 6 rules:
    1. FILTER NOISE: Absolutely ignore non-food items (e.g., tissue paper, soap, plastic items), discount codes, taxes, or fees.
    2. STANDARDIZE & TRANSLATE: Regardless of the receipt's original language, translate all ingredient names to English. Extract only the core noun (e.g., "CP Minced Pork 500g" -> "Minced pork").
    3. NO DUPLICATES: If there are multiple items of the same type (e.g., 2 different brands of fresh milk), record that item type only once.
    4. STRICT JSON FORMAT: The output MUST be a valid JSON array. YOU MUST ONLY USE DOUBLE QUOTES for the elements inside; absolutely no single quotes.
    5. NO EXTRA TEXT: Do not explain, do not greet, do not use code block formatting (like ``` or ```json). Return only the raw JSON array.
    6. FAIL-SAFE: If the image is blurry, contains no food items, or has illegible handwriting, return exactly these 2 characters: []

    Example of expected output:
    ["Chicken", "Tomato", "Fish sauce", "Fresh milk"]
    ''';

    try {
      // 4. Gửi ảnh và yêu cầu lên Google AI Studio
      final content = [
        Content.multi([
          TextPart(prompt),
          DataPart('image/jpeg', imageBytes),
        ])
      ];

      final response = await model.generateContent(content);
      final responseText = response.text;

      debugPrint('Gemini response: $responseText');

      if (responseText != null) {
        // Dọn dẹp chuỗi JSON đề phòng Gemini tự động thêm ký tự code block (```json)
        String cleanJson =
            responseText.replaceAll('```json', '').replaceAll('```', '').trim();

        // Dịch JSON thành danh sách nguyên liệu (List<String>) trả về cho App
        final List<dynamic> parsedList = jsonDecode(cleanJson);
        return parsedList.map((e) => e.toString()).toList();
      } else {
        throw Exception('Gemini không trả về kết quả.');
      }
    } catch (e) {
      debugPrint('Error analyzing receipt: $e');
      throw Exception('Lỗi khi đọc hóa đơn bằng Gemini: $e');
    }
  }
}
