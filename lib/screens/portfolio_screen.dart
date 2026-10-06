import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../data/portfolio_data.dart';
import '../theme/app_theme.dart';
import '../theme/layout.dart';
import '../widgets/ambient_background.dart';
import '../widgets/glow_card.dart';
import '../widgets/gradient_text.dart';
import '../widgets/reveal.dart';

class PortfolioScreen extends StatefulWidget {
  const PortfolioScreen({super.key});

  @override
  State<PortfolioScreen> createState() => _PortfolioScreenState();
}

class _PortfolioScreenState extends State<PortfolioScreen> {
  final ScrollController _scrollController = ScrollController();
  final List<GlobalKey> _sectionKeys = List.generate(5, (_) => GlobalKey());
  int _navIndex = 0;
  String _projectFilter = 'All';

  static const _navLabels = ['Home', 'About', 'Projects', 'Experience', 'Contact'];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  RenderBox? _sectionRenderBox(int i) {
    final ctx = _sectionKeys[i].currentContext;
    if (ctx == null) return null;
    final ro = ctx.findRenderObject();
    if (ro is RenderBox && ro.hasSize) return ro;
    return null;
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    var index = 0;
    for (var i = _sectionKeys.length - 1; i >= 0; i--) {
      final box = _sectionRenderBox(i);
      if (box == null) continue;
      final dy = box.localToGlobal(Offset.zero).dy;
      if (dy <= 120) {
        index = i;
        break;
      }
    }
    if (index != _navIndex) {
      setState(() => _navIndex = index);
    }
  }

  void _goToSection(int index) {
    final ctx = _sectionKeys[index].currentContext;
    if (ctx != null) {
      Scrollable.ensureVisible(
        ctx,
        duration: const Duration(milliseconds: 550),
        curve: Curves.easeOutCubic,
        alignment: 0.08,
      );
    }
    setState(() => _navIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final sectionPad = LayoutBreakpoints.pagePadding(width);

    return Theme(
      data: Theme.of(context).copyWith(
        splashFactory: NoSplash.splashFactory,
        highlightColor: Colors.transparent,
      ),
      child: Scaffold(
        backgroundColor: AppTheme.background,
        body: Stack(
          children: [
            const AmbientBackground(),
            ScrollConfiguration(
                behavior: ScrollConfiguration.of(context).copyWith(
                  scrollbars: true,
                  physics: const ClampingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics(),
                  ),
                ),
                child: CustomScrollView(
                  controller: _scrollController,
                  slivers: [
                    SliverToBoxAdapter(
                      child: SectionAnchor(
                        key: _sectionKeys[0],
                        child: PageContent(
                          child: _HeroSection(
                            width: width,
                            padding: sectionPad,
                            onProjects: () => _goToSection(2),
                          ),
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: SectionAnchor(
                        key: _sectionKeys[1],
                        child: PageContent(
                          child: _AboutSection(
                            padding: sectionPad,
                            width: width,
                          ),
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: SectionAnchor(
                        key: _sectionKeys[2],
                        child: PageContent(
                          child: _ProjectsSection(
                            padding: sectionPad,
                            width: width,
                            filter: _projectFilter,
                            onFilterChanged: (v) =>
                                setState(() => _projectFilter = v),
                          ),
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: SectionAnchor(
                        key: _sectionKeys[3],
                        child: PageContent(
                          child: _ExperienceSection(
                            padding: sectionPad,
                            width: width,
                          ),
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: SectionAnchor(
                        key: _sectionKeys[4],
                        child: PageContent(
                          child: _ContactSection(
                            padding: sectionPad,
                            width: width,
                          ),
                        ),
                      ),
                    ),
                    const SliverToBoxAdapter(child: _Footer()),
                  ],
                ),
            ),
            _TopBar(
              width: width,
              selected: _navIndex,
              labels: _navLabels,
              onSelect: _goToSection,
            ),
          ],
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({
    required this.width,
    required this.selected,
    required this.labels,
    required this.onSelect,
  });

  final double width;
  final int selected;
  final List<String> labels;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Material(
        color: AppTheme.background.withValues(alpha: 0.78),
        elevation: 0,
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: AppTheme.primary.withValues(alpha: 0.25),
              ),
            ),
            gradient: LinearGradient(
              colors: [
                AppTheme.surface.withValues(alpha: 0.5),
                AppTheme.background.withValues(alpha: 0.2),
              ],
            ),
          ),
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: LayoutBreakpoints.isExpanded(width) ? 48 : 20,
                vertical: 14,
              ),
              child: Row(
                children: [
                  GradientText(
                    text: '<YS/>',
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const Spacer(),
                  if (width >= LayoutBreakpoints.medium)
                    Flexible(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: List.generate(labels.length, (i) {
                        final active = i == selected;
                        return Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: TextButton(
                            onPressed: () => onSelect(i),
                            style: TextButton.styleFrom(
                              foregroundColor:
                                  active ? AppTheme.textPrimary : AppTheme.textMuted,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 10,
                              ),
                            ),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                                vertical: 2,
                              ),
                              decoration: active
                                  ? BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          color: AppTheme.secondary,
                                          width: 2,
                                        ),
                                      ),
                                    )
                                  : null,
                              child: Text(
                                labels[i],
                                style: AppTheme.label.copyWith(
                                  color: active
                                      ? AppTheme.textPrimary
                                      : AppTheme.textMuted,
                                  fontWeight:
                                      active ? FontWeight.w600 : FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        );
                          }),
                        ),
                      ),
                    )
                  else
                    PopupMenuButton<int>(
                      icon: const Icon(Icons.menu_rounded, color: AppTheme.textSecondary),
                      color: AppTheme.surface,
                      onSelected: onSelect,
                      itemBuilder: (context) => List.generate(
                        labels.length,
                        (i) => PopupMenuItem(
                          value: i,
                          child: Text(labels[i], style: AppTheme.body),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _HeroSection extends StatelessWidget {
  const _HeroSection({
    required this.width,
    required this.padding,
    required this.onProjects,
  });

  final double width;
  final EdgeInsets padding;
  final VoidCallback onProjects;

  @override
  Widget build(BuildContext context) {
    final isDesktop = LayoutBreakpoints.isExpanded(width);
    final isCompact = LayoutBreakpoints.isCompact(width);
    final headline = isDesktop
        ? AppTheme.displayLarge
        : AppTheme.displayMedium.copyWith(
            fontSize: isCompact ? 32 : 36,
          );

    return Padding(
      padding: padding.copyWith(top: padding.top + 72),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: MediaQuery.sizeOf(context).height * (isDesktop ? 0.82 : 0.7),
        ),
        child: Column(
          crossAxisAlignment:
              isDesktop ? CrossAxisAlignment.start : CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Hello — I\'m', style: AppTheme.label)
                .animate()
                .fadeIn(duration: 500.ms)
                .slideY(begin: 0.2, curve: Curves.easeOutCubic),
            const SizedBox(height: 12),
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: isDesktop ? Alignment.centerLeft : Alignment.center,
              child: GradientText(text: PortfolioData.name, style: headline),
            )
                .animate(delay: 120.ms)
                .fadeIn(duration: 600.ms)
                .slideX(begin: isDesktop ? -0.08 : 0, curve: Curves.easeOutCubic),
            const SizedBox(height: 16),
            SizedBox(
              height: isDesktop ? 40 : 32,
              child: DefaultTextStyle(
                style: AppTheme.cardTitle.copyWith(
                  fontSize: isDesktop ? 24 : 20,
                  color: AppTheme.secondary,
                ),
                child: AnimatedTextKit(
                  repeatForever: true,
                  pause: const Duration(milliseconds: 1800),
                  animatedTexts: [
                    FadeAnimatedText(
                      'Flutter Developer',
                      duration: const Duration(milliseconds: 2200),
                    ),
                    FadeAnimatedText(
                      'Mobile App Engineer',
                      duration: const Duration(milliseconds: 2200),
                    ),
                    FadeAnimatedText(
                      'Clean Architecture · BLoC',
                      duration: const Duration(milliseconds: 2200),
                    ),
                  ],
                ),
              ),
            ).animate(delay: 280.ms).fadeIn(duration: 500.ms),
            const SizedBox(height: 20),
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: isDesktop ? 520 : double.infinity),
              child: Text(
                PortfolioData.shortBio,
                style: AppTheme.body.copyWith(fontSize: isDesktop ? 17 : 16),
                textAlign: isDesktop ? TextAlign.start : TextAlign.center,
              ),
            ).animate(delay: 400.ms).fadeIn(duration: 550.ms),
            const SizedBox(height: 32),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              alignment: isDesktop ? WrapAlignment.start : WrapAlignment.center,
              children: [
                _GradientButton(label: 'View projects', onTap: onProjects),
                _OutlineGlowButton(
                  label: 'Contact',
                  onTap: () => launchUrl(Uri.parse('mailto:${PortfolioData.email}')),
                ),
              ],
            ).animate(delay: 520.ms).fadeIn().slideY(begin: 0.15),
            const SizedBox(height: 36),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              alignment: isDesktop ? WrapAlignment.start : WrapAlignment.center,
              children: PortfolioData.socialLinks
                  .asMap()
                  .entries
                  .map(
                    (e) => _IconLink(
                      icon: e.value.icon,
                      url: e.value.url,
                      label: e.value.name,
                      delayMs: 600 + e.key * 80,
                    ),
                  )
                  .toList(),
            ),
            if (isDesktop) ...[
              const Spacer(),
              Icon(Icons.keyboard_arrow_down_rounded, color: AppTheme.secondary)
                  .animate(onPlay: (c) => c.repeat(reverse: true))
                  .moveY(begin: 0, end: 8, duration: 1200.ms, curve: Curves.easeInOut),
            ],
          ],
        ),
      ),
    );
  }
}

class _GradientButton extends StatefulWidget {
  const _GradientButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  State<_GradientButton> createState() => _GradientButtonState();
}

class _GradientButtonState extends State<_GradientButton> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
          decoration: BoxDecoration(
            gradient: AppTheme.brandGradient,
            borderRadius: BorderRadius.circular(AppTheme.radiusSm),
            boxShadow: _hover
                ? [
                    BoxShadow(
                      color: AppTheme.primary.withValues(alpha: 0.45),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ]
                : [],
          ),
          transform: _hover
              ? Matrix4.translationValues(0, -2, 0)
              : Matrix4.identity(),
          child: Text(
            widget.label,
            style: AppTheme.cardTitle.copyWith(
              fontSize: 15,
              color: AppTheme.backgroundDeep,
            ),
          ),
        ),
      ),
    );
  }
}

class _OutlineGlowButton extends StatefulWidget {
  const _OutlineGlowButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  State<_OutlineGlowButton> createState() => _OutlineGlowButtonState();
}

class _OutlineGlowButtonState extends State<_OutlineGlowButton> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppTheme.radiusSm),
            border: Border.all(
              color: _hover ? AppTheme.secondary : AppTheme.border,
              width: 1.5,
            ),
            color: _hover
                ? AppTheme.secondary.withValues(alpha: 0.08)
                : Colors.transparent,
          ),
          child: Text(widget.label, style: AppTheme.cardTitle.copyWith(fontSize: 15)),
        ),
      ),
    );
  }
}

class _IconLink extends StatelessWidget {
  const _IconLink({
    required this.icon,
    required this.url,
    required this.label,
    this.delayMs = 0,
  });

  final IconData icon;
  final String url;
  final String label;
  final int delayMs;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: label,
      child: GlowCard(
        padding: const EdgeInsets.all(12),
        child: InkWell(
          onTap: () => launchUrl(Uri.parse(url)),
          child: Icon(icon, size: 20, color: AppTheme.textSecondary),
        ),
      ),
    )
        .animate(delay: Duration(milliseconds: delayMs))
        .fadeIn(duration: 400.ms)
        .scale(begin: const Offset(0.85, 0.85));
  }
}

class _AboutSection extends StatelessWidget {
  const _AboutSection({required this.padding, required this.width});

  final EdgeInsets padding;
  final double width;

  @override
  Widget build(BuildContext context) {
    final contentW = LayoutBreakpoints.contentWidth(width, padding);
    final statCols = LayoutBreakpoints.isCompact(width)
        ? 1
        : (LayoutBreakpoints.isMedium(width) ? 2 : 3);
    final statWidth = statCols == 1
        ? contentW
        : (contentW - 12 * (statCols - 1)) / statCols;

    return Padding(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Reveal(
            child: _SectionHeader(title: 'About', subtitle: 'Background & skills'),
          ),
          const SizedBox(height: 32),
          Reveal(
            delayMs: 80,
            child: GlowCard(
            highlighted: true,
            padding: EdgeInsets.all(LayoutBreakpoints.isCompact(width) ? 20 : 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(PortfolioData.bio, style: AppTheme.body),
                const SizedBox(height: 28),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    _StatChip(
                      width: statWidth,
                      value: '${PortfolioData.yearsExperience}+',
                      label: 'Years experience',
                    ),
                    _StatChip(
                      width: statWidth,
                      value: '${PortfolioData.projectCount}+',
                      label: 'Projects shipped',
                    ),
                    _StatChip(
                      width: statWidth,
                      value: '${PortfolioData.storeAppsCount}+',
                      label: 'Store releases',
                    ),
                  ],
                ),
              ],
            ),
          ),
          ),
          const SizedBox(height: 28),
          _ResponsiveWrap(
            width: contentW,
            spacing: 16,
            children: PortfolioData.skillCategories
                .asMap()
                .entries
                .map(
                  (e) => Reveal(
                    delayMs: 100 + e.key * 60,
                    child: _SkillCard(category: e.value),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _SkillCard extends StatelessWidget {
  const _SkillCard({required this.category});

  final SkillCategory category;

  @override
  Widget build(BuildContext context) {
    return GlowCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(category.title, style: AppTheme.cardTitle.copyWith(fontSize: 16)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: category.skills
                .map(
                  (s) => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppTheme.primary.withValues(alpha: 0.15),
                          AppTheme.secondary.withValues(alpha: 0.08),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                      border: Border.all(
                        color: AppTheme.primary.withValues(alpha: 0.25),
                      ),
                    ),
                    child: Text(s, style: AppTheme.label.copyWith(
                      color: AppTheme.textSecondary,
                    )),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _ProjectsSection extends StatelessWidget {
  const _ProjectsSection({
    required this.padding,
    required this.width,
    required this.filter,
    required this.onFilterChanged,
  });

  final EdgeInsets padding;
  final double width;
  final String filter;
  final ValueChanged<String> onFilterChanged;

  List<Project> get _filtered {
    if (filter == 'All') return PortfolioData.projects;
    return PortfolioData.projects.where((p) => p.company == filter).toList();
  }

  @override
  Widget build(BuildContext context) {
    final items = _filtered;

    return Padding(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Reveal(
            child: _SectionHeader(
              title: 'Projects',
              subtitle:
                'SpyNxt, Navin, TMI — plus public repos on GitHub',
            ),
          ),
          const SizedBox(height: 20),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: PortfolioData.projectCompanies.map((company) {
                final selected = company == filter;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(company),
                    selected: selected,
                    onSelected: (_) => onFilterChanged(company),
                    showCheckmark: false,
                    labelStyle: AppTheme.label.copyWith(
                      color: selected ? AppTheme.background : AppTheme.textSecondary,
                    ),
                    selectedColor: AppTheme.accent,
                    backgroundColor: AppTheme.surface,
                    side: BorderSide(
                      color: selected ? AppTheme.accent : AppTheme.border,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 24),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 450),
            switchInCurve: Curves.easeOutCubic,
            switchOutCurve: Curves.easeInCubic,
            transitionBuilder: (child, animation) {
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.03),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                ),
              );
            },
            child: _ResponsiveWrap(
              key: ValueKey(filter),
              width: LayoutBreakpoints.contentWidth(width, padding),
              spacing: 16,
              minItemWidth: 300,
              children: items
                  .asMap()
                  .entries
                  .map(
                    (e) => Reveal(
                      delayMs: 50 + e.key * 40,
                      slideY: 0.08,
                      child: _ProjectTile(project: e.value),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProjectTile extends StatelessWidget {
  const _ProjectTile({required this.project});

  final Project project;

  @override
  Widget build(BuildContext context) {
    final repo = project.repoUrl;

    return GlowCard(
      glowColor: AppTheme.secondary,
      onTap: repo != null ? () => launchUrl(Uri.parse(repo)) : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: AppTheme.brandGradient,
                  borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                ),
                child: Icon(project.icon, size: 22, color: Colors.white),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(project.name, style: AppTheme.cardTitle),
                    Text(project.subtitle, style: AppTheme.label),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.primary.withValues(alpha: 0.35),
                  AppTheme.secondary.withValues(alpha: 0.2),
                ],
              ),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              project.company,
              style: AppTheme.label.copyWith(
                color: AppTheme.secondary,
                fontSize: 11,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            project.description,
            style: AppTheme.body.copyWith(fontSize: 14),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: project.technologies
                .take(4)
                .map(
                  (t) => Text(
                    t,
                    style: AppTheme.label.copyWith(fontSize: 11),
                  ),
                )
                .toList(),
          ),
          if (repo != null) ...[
            const SizedBox(height: 14),
            Row(
              children: [
                Icon(Icons.open_in_new_rounded, size: 16, color: AppTheme.secondary),
                const SizedBox(width: 6),
                Text(
                  'View repository',
                  style: AppTheme.label.copyWith(color: AppTheme.secondary),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _ExperienceSection extends StatelessWidget {
  const _ExperienceSection({required this.padding, required this.width});

  final EdgeInsets padding;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Reveal(
            child: _SectionHeader(title: 'Experience', subtitle: 'Where I\'ve worked'),
          ),
          const SizedBox(height: 28),
          ...PortfolioData.experiences.asMap().entries.map(
            (entry) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Reveal(
                delayMs: 80 + entry.key * 100,
                child: _ExperienceTile(
                  experience: entry.value,
                  stackHeader: LayoutBreakpoints.isCompact(width),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Reveal(child: _SectionHeader(title: 'Education', subtitle: null)),
          const SizedBox(height: 20),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: PortfolioData.education
                .asMap()
                .entries
                .map(
                  (entry) => Reveal(
                    delayMs: 80 + entry.key * 100,
                    child: SizedBox(
                      width: LayoutBreakpoints.isExpanded(width)
                          ? 360
                          : width - padding.horizontal,
                      child: GlowCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(entry.value.degree, style: AppTheme.cardTitle),
                            const SizedBox(height: 6),
                            Text(
                              entry.value.institution,
                              style: AppTheme.body.copyWith(fontSize: 14),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(entry.value.duration, style: AppTheme.label),
                                if (entry.value.score.isNotEmpty)
                                  Text(
                                    entry.value.score,
                                    style: AppTheme.label.copyWith(
                                      color: AppTheme.textPrimary,
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _ExperienceTile extends StatelessWidget {
  const _ExperienceTile({required this.experience, required this.stackHeader});

  final Experience experience;
  final bool stackHeader;

  @override
  Widget build(BuildContext context) {
    final header = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          experience.company,
          style: AppTheme.cardTitle.copyWith(color: AppTheme.accent),
        ),
        const SizedBox(height: 4),
        Text(
          experience.role,
          style: AppTheme.body.copyWith(
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.w500,
          ),
        ),
        if (stackHeader) ...[
          const SizedBox(height: 8),
          Text(experience.duration, style: AppTheme.label),
        ],
      ],
    );

    return GlowCard(
      glowColor: AppTheme.primary,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (stackHeader)
            header
          else
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: header),
                Text(experience.duration, style: AppTheme.label),
              ],
            ),
          const SizedBox(height: 12),
          Text(experience.description, style: AppTheme.body.copyWith(fontSize: 15)),
          const SizedBox(height: 12),
          ...experience.highlights.map(
            (h) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.circle, size: 6, color: AppTheme.accent),
                  const SizedBox(width: 10),
                  Expanded(child: Text(h, style: AppTheme.body.copyWith(fontSize: 14))),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ContactSection extends StatelessWidget {
  const _ContactSection({required this.padding, required this.width});

  final EdgeInsets padding;
  final double width;

  @override
  Widget build(BuildContext context) {
    final cardWidth = LayoutBreakpoints.isCompact(width)
        ? width - padding.horizontal
        : 280.0;

    return Padding(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Reveal(
            child: _SectionHeader(
              title: 'Contact',
              subtitle: 'Open to roles and freelance Flutter work',
            ),
          ),
          const SizedBox(height: 28),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              Reveal(
                delayMs: 60,
                child: _ContactCard(
                  width: cardWidth,
                  icon: Icons.mail_outline_rounded,
                  title: 'Email',
                  value: PortfolioData.email,
                  onTap: () => launchUrl(Uri.parse('mailto:${PortfolioData.email}')),
                ),
              ),
              Reveal(
                delayMs: 120,
                child: _ContactCard(
                  width: cardWidth,
                  icon: Icons.phone_outlined,
                  title: 'Phone',
                  value: PortfolioData.phone,
                  onTap: () => launchUrl(Uri.parse('tel:${PortfolioData.phone}')),
                ),
              ),
              Reveal(
                delayMs: 180,
                child: _ContactCard(
                  width: cardWidth,
                  icon: Icons.location_on_outlined,
                  title: 'Location',
                  value: PortfolioData.location,
                  onTap: null,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ContactCard extends StatelessWidget {
  const _ContactCard({
    required this.width,
    required this.icon,
    required this.title,
    required this.value,
    required this.onTap,
  });

  final double width;
  final IconData icon;
  final String title;
  final String value;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: GlowCard(
        glowColor: AppTheme.secondary,
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: AppTheme.secondary, size: 24),
            const SizedBox(height: 12),
            Text(title, style: AppTheme.label),
            const SizedBox(height: 4),
            Text(value, style: AppTheme.body.copyWith(color: AppTheme.textPrimary)),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, this.subtitle});

  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 4,
              height: 28,
              decoration: BoxDecoration(
                gradient: AppTheme.brandGradient,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(title, style: AppTheme.sectionTitle)),
          ],
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Text(subtitle!, style: AppTheme.body.copyWith(fontSize: 15)),
          ),
        ],
      ],
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({
    required this.value,
    required this.label,
    this.width,
  });

  final String value;
  final String label;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: GlowCard(
      highlighted: true,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GradientText(
            text: value,
            style: AppTheme.displayMedium.copyWith(fontSize: 28, color: Colors.white),
          ),
          const SizedBox(height: 4),
          Text(label, style: AppTheme.label),
        ],
      ),
    ),
    );
  }
}

/// Multi-column wrap that sizes children by available width (no fixed aspect ratio).
class _ResponsiveWrap extends StatelessWidget {
  const _ResponsiveWrap({
    super.key,
    required this.width,
    required this.children,
    this.spacing = 16,
    this.minItemWidth = 280,
  });

  final double width;
  final List<Widget> children;
  final double spacing;
  final double minItemWidth;

  @override
  Widget build(BuildContext context) {
    final columns = LayoutBreakpoints.gridColumns(width);
    final totalSpacing = spacing * (columns - 1);
    final itemWidth = (width - totalSpacing) / columns;

    return Wrap(
      spacing: spacing,
      runSpacing: spacing,
      children: children
          .map(
            (child) => SizedBox(
              width: columns == 1 ? width : itemWidth.clamp(minItemWidth, width),
              child: child,
            ),
          )
          .toList(),
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 48),
      child: Column(
        children: [
          const Divider(color: AppTheme.border, height: 1),
          const SizedBox(height: 24),
          Text(
            '© ${DateTime.now().year} ${PortfolioData.name} · Built with Flutter',
            style: AppTheme.label,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
