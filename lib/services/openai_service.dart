import 'dart:convert';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'fatsecret_service.dart';

class OpenAIService {
  final String apiKey; // Đây sẽ là Key Gemini bạn dán trong file .env
  final FatSecretService fatSecretService;

  OpenAIService(this.apiKey)
      : fatSecretService = FatSecretService(
          'dfd573663388464eb77f353fbef3a292',
          'ddc36747bd0d4a9b835bc00a8db27d85',
        );

  Future<String> generateRecipe({
    required String mealType,
    required String cuisineType,
    required List<String> dietaryRestrictions,
    required List<String> allergies,
    required int servings,
    required int calorieLimit,
    required List<String> ingredients,
    required Map<String, String> additionalPreferences,
  }) async {
    // 1. Khởi tạo Model Gemini
    final model = GenerativeModel(
      model: 'gemini-2.5-flash',
      apiKey: apiKey,
    );

    // 2. Xây dựng câu lệnh (Prompt) để Gemini trả về đúng cấu trúc app cần
    final prompt = '''
    Bạn là một đầu bếp chuyên nghiệp. Hãy tạo một công thức nấu ăn dựa trên các thông tin sau:
    - Loại bữa ăn: $mealType
    - Ẩm thực: $cuisineType
    - Nguyên liệu có sẵn: ${ingredients.join(', ')}
    - Số người ăn: $servings
    - Giới hạn Calo: $calorieLimit kcal
    - Chế độ ăn kiêng: ${dietaryRestrictions.join(', ')}
    - Dị ứng: ${allergies.join(', ')}
    - Tùy chỉnh khác: $additionalPreferences

    YÊU CẦU: Trả về kết quả CHỈ bao gồm một chuỗi JSON hợp lệ (không kèm giải thích) có cấu trúc như sau:
    {
      "recipe": "Nội dung chi tiết công thức bao gồm Tên món, Nguyên liệu chi tiết, các bước thực hiện và phân tích dinh dưỡng."
    }
    ''';

    try {
      // 3. Gọi Gemini thay vì gọi Server cũ
      final content = [Content.text(prompt)];
      final response = await model.generateContent(content);

      if (response.text != null) {
        // Giải mã JSON để lấy đúng trường 'recipe' mà UI của bạn đang chờ
        final Map<String, dynamic> data = jsonDecode(response.text!);
        return data['recipe'] ?? "Không thể tạo công thức.";
      } else {
        throw Exception('Gemini không trả về nội dung.');
      }
    } catch (e) {
      throw Exception('Lỗi khi gọi Gemini: $e');
    }
  }
}
