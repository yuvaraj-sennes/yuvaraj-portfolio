import 'package:flutter/material.dart';

class PortfolioData {
  // Personal Info
  static const String name = "Yuvaraj S";
  static const String role = "Flutter Developer";
  static const String email = "yuvaraj133433@gmail.com";
  static const String phone = "+91 89253 18009";
  static const String location = "Chennai, India";
  static const String github = "https://github.com/yuvaraj";
  static const String linkedin = "https://linkedin.com/in/yuvaraj";

  static const String bio = """
Passionate Flutter Developer with expertise in building and shipping production mobile applications across HR, e-commerce, logistics, and e-sign workflows. I transform ideas into pixel-perfect, high-performance applications using Clean Architecture, BLoC pattern, and modern development practices.
""";

  static const String shortBio =
      "Building beautiful, performant mobile experiences with Flutter";

  // Skills
  static final List<SkillCategory> skillCategories = [
    SkillCategory(
      title: "Mobile",
      icon: Icons.phone_android_rounded,
      skills: ["Flutter", "Android", "iOS", "Flutter Web"],
      color: const Color(0xFF6C63FF),
    ),
    SkillCategory(
      title: "State Management",
      icon: Icons.layers_rounded,
      skills: ["BLoC", "Cubit", "GetX", "Provider"],
      color: const Color(0xFF00D9FF),
    ),
    SkillCategory(
      title: "Architecture",
      icon: Icons.account_tree_rounded,
      skills: ["Clean Architecture", "GetIt", "MVC", "MVVM"],
      color: const Color(0xFFFF6B6B),
    ),
    SkillCategory(
      title: "Backend",
      icon: Icons.dns_rounded,
      skills: ["GraphQL", "REST APIs", "WebSockets"],
      color: const Color(0xFF4CAF50),
    ),
    SkillCategory(
      title: "Firebase",
      icon: Icons.local_fire_department_rounded,
      skills: ["Auth", "FCM", "Crashlytics", "Remote Config"],
      color: const Color(0xFFFF9800),
    ),
    SkillCategory(
      title: "Integrations",
      icon: Icons.extension_rounded,
      skills: ["Razorpay", "Google Maps", "ML Kit", "PDF"],
      color: const Color(0xFF9C27B0),
    ),
  ];

  // Projects
  static final List<Project> projects = [
    Project(
      name: "SkyPeople",
      subtitle: "HR Management App",
      description:
          "Comprehensive HR application with attendance, leave management, WFH requests, approvals, visitor management, and payroll. Features ML Kit face verification, geofencing, background location tracking, and multi-language support (EN/TA/HI/AR).",
      technologies: [
        "Flutter",
        "BLoC",
        "GraphQL",
        "Firebase",
        "ML Kit",
        "GetIt"
      ],
      color: const Color(0xFF6C63FF),
      icon: Icons.people_alt_rounded,
      features: [
        "ML Kit Face Verification",
        "Geofencing & Background Location",
        "Multi-language (EN/TA/HI/AR)",
        "Push Notifications",
        "Payroll Integration",
      ],
    ),
    Project(
      name: "Vequik",
      subtitle: "Grocery Delivery App",
      description:
          "Full-featured grocery delivery platform with OTP login, product catalog, cart management, wishlist, wallet, Razorpay payments, cash checkout, and real-time order tracking with Google Maps integration.",
      technologies: [
        "Flutter",
        "BLoC",
        "GraphQL",
        "Firebase",
        "Google Maps",
        "Razorpay"
      ],
      color: const Color(0xFF00D9FF),
      icon: Icons.shopping_cart_rounded,
      features: [
        "Real-time Order Tracking",
        "Multiple Payment Options",
        "Wallet & Rewards",
        "Live GPS Tracking",
        "OTP Authentication",
      ],
    ),
    Project(
      name: "Vequik Rider",
      subtitle: "Delivery Partner App",
      description:
          "Delivery partner application with online/offline status management, order workflows, delivery status updates, earnings tracking, referral system, and optimized location tracking.",
      technologies: ["Flutter", "BLoC", "GraphQL", "Firebase", "Google Maps"],
      color: const Color(0xFFFF6B6B),
      icon: Icons.delivery_dining_rounded,
      features: [
        "Online/Offline Toggle",
        "Order Management",
        "Earnings Dashboard",
        "Referral System",
        "Route Optimization",
      ],
    ),
    Project(
      name: "Sky Paper",
      subtitle: "E-Sign & Document App",
      description:
          "Digital signature platform for PDF upload, signature field placement, recipient management, templates, drafts, biometric authentication, deep links, and multiple build flavors.",
      technologies: ["Flutter", "BLoC", "PDF", "Biometrics", "Deep Links"],
      color: const Color(0xFF4CAF50),
      icon: Icons.draw_rounded,
      features: [
        "PDF Upload & Editing",
        "Digital Signatures",
        "Template Management",
        "Biometric Auth",
        "Deep Link Support",
      ],
    ),
    Project(
      name: "SkyAuth",
      subtitle: "Authentication System",
      description:
          "Secure authentication system with multiple auth providers, session management, and seamless integration across Sky ecosystem applications.",
      technologies: ["Flutter", "Firebase Auth", "OAuth", "Secure Storage"],
      color: const Color(0xFF9C27B0),
      icon: Icons.security_rounded,
      features: [
        "Multi-provider Auth",
        "Secure Session Management",
        "Token Refresh",
        "Biometric Login",
        "Cross-app Integration",
      ],
    ),
    Project(
      name: "SkyChat",
      subtitle: "Real-time Messaging",
      description:
          "Real-time chat application with instant messaging, media sharing, and seamless communication features built with WebSocket technology.",
      technologies: ["Flutter", "WebSocket", "Firebase", "Real-time DB"],
      color: const Color(0xFFFF9800),
      icon: Icons.chat_bubble_rounded,
      features: [
        "Real-time Messaging",
        "Media Sharing",
        "Push Notifications",
        "Read Receipts",
        "Group Chats",
      ],
    ),
    Project(
      name: "Business Manager",
      subtitle: "Inventory & Workflow App",
      description:
          "Digital inventory and workforce solution replacing manual paper-based processes. Features stock management, product catalog, staff management, orders, billing, and QR-based tracking.",
      technologies: ["Flutter", "SQLite", "QR Scanner", "PDF Generation"],
      color: const Color(0xFF607D8B),
      icon: Icons.business_center_rounded,
      features: [
        "Inventory Management",
        "QR-based Tracking",
        "Staff Management",
        "Order Processing",
        "Report Generation",
      ],
    ),
    Project(
      name: "SkyKart CMS",
      subtitle: "Web Dashboard Builder",
      description:
          "Flutter Web SDUI page builder for designing, previewing, and publishing mobile dashboard JSON configurations without requiring new mobile releases.",
      technologies: ["Flutter Web", "SDUI", "JSON", "Real-time Preview"],
      color: const Color(0xFF795548),
      icon: Icons.dashboard_customize_rounded,
      features: [
        "Drag & Drop Builder",
        "Real-time Preview",
        "JSON Export",
        "No-code Updates",
        "Version Control",
      ],
    ),
  ];

  // Experience
  static final List<Experience> experiences = [
    Experience(
      company: "SpyNxt",
      role: "Flutter Developer",
      duration: "Jun 2025 – Present",
      description:
          "Building and shipping production Flutter applications across HR, grocery delivery, logistics, and e-sign workflows using Clean Architecture, BLoC, GraphQL, Firebase, and GetIt.",
      highlights: [
        "Led development of SkyPeople HR application",
        "Built Vequik grocery delivery ecosystem",
        "Implemented Sky Paper e-sign workflows",
        "Deployed apps on Play Store & App Store",
      ],
      color: const Color(0xFF6C63FF),
    ),
    Experience(
      company: "Navin Electricals",
      role: "Application Developer",
      duration: "Jun 2024 – May 2025",
      description:
          "Developed digital inventory and workforce solutions replacing manual paper-based processes.",
      highlights: [
        "Built stock management system",
        "Implemented QR-based inventory tracking",
        "Created staff management module",
        "Automated billing workflows",
      ],
      color: const Color(0xFF00D9FF),
    ),
    Experience(
      company: "TMI Inputs Pvt Ltd",
      role: "Project Trainee",
      duration: "Sep 2023 – Jun 2024",
      description:
          "Assisted with digital project tracking, reporting dashboards, and requirements gathering for internal applications.",
      highlights: [
        "Built Smart PT training application",
        "Developed SIGMA feedback system",
        "Created reporting dashboards",
        "Gathered business requirements",
      ],
      color: const Color(0xFFFF6B6B),
    ),
  ];

  // Education
  static final List<Education> education = [
    Education(
      institution: "SRM Institute of Science and Technology",
      degree: "B.Sc. Agriculture",
      duration: "2019 – 2023",
      score: "CGPA: 7.91",
    ),
    Education(
      institution: "Greens Technology, Chennai",
      degree: "Flutter App Development Certification",
      duration: "August 2023",
      score: "",
    ),
  ];

  // Social Links
  static final List<SocialLink> socialLinks = [
    SocialLink(
      name: "GitHub",
      icon: Icons.code_rounded,
      url: github,
    ),
    SocialLink(
      name: "LinkedIn",
      icon: Icons.work_rounded,
      url: linkedin,
    ),
    SocialLink(
      name: "Email",
      icon: Icons.email_rounded,
      url: "mailto:$email",
    ),
    SocialLink(
      name: "Phone",
      icon: Icons.phone_rounded,
      url: "tel:$phone",
    ),
  ];
}

class SkillCategory {
  final String title;
  final IconData icon;
  final List<String> skills;
  final Color color;

  SkillCategory({
    required this.title,
    required this.icon,
    required this.skills,
    required this.color,
  });
}

class Project {
  final String name;
  final String subtitle;
  final String description;
  final List<String> technologies;
  final Color color;
  final IconData icon;
  final List<String> features;

  Project({
    required this.name,
    required this.subtitle,
    required this.description,
    required this.technologies,
    required this.color,
    required this.icon,
    required this.features,
  });
}

class Experience {
  final String company;
  final String role;
  final String duration;
  final String description;
  final List<String> highlights;
  final Color color;

  Experience({
    required this.company,
    required this.role,
    required this.duration,
    required this.description,
    required this.highlights,
    required this.color,
  });
}

class Education {
  final String institution;
  final String degree;
  final String duration;
  final String score;

  Education({
    required this.institution,
    required this.degree,
    required this.duration,
    required this.score,
  });
}

class SocialLink {
  final String name;
  final IconData icon;
  final String url;

  SocialLink({
    required this.name,
    required this.icon,
    required this.url,
  });
}
