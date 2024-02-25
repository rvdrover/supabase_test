// ignore_for_file: public_member_api_docs, sort_constructors_first
// To parse this JSON data, do
//
//     final supabaseTestData = supabaseTestDataFromJson(jsonString);

import 'dart:convert';

SupabaseTestData supabaseTestDataFromJson(String str) => SupabaseTestData.fromJson(json.decode(str));

String supabaseTestDataToJson(SupabaseTestData data) => json.encode(data.toJson());

class SupabaseTestData {
    final String? id;
    final String? name;
    final DateTime? createdAt;
    final int? age;

    SupabaseTestData({
        this.id,
        this.name,
        this.createdAt,
        this.age,
    });

    factory SupabaseTestData.fromJson(Map<String, dynamic> json) => SupabaseTestData(
        id: json["id"],
        name: json["name"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        age: json["age"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "created_at": createdAt?.toIso8601String(),
        "age": age,
    };

  @override
  String toString() {
    return 'SupabaseTestData(id: $id, name: $name, createdAt: $createdAt, age: $age)';
  }
}
