import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

import '../data/portfolio_data.dart';
import '../theme/app_theme.dart';
import '../widgets/animated_background.dart';
import '../widgets/animated_card.dart';
import '../widgets/gradient_text.dart';
import '../widgets/section_title.dart';
import '../widgets/skill_chip.dart';

class PortfolioScreen extends StatefulWidget {
  const PortfolioScreen({super.key});

  @override
  State<PortfolioScreen> createState() => _PortfolioScreenState();
}

class _PortfolioScreenState extends State<PortfolioScreen> {
  final ScrollController _scrollController = ScrollController();
  int _selectedNavIndex = 0;
  bool _showBackToTop = false;

  final List<GlobalKey> _sectionKeys = List.generate(5, (_) => GlobalKey());
  final List<String> _navItems = [
    'Home',
    'About',
    'Projects',
    'Experience',
    'Contact'
  ];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    setState(() {
      _showBackToTop = _scrollController.offset > 500;
    });

    // Update selected nav based on scroll position
    for (int i = _sectionKeys.length - 1; i >= 0; i--) {
      final key = _sectionKeys[i];
      if (key.currentContext != null) {
        final RenderBox box =
            key.currentContext!.findRenderObject() as RenderBox;
        final position = box.localToGlobal(Offset.zero);
        if (position.dy <= 200) {
          if (_selectedNavIndex != i) {
            setState(() => _selectedNavIndex = i);
          }
          break;
        }
      }
    }
  }

  void _scrollToSection(int index) {
    final key = _sectionKeys[index];
    if (key.currentContext != null) {
      Scrollable.ensureVisible(
        key.currentContext!,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOut,
      );
    }
    setState(() => _selectedNavIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 1024;
    final isTablet = screenWidth > 768 && screenWidth <= 1024;

    return Scaffold(
      backgroundColor: AppTheme.darkBg,
      body: AnimatedBackground(
        child: Stack(
          children: [
            CustomScrollView(
              controller: _scrollController,
              slivers: [
                // Hero Section
                SliverToBoxAdapter(
                  key: _sectionKeys[0],
                  child: _HeroSection(
                    isDesktop: isDesktop,
                    onExplore: () => _scrollToSection(1),
                  ),
                ),

                // About Section
                SliverToBoxAdapter(
                  key: _sectionKeys[1],
                  child: _AboutSection(isDesktop: isDesktop),
                ),

                // Projects Section
                SliverToBoxAdapter(
                  key: _sectionKeys[2],
                  child: _ProjectsSection(
                    isDesktop: isDesktop,
                    isTablet: isTablet,
                  ),
                ),

                // Experience Section
                SliverToBoxAdapter(
                  key: _sectionKeys[3],
                  child: _ExperienceSection(isDesktop: isDesktop),
                ),

                // Contact Section
                SliverToBoxAdapter(
                  key: _sectionKeys[4],
                  child: const _ContactSection(),
                ),

                // Footer
                SliverToBoxAdapter(
                  child: _Footer(),
                ),
              ],
            ),

            // Navigation Bar
            if (isDesktop)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: _NavBar(
                  selectedIndex: _selectedNavIndex,
                  items: _navItems,
                  onItemTap: _scrollToSection,
                ),
              ),

            // Back to top button
            if (_showBackToTop)
              Positioned(
                bottom: 30,
                right: 30,
                child: FloatingActionButton(
                  onPressed: () {
                    _scrollController.animateTo(
                      0,
                      duration: const Duration(milliseconds: 800),
                      curve: Curves.easeInOut,
                    );
                  },
                  backgroundColor: AppTheme.primaryColor,
                  child: const Icon(Icons.arrow_upward, color: Colors.white),
                )
                    .animate()
                    .fadeIn()
                    .scale(begin: const Offset(0.5, 0.5)),
              ),
          ],
        ),
      ),
    );
  }
}

// Navigation Bar
class _NavBar extends StatelessWidget {
  final int selectedIndex;
  final List<String> items;
  final Function(int) onItemTap;

  const _NavBar({
    required this.selectedIndex,
    required this.items,
    required this.onItemTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppTheme.darkBg.withValues(alpha: 0.95),
            AppTheme.darkBg.withValues(alpha: 0.0),
          ],
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Logo
          GradientText(
            text: "<YS/>",
            style: GoogleFonts.firaCode(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ).animate().fadeIn().slideX(begin: -0.3),

          // Nav Items
          Row(
            children: List.generate(
              items.length,
              (index) => _NavItem(
                label: items[index],
                isSelected: selectedIndex == index,
                onTap: () => onItemTap(index),
                index: index,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatefulWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final int index;

  const _NavItem({
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.index,
  });

  @override
  State<_NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<_NavItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: widget.isSelected
                ? AppTheme.primaryColor.withValues(alpha: 0.2)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: widget.isSelected || _isHovered
                  ? AppTheme.primaryColor
                  : Colors.transparent,
              width: 1,
            ),
          ),
          child: Text(
            widget.label,
            style: GoogleFonts.poppins(
              color: widget.isSelected || _isHovered
                  ? AppTheme.primaryColor
                  : AppTheme.greyText,
              fontWeight:
                  widget.isSelected ? FontWeight.w600 : FontWeight.normal,
              fontSize: 14,
            ),
          ),
        ),
      ),
    )
        .animate(delay: Duration(milliseconds: 100 * widget.index))
        .fadeIn()
        .slideY(begin: -0.5);
  }
}

// Hero Section
class _HeroSection extends StatelessWidget {
  final bool isDesktop;
  final VoidCallback onExplore;

  const _HeroSection({
    required this.isDesktop,
    required this.onExplore,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 100 : 30,
        vertical: 50,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment:
            isDesktop ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          // Greeting
          Text(
            "Hello, I'm",
            style: GoogleFonts.poppins(
              fontSize: isDesktop ? 24 : 18,
              color: AppTheme.greyText,
            ),
          )
              .animate()
              .fadeIn(duration: 800.ms)
              .slideX(begin: isDesktop ? -0.3 : 0),

          const SizedBox(height: 10),

          // Name with gradient
          GradientText(
            text: PortfolioData.name,
            style: GoogleFonts.poppins(
              fontSize: isDesktop ? 72 : 48,
              fontWeight: FontWeight.bold,
              height: 1.1,
            ),
          )
              .animate()
              .fadeIn(duration: 800.ms, delay: 200.ms)
              .slideX(begin: isDesktop ? -0.3 : 0),

          const SizedBox(height: 20),

          // Animated role text
          SizedBox(
            height: isDesktop ? 60 : 40,
            child: DefaultTextStyle(
              style: GoogleFonts.poppins(
                fontSize: isDesktop ? 36 : 24,
                fontWeight: FontWeight.w600,
                color: AppTheme.secondaryColor,
              ),
              child: AnimatedTextKit(
                repeatForever: true,
                animatedTexts: [
                  TypewriterAnimatedText(
                    'Flutter Developer',
                    speed: const Duration(milliseconds: 100),
                  ),
                  TypewriterAnimatedText(
                    'Mobile App Expert',
                    speed: const Duration(milliseconds: 100),
                  ),
                  TypewriterAnimatedText(
                    'Clean Architecture Enthusiast',
                    speed: const Duration(milliseconds: 100),
                  ),
                ],
              ),
            ),
          ).animate().fadeIn(duration: 800.ms, delay: 400.ms),

          const SizedBox(height: 30),

          // Bio
          SizedBox(
            width: isDesktop ? 600 : double.infinity,
            child: Text(
              PortfolioData.shortBio,
              style: AppTheme.bodyStyle.copyWith(
                fontSize: isDesktop ? 18 : 16,
              ),
              textAlign: isDesktop ? TextAlign.start : TextAlign.center,
            ),
          ).animate().fadeIn(duration: 800.ms, delay: 600.ms),

          const SizedBox(height: 40),

          // CTA Buttons
          Wrap(
            spacing: 20,
            runSpacing: 20,
            alignment: isDesktop ? WrapAlignment.start : WrapAlignment.center,
            children: [
              _GradientButton(
                text: "View Projects",
                onTap: onExplore,
                isPrimary: true,
              ),
              _GradientButton(
                text: "Contact Me",
                onTap: () {
                  launchUrl(Uri.parse('mailto:${PortfolioData.email}'));
                },
                isPrimary: false,
              ),
            ],
          ).animate().fadeIn(duration: 800.ms, delay: 800.ms),

          const SizedBox(height: 60),

          // Social Links
          Row(
            mainAxisSize: isDesktop ? MainAxisSize.min : MainAxisSize.max,
            mainAxisAlignment: isDesktop
                ? MainAxisAlignment.start
                : MainAxisAlignment.center,
            children: PortfolioData.socialLinks
                .asMap()
                .entries
                .map(
                  (entry) => _SocialIcon(
                    icon: entry.value.icon,
                    url: entry.value.url,
                    delay: 1000 + (entry.key * 100),
                  ),
                )
                .toList(),
          ),

          const Spacer(),

          // Scroll indicator
          Center(
            child: Column(
              children: [
                Text(
                  "Scroll to explore",
                  style: AppTheme.bodyStyle.copyWith(fontSize: 12),
                ),
                const SizedBox(height: 10),
                Icon(
                  Icons.keyboard_arrow_down,
                  color: AppTheme.primaryColor,
                  size: 30,
                )
                    .animate(onPlay: (controller) => controller.repeat())
                    .slideY(
                      begin: 0,
                      end: 0.3,
                      duration: 1000.ms,
                      curve: Curves.easeInOut,
                    )
                    .then()
                    .slideY(begin: 0.3, end: 0, duration: 1000.ms),
              ],
            ).animate().fadeIn(duration: 800.ms, delay: 1200.ms),
          ),
        ],
      ),
    );
  }
}

class _GradientButton extends StatefulWidget {
  final String text;
  final VoidCallback onTap;
  final bool isPrimary;

  const _GradientButton({
    required this.text,
    required this.onTap,
    required this.isPrimary,
  });

  @override
  State<_GradientButton> createState() => _GradientButtonState();
}

class _GradientButtonState extends State<_GradientButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          decoration: BoxDecoration(
            gradient: widget.isPrimary
                ? AppTheme.primaryGradient
                : null,
            color: widget.isPrimary ? null : Colors.transparent,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: widget.isPrimary
                  ? Colors.transparent
                  : AppTheme.primaryColor,
              width: 2,
            ),
            boxShadow: _isHovered && widget.isPrimary
                ? [
                    BoxShadow(
                      color: AppTheme.primaryColor.withValues(alpha: 0.5),
                      blurRadius: 20,
                      spreadRadius: 0,
                    ),
                  ]
                : [],
          ),
          transform: _isHovered
              ? Matrix4.translationValues(0.0, -3.0, 0.0)
              : Matrix4.identity(),
          child: Text(
            widget.text,
            style: AppTheme.buttonStyle.copyWith(
              color: widget.isPrimary
                  ? Colors.white
                  : AppTheme.primaryColor,
            ),
          ),
        ),
      ),
    );
  }
}

class _SocialIcon extends StatefulWidget {
  final IconData icon;
  final String url;
  final int delay;

  const _SocialIcon({
    required this.icon,
    required this.url,
    required this.delay,
  });

  @override
  State<_SocialIcon> createState() => _SocialIconState();
}

class _SocialIconState extends State<_SocialIcon> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: () => launchUrl(Uri.parse(widget.url)),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 10),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: _isHovered
                ? AppTheme.primaryColor.withValues(alpha: 0.2)
                : AppTheme.darkCard.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _isHovered
                  ? AppTheme.primaryColor
                  : Colors.white.withValues(alpha: 0.1),
            ),
          ),
          child: Icon(
            widget.icon,
            color: _isHovered ? AppTheme.primaryColor : AppTheme.greyText,
            size: 20,
          ),
        ),
      ),
    ).animate(delay: Duration(milliseconds: widget.delay)).fadeIn().scale();
  }
}

// About Section
class _AboutSection extends StatelessWidget {
  final bool isDesktop;

  const _AboutSection({required this.isDesktop});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 100 : 30,
        vertical: 100,
      ),
      child: Column(
        children: [
          const SectionTitle(
            title: "About Me",
            subtitle: "Get to know more about my skills and expertise",
          ),
          const SizedBox(height: 60),

          // Bio Card
          AnimatedCard(
            glowColor: AppTheme.primaryColor,
            child: Padding(
              padding: const EdgeInsets.all(40),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (isDesktop) ...[
                    // Profile placeholder with gradient border
                    Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        gradient: AppTheme.primaryGradient,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.all(3),
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppTheme.darkCard,
                          borderRadius: BorderRadius.circular(17),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.code_rounded,
                            size: 80,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                      ),
                    )
                        .animate()
                        .fadeIn(duration: 800.ms)
                        .scale(begin: const Offset(0.8, 0.8)),
                    const SizedBox(width: 50),
                  ],
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GradientText(
                          text: "Flutter Developer",
                          style: AppTheme.titleStyle,
                        ).animate().fadeIn(delay: 200.ms),
                        const SizedBox(height: 20),
                        Text(
                          PortfolioData.bio,
                          style: AppTheme.bodyStyle.copyWith(height: 1.8),
                        ).animate().fadeIn(delay: 400.ms),
                        const SizedBox(height: 30),
                        
                        // Quick stats
                        Wrap(
                          spacing: 30,
                          runSpacing: 20,
                          children: [
                            _StatItem(
                              value: "2+",
                              label: "Years Experience",
                              delay: 600,
                            ),
                            _StatItem(
                              value: "8+",
                              label: "Projects Completed",
                              delay: 700,
                            ),
                            _StatItem(
                              value: "5+",
                              label: "Apps on Stores",
                              delay: 800,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2),

          const SizedBox(height: 60),

          // Skills Grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: isDesktop ? 3 : (MediaQuery.of(context).size.width > 600 ? 2 : 1),
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              childAspectRatio: isDesktop ? 1.5 : 1.8,
            ),
            itemCount: PortfolioData.skillCategories.length,
            itemBuilder: (context, index) {
              final category = PortfolioData.skillCategories[index];
              return _SkillCard(
                category: category,
                index: index,
              );
            },
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;
  final int delay;

  const _StatItem({
    required this.value,
    required this.label,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GradientText(
          text: value,
          style: GoogleFonts.poppins(
            fontSize: 36,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: AppTheme.bodyStyle.copyWith(fontSize: 14),
        ),
      ],
    ).animate(delay: Duration(milliseconds: delay)).fadeIn().slideY(begin: 0.3);
  }
}

class _SkillCard extends StatelessWidget {
  final SkillCategory category;
  final int index;

  const _SkillCard({
    required this.category,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedCard(
      glowColor: category.color,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: category.color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    category.icon,
                    color: category.color,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  category.title,
                  style: AppTheme.titleStyle.copyWith(fontSize: 18),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: category.skills
                    .map((skill) => SkillChip(
                          label: skill,
                          color: category.color,
                        ))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    )
        .animate(delay: Duration(milliseconds: 100 * index))
        .fadeIn()
        .slideY(begin: 0.2);
  }
}

// Projects Section
class _ProjectsSection extends StatelessWidget {
  final bool isDesktop;
  final bool isTablet;

  const _ProjectsSection({
    required this.isDesktop,
    required this.isTablet,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 100 : 30,
        vertical: 100,
      ),
      child: Column(
        children: [
          const SectionTitle(
            title: "My Projects",
            subtitle: "A showcase of my work and contributions",
          ),
          const SizedBox(height: 60),

          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: isDesktop ? 2 : (isTablet ? 2 : 1),
              crossAxisSpacing: 30,
              mainAxisSpacing: 30,
              childAspectRatio: isDesktop ? 1.2 : (isTablet ? 1.0 : 1.3),
            ),
            itemCount: PortfolioData.projects.length,
            itemBuilder: (context, index) {
              return _ProjectCard(
                project: PortfolioData.projects[index],
                index: index,
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ProjectCard extends StatefulWidget {
  final Project project;
  final int index;

  const _ProjectCard({
    required this.project,
    required this.index,
  });

  @override
  State<_ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<_ProjectCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedCard(
      glowColor: widget.project.color,
      onTap: () => setState(() => _isExpanded = !_isExpanded),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        widget.project.color,
                        widget.project.color.withValues(alpha: 0.6),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    widget.project.icon,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.project.name,
                        style: AppTheme.titleStyle,
                      ),
                      Text(
                        widget.project.subtitle,
                        style: AppTheme.bodyStyle.copyWith(
                          color: widget.project.color,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  _isExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: AppTheme.greyText,
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Description
            Text(
              widget.project.description,
              style: AppTheme.bodyStyle.copyWith(fontSize: 14),
              maxLines: _isExpanded ? null : 2,
              overflow: _isExpanded ? null : TextOverflow.ellipsis,
            ),

            const SizedBox(height: 16),

            // Technologies
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: widget.project.technologies
                  .map((tech) => Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: widget.project.color.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: widget.project.color.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Text(
                          tech,
                          style: TextStyle(
                            color: widget.project.color,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ))
                  .toList(),
            ),

            // Features (shown when expanded)
            if (_isExpanded) ...[
              const SizedBox(height: 20),
              Text(
                "Key Features",
                style: AppTheme.bodyStyle.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              ...widget.project.features.map(
                (feature) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: widget.project.color,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          feature,
                          style: AppTheme.bodyStyle.copyWith(fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    )
        .animate(delay: Duration(milliseconds: 100 * widget.index))
        .fadeIn()
        .slideY(begin: 0.2);
  }
}

// Experience Section
class _ExperienceSection extends StatelessWidget {
  final bool isDesktop;

  const _ExperienceSection({required this.isDesktop});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 100 : 30,
        vertical: 100,
      ),
      child: Column(
        children: [
          const SectionTitle(
            title: "Experience",
            subtitle: "My professional journey and growth",
          ),
          const SizedBox(height: 60),

          // Timeline
          ...PortfolioData.experiences.asMap().entries.map((entry) {
            final index = entry.key;
            final experience = entry.value;
            return _ExperienceCard(
              experience: experience,
              index: index,
              isLast: index == PortfolioData.experiences.length - 1,
              isDesktop: isDesktop,
            );
          }),

          const SizedBox(height: 60),

          // Education
          const SectionTitle(
            title: "Education",
          ),
          const SizedBox(height: 40),

          Wrap(
            spacing: 30,
            runSpacing: 30,
            alignment: WrapAlignment.center,
            children: PortfolioData.education.asMap().entries.map((entry) {
              return _EducationCard(
                education: entry.value,
                index: entry.key,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _ExperienceCard extends StatelessWidget {
  final Experience experience;
  final int index;
  final bool isLast;
  final bool isDesktop;

  const _ExperienceCard({
    required this.experience,
    required this.index,
    required this.isLast,
    required this.isDesktop,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline indicator
          if (isDesktop)
            SizedBox(
              width: 60,
              child: Column(
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [experience.color, experience.color.withValues(alpha: 0.6)],
                      ),
                      shape: BoxShape.circle,
                    ),
                  ),
                  if (!isLast)
                    Expanded(
                      child: Container(
                        width: 2,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              experience.color,
                              experience.color.withValues(alpha: 0.1),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

          // Content
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 40),
              child: AnimatedCard(
                glowColor: experience.color,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  experience.company,
                                  style: AppTheme.titleStyle.copyWith(
                                    color: experience.color,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  experience.role,
                                  style: AppTheme.bodyStyle.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: experience.color.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: experience.color.withValues(alpha: 0.3),
                              ),
                            ),
                            child: Text(
                              experience.duration,
                              style: TextStyle(
                                color: experience.color,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        experience.description,
                        style: AppTheme.bodyStyle,
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 16,
                        runSpacing: 8,
                        children: experience.highlights
                            .map((highlight) => Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.arrow_right,
                                      color: experience.color,
                                      size: 20,
                                    ),
                                    Text(
                                      highlight,
                                      style: AppTheme.bodyStyle.copyWith(
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ))
                            .toList(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    )
        .animate(delay: Duration(milliseconds: 200 * index))
        .fadeIn()
        .slideX(begin: 0.2);
  }
}

class _EducationCard extends StatelessWidget {
  final Education education;
  final int index;

  const _EducationCard({
    required this.education,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedCard(
      glowColor: AppTheme.secondaryColor,
      child: Container(
        width: 350,
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.secondaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.school_rounded,
                    color: AppTheme.secondaryColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    education.degree,
                    style: AppTheme.titleStyle.copyWith(fontSize: 16),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              education.institution,
              style: AppTheme.bodyStyle,
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  education.duration,
                  style: AppTheme.bodyStyle.copyWith(
                    color: AppTheme.secondaryColor,
                    fontSize: 13,
                  ),
                ),
                if (education.score.isNotEmpty)
                  Text(
                    education.score,
                    style: AppTheme.bodyStyle.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    )
        .animate(delay: Duration(milliseconds: 200 * index))
        .fadeIn()
        .slideY(begin: 0.2);
  }
}

// Contact Section
class _ContactSection extends StatelessWidget {
  const _ContactSection();

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 1024;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 100 : 30,
        vertical: 100,
      ),
      child: Column(
        children: [
          const SectionTitle(
            title: "Get In Touch",
            subtitle: "Let's build something amazing together",
          ),
          const SizedBox(height: 60),

          AnimatedCard(
            glowColor: AppTheme.accentColor,
            child: Container(
              width: isDesktop ? 800 : double.infinity,
              padding: const EdgeInsets.all(40),
              child: Column(
                children: [
                  GradientText(
                    text: "Let's Connect!",
                    style: AppTheme.titleStyle.copyWith(fontSize: 28),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "I'm currently open to new opportunities and collaborations. Whether you have a project in mind or just want to say hi, feel free to reach out!",
                    style: AppTheme.bodyStyle,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),

                  // Contact Cards
                  Wrap(
                    spacing: 20,
                    runSpacing: 20,
                    alignment: WrapAlignment.center,
                    children: [
                      _ContactItem(
                        icon: Icons.email_rounded,
                        label: "Email",
                        value: PortfolioData.email,
                        url: "mailto:${PortfolioData.email}",
                        color: AppTheme.primaryColor,
                      ),
                      _ContactItem(
                        icon: Icons.phone_rounded,
                        label: "Phone",
                        value: PortfolioData.phone,
                        url: "tel:${PortfolioData.phone}",
                        color: AppTheme.secondaryColor,
                      ),
                      _ContactItem(
                        icon: Icons.location_on_rounded,
                        label: "Location",
                        value: PortfolioData.location,
                        url: "",
                        color: AppTheme.accentColor,
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),

                  // Social Links
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: PortfolioData.socialLinks
                        .map((link) => _SocialIcon(
                              icon: link.icon,
                              url: link.url,
                              delay: 0,
                            ))
                        .toList(),
                  ),
                ],
              ),
            ),
          ).animate().fadeIn().slideY(begin: 0.2),
        ],
      ),
    );
  }
}

class _ContactItem extends StatefulWidget {
  final IconData icon;
  final String label;
  final String value;
  final String url;
  final Color color;

  const _ContactItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.url,
    required this.color,
  });

  @override
  State<_ContactItem> createState() => _ContactItemState();
}

class _ContactItemState extends State<_ContactItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.url.isNotEmpty
            ? () => launchUrl(Uri.parse(widget.url))
            : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: _isHovered
                ? widget.color.withValues(alpha: 0.1)
                : AppTheme.darkCard.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _isHovered
                  ? widget.color
                  : Colors.white.withValues(alpha: 0.1),
            ),
          ),
          child: Column(
            children: [
              Icon(
                widget.icon,
                color: widget.color,
                size: 24,
              ),
              const SizedBox(height: 12),
              Text(
                widget.label,
                style: AppTheme.bodyStyle.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                widget.value,
                style: AppTheme.bodyStyle.copyWith(fontSize: 13),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Footer
class _Footer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: AppTheme.darkCard.withValues(alpha: 0.5),
        border: Border(
          top: BorderSide(
            color: Colors.white.withValues(alpha: 0.1),
          ),
        ),
      ),
      child: Column(
        children: [
          GradientText(
            text: "<YS/>",
            style: GoogleFonts.firaCode(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "Built with Flutter 💙",
            style: AppTheme.bodyStyle.copyWith(fontSize: 14),
          ),
          const SizedBox(height: 8),
          Text(
            "© ${DateTime.now().year} Yuvaraj S. All rights reserved.",
            style: AppTheme.bodyStyle.copyWith(fontSize: 12),
          ),
        ],
      ),
    );
  }
}
