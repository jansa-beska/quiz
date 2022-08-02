import 'package:dio/dio.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  @override
  void onInit() async {
    await getQuestion();
    super.onInit();
  }

  bool isLoading = false;
  String question = 'None';
  String hint = '';
  String answer = '';
  final HomeRepo repo = HomeRepo();
  Future<void> getQuestion() async {
    isLoading = true;
    update();
    final res = await repo.getQuestion();
    question = res.question!;
    answer = res.answer!;
    hint = res.category!.title;
    isLoading = false;
    update();
  }
}

class HomeRepo {
  final Dio dio = Dio();
  Future<QuizModel> getQuestion() async {
    final res = await dio.get('http://jservice.io/api/random?count=1');
    print(res.data);
    return QuizModel.fromJson(res.data[0]);
  }
}

class QuizModel {
  QuizModel({
    required this.id,
    required this.answer,
    required this.question,
    required this.value,
    required this.airdate,
    required this.createdAt,
    required this.updatedAt,
    required this.categoryId,
    required this.category,
  });
  late final int? id;
  late final String? answer;
  late final String? question;
  late final int? value;
  late final String? airdate;
  late final String? createdAt;
  late final String? updatedAt;
  late final int? categoryId;
  late final Category? category;

  QuizModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    answer = json['answer'];
    question = json['question'];
    value = json['value'];
    airdate = json['airdate'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    categoryId = json['category_id'];
    category = Category.fromJson(json['category']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['answer'] = answer;
    _data['question'] = question;
    _data['value'] = value;
    _data['airdate'] = airdate;
    _data['created_at'] = createdAt;
    _data['updated_at'] = updatedAt;
    _data['category_id'] = categoryId;
    _data['category'] = category!.toJson();
    return _data;
  }
}

class Category {
  Category({
    required this.id,
    required this.title,
    required this.createdAt,
    required this.updatedAt,
    required this.cluesCount,
  });
  late final int id;
  late final String title;
  late final String createdAt;
  late final String updatedAt;
  late final int cluesCount;

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    cluesCount = json['clues_count'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['title'] = title;
    _data['created_at'] = createdAt;
    _data['updated_at'] = updatedAt;
    _data['clues_count'] = cluesCount;
    return _data;
  }
}
