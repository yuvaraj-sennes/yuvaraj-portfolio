import 'package:flutter/material.dart';

class PortfolioData {
  static const String name = 'Yuvaraj S';
  static const String role = 'Flutter Developer';
  static const String email = 'yuvaraj133433@gmail.com';
  static const String phone = '+91 89253 18009';
  static const String location = 'Chennai, India';
  static const String github = 'https://github.com/yuvaraj-sennes';
  static const String linkedin =
      'https://www.linkedin.com/in/yuvaraj-s-468b8b37b';

  static const String bio =
      'Flutter developer with 3+ years building production apps for HR, grocery delivery, logistics, e-sign, billing, and internal tools. '
      'I focus on clean architecture, predictable state (BLoC/Cubit), and polished UI that feels fast on real devices.';

  static const String shortBio =
      'Production Flutter apps — from idea to Play Store & App Store.';

  static const int yearsExperience = 3;
  static const int projectCount = 12;
  static const int storeAppsCount = 6;

  static final List<SkillCategory> skillCategories = [
    SkillCategory(
      title: 'Mobile',
      skills: ['Flutter', 'Android', 'iOS', 'Flutter Web'],
    ),
    SkillCategory(
      title: 'State & architecture',
      skills: ['BLoC', 'Cubit', 'Clean Architecture', 'GetIt'],
    ),
    SkillCategory(
      title: 'Backend & data',
      skills: ['GraphQL', 'REST', 'Hive', 'Secure storage'],
    ),
    SkillCategory(
      title: 'Platform',
      skills: ['Firebase', 'FCM', 'Maps', 'Razorpay', 'ML Kit'],
    ),
  ];

  static final List<Project> projects = [
    // —— SpyNxt ——
    Project(
      company: 'SpyNxt',
      name: 'SkyPeople',
      subtitle: 'HR & workforce',
      description:
          'Attendance, leave, WFH, approvals, visitors, payroll. ML Kit face verification, geofencing, background location, GraphQL, EN/TA/HI/AR.',
      technologies: ['Flutter', 'BLoC', 'GraphQL', 'Firebase', 'ML Kit'],
      icon: Icons.groups_rounded,
    ),
    Project(
      company: 'SpyNxt',
      name: 'Vequik',
      subtitle: 'Grocery delivery (formerly SkyKart / GreenKart)',
      description:
          'Customer app: OTP login, catalog, cart, wishlist, wallet, Razorpay, cash checkout, live order tracking on Maps.',
      technologies: ['Flutter', 'BLoC', 'GraphQL', 'Maps', 'Razorpay'],
      icon: Icons.storefront_rounded,
    ),
    Project(
      company: 'SpyNxt',
      name: 'Vequik Rider',
      subtitle: 'Delivery partner',
      description:
          'Online/offline status, orders, delivery updates, earnings, referrals, location permissions, rider workflows.',
      technologies: ['Flutter', 'BLoC', 'GraphQL', 'Firebase', 'Maps'],
      icon: Icons.two_wheeler_rounded,
    ),
    Project(
      company: 'SpyNxt',
      name: 'Sky Paper',
      subtitle: 'E-sign & PDF',
      description:
          'PDF upload, signature fields, recipients, templates, drafts, biometrics, deep links, dev/QA/prod flavors.',
      technologies: ['Flutter', 'BLoC', 'PDF', 'Biometrics'],
      icon: Icons.description_outlined,
    ),
    Project(
      company: 'SpyNxt',
      name: 'SkyAuth',
      subtitle: 'Authentication',
      description:
          'Shared auth across Sky apps: providers, sessions, secure tokens, biometric login.',
      technologies: ['Flutter', 'Firebase Auth', 'OAuth'],
      icon: Icons.lock_rounded,
    ),
    Project(
      company: 'SpyNxt',
      name: 'SkyChat',
      subtitle: 'Real-time chat',
      description:
          'Messaging client with real-time delivery, media, and push-friendly architecture.',
      technologies: ['Flutter', 'WebSocket', 'Firebase'],
      icon: Icons.chat_rounded,
    ),
    Project(
      company: 'SpyNxt',
      name: 'SkyKart CMS',
      subtitle: 'Flutter Web SDUI',
      description:
          'Page builder to design, preview, and publish mobile dashboard JSON without a new store release.',
      technologies: ['Flutter Web', 'SDUI', 'JSON'],
      icon: Icons.dashboard_customize_rounded,
    ),
    Project(
      company: 'SpyNxt',
      name: 'Business Management',
      subtitle: 'Operations & inventory',
      description:
          'Business app for catalog, stock, staff, orders, and workflows aligned with delivery operations.',
      technologies: ['Flutter', 'REST', 'SQLite'],
      icon: Icons.business_center_rounded,
    ),
    // —— Navin Electricals ——
    Project(
      company: 'Navin Electricals',
      name: 'Billing & POS',
      subtitle: 'Sales & invoicing',
      description:
          'Digital billing replacing paper: product catalog, orders, invoicing, and staff-facing sales flows.',
      technologies: ['Flutter', 'SQLite', 'PDF'],
      icon: Icons.receipt_long_rounded,
    ),
    Project(
      company: 'Navin Electricals',
      name: 'Inventory & Stock',
      subtitle: 'Warehouse & QR',
      description:
          'Stock management, product catalog, QR-based inventory tracking, and workforce tools for the shop floor.',
      technologies: ['Flutter', 'QR', 'Local DB'],
      icon: Icons.inventory_2_rounded,
    ),
    // —— TMI Inputs ——
    Project(
      company: 'TMI Inputs',
      name: 'Smart PT',
      subtitle: 'Training & attendance',
      description:
          'Internal training app: attendance, tasks, performance tracking for project trainees.',
      technologies: ['Flutter', 'REST'],
      icon: Icons.school_rounded,
    ),
    Project(
      company: 'TMI Inputs',
      name: 'SIGMA',
      subtitle: 'Feedback & mentoring',
      description:
          'Mentor feedback, task visibility, and reporting for trainee progress and internal dashboards.',
      technologies: ['Flutter', 'REST'],
      icon: Icons.insights_rounded,
    ),
  ];

  static final List<String> projectCompanies = [
    'All',
    'SpyNxt',
    'Navin Electricals',
    'TMI Inputs',
  ];

  static final List<Experience> experiences = [
    Experience(
      company: 'SpyNxt',
      role: 'Flutter Developer',
      duration: 'Jun 2025 – Present',
      description:
          'Shipping HR, grocery (Vequik), rider, e-sign, auth, chat, CMS, and business apps with Clean Architecture and BLoC.',
      highlights: [
        'SkyPeople, Vequik ecosystem, Sky Paper',
        'GraphQL, Firebase, store releases',
      ],
    ),
    Experience(
      company: 'Navin Electricals',
      role: 'Application Developer',
      duration: 'Jun 2024 – May 2025',
      description:
          'Digital inventory and billing that replaced manual paper processes for stock, orders, and staff.',
      highlights: [
        'Billing & POS app',
        'QR inventory & stock management',
      ],
    ),
    Experience(
      company: 'TMI Inputs Pvt Ltd',
      role: 'Project Trainee',
      duration: 'Sep 2023 – Jun 2024',
      description:
          'Flutter training apps and internal dashboards: requirements, tracking, and reporting.',
      highlights: [
        'Smart PT — attendance & tasks',
        'SIGMA — mentor feedback',
      ],
    ),
  ];

  static final List<Education> education = [
    Education(
      institution: 'SRM Institute of Science and Technology',
      degree: 'B.Sc. Agriculture',
      duration: '2019 – 2023',
      score: 'CGPA: 7.91',
    ),
    Education(
      institution: 'Greens Technology, Chennai',
      degree: 'Flutter App Development Certification',
      duration: 'August 2023',
      score: '',
    ),
  ];

  static final List<SocialLink> socialLinks = [
    SocialLink(name: 'GitHub', icon: Icons.code_rounded, url: github),
    SocialLink(name: 'LinkedIn', icon: Icons.link_rounded, url: linkedin),
    SocialLink(name: 'Email', icon: Icons.mail_outline_rounded, url: 'mailto:$email'),
    SocialLink(name: 'Phone', icon: Icons.phone_outlined, url: 'tel:$phone'),
  ];
}

class SkillCategory {
  final String title;
  final List<String> skills;

  SkillCategory({required this.title, required this.skills});
}

class Project {
  final String company;
  final String name;
  final String subtitle;
  final String description;
  final List<String> technologies;
  final IconData icon;

  Project({
    required this.company,
    required this.name,
    required this.subtitle,
    required this.description,
    required this.technologies,
    required this.icon,
  });
}

class Experience {
  final String company;
  final String role;
  final String duration;
  final String description;
  final List<String> highlights;

  Experience({
    required this.company,
    required this.role,
    required this.duration,
    required this.description,
    required this.highlights,
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
