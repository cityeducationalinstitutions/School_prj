import 'package:flutter/material.dart';

class SchoolModel {
  final String id;
  final String name;
  final String address;
  final IconData icon;
  final String logoPath;
  final Color themeColor;

  SchoolModel({
    required this.id,
    required this.name,
    required this.address,
    required this.icon,
    required this.logoPath,
    this.themeColor = Colors.blue, // Default to blue
  });

  static List<SchoolModel> schools = [
    SchoolModel(
      id: 'city-talent',
      name: 'City Talent High School',
      address: 'MG Road,Suryapet',
      icon: Icons.school_rounded,
      logoPath: 'assets/images/logo_city_talent.jpg',
      themeColor: const Color(0xFFE28743), // Softer, lower-contrast muted orange
    ),
    SchoolModel(
      id: 'new-vision',
      name: 'New Vision High School',
      address: 'Sri Ram Nagar,Suryapet',
      icon: Icons.auto_awesome_rounded,
      logoPath: 'assets/images/logo_new_vision.jpg',
      themeColor: const Color(0xFFE28743), // Match City Talent Theme
    ),
    SchoolModel(
      id: 'city-elite',
      name: 'City Elite High School',
      address: 'New Collectorate Road,Suryapet',
      icon: Icons.workspace_premium_rounded,
      logoPath: 'assets/images/logo_city_elite.jpg',
      themeColor: const Color(0xFFE28743), // Match City Talent Theme
    ),
  ];
}
