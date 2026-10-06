import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../data/portfolio_data.dart';
import '../theme/app_theme.dart';
import '../theme/layout.dart';

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
            DecoratedBox(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF0E1218), AppTheme.background],
                ),
              ),
              child: ScrollConfiguration(
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
        color: AppTheme.background.withValues(alpha: 0.92),
        elevation: 0,
        child: DecoratedBox(
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: AppTheme.border)),
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
                  Text(
                    'YS',
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.accent,
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
                            child: Text(
                              labels[i],
                              style: AppTheme.label.copyWith(
                                color: active ? AppTheme.textPrimary : AppTheme.textMuted,
                                fontWeight: active ? FontWeight.w600 : FontWeight.w500,
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
            Text('Hello — I\'m', style: AppTheme.label),
            const SizedBox(height: 12),
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: isDesktop ? Alignment.centerLeft : Alignment.center,
              child: Text(PortfolioData.name, style: headline),
            ),
            const SizedBox(height: 12),
            Text(
              PortfolioData.role,
              style: AppTheme.cardTitle.copyWith(
                color: AppTheme.accent,
                fontSize: isDesktop ? 22 : 18,
              ),
            ),
            const SizedBox(height: 20),
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: isDesktop ? 520 : double.infinity),
              child: Text(
                PortfolioData.shortBio,
                style: AppTheme.body.copyWith(fontSize: isDesktop ? 17 : 16),
                textAlign: isDesktop ? TextAlign.start : TextAlign.center,
              ),
            ),
            const SizedBox(height: 32),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              alignment: isDesktop ? WrapAlignment.start : WrapAlignment.center,
              children: [
                FilledButton(
                  onPressed: onProjects,
                  style: FilledButton.styleFrom(
                    backgroundColor: AppTheme.accent,
                    foregroundColor: AppTheme.background,
                    padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                    ),
                  ),
                  child: const Text('View projects'),
                ),
                OutlinedButton(
                  onPressed: () => launchUrl(Uri.parse('mailto:${PortfolioData.email}')),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.textPrimary,
                    side: const BorderSide(color: AppTheme.border),
                    padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                    ),
                  ),
                  child: const Text('Contact'),
                ),
              ],
            ),
            const SizedBox(height: 36),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              alignment: isDesktop ? WrapAlignment.start : WrapAlignment.center,
              children: PortfolioData.socialLinks
                  .map((l) => _IconLink(icon: l.icon, url: l.url, label: l.name))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _IconLink extends StatelessWidget {
  const _IconLink({required this.icon, required this.url, required this.label});

  final IconData icon;
  final String url;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: label,
      child: InkWell(
        onTap: () => launchUrl(Uri.parse(url)),
        borderRadius: BorderRadius.circular(AppTheme.radiusSm),
        child: Ink(
          decoration: AppTheme.cardDecoration(),
          padding: const EdgeInsets.all(12),
          child: Icon(icon, size: 20, color: AppTheme.textSecondary),
        ),
      ),
    );
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
          const _SectionHeader(title: 'About', subtitle: 'Background & skills'),
          const SizedBox(height: 32),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(LayoutBreakpoints.isCompact(width) ? 20 : 28),
            decoration: AppTheme.cardDecoration(),
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
          const SizedBox(height: 28),
          _ResponsiveWrap(
            width: contentW,
            spacing: 16,
            children: PortfolioData.skillCategories
                .map(
                  (cat) => _SkillCard(category: cat),
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
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: AppTheme.cardDecoration(),
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
                      color: AppTheme.surfaceElevated,
                      borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                      border: Border.all(color: AppTheme.border),
                    ),
                    child: Text(s, style: AppTheme.label),
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
          const _SectionHeader(
            title: 'Projects',
            subtitle: 'By company — SpyNxt, Navin Electricals, TMI Inputs',
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
          _ResponsiveWrap(
            width: LayoutBreakpoints.contentWidth(width, padding),
            spacing: 16,
            minItemWidth: 300,
            children: items.map((p) => _ProjectTile(project: p)).toList(),
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
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: AppTheme.cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceElevated,
                  borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                ),
                child: Icon(project.icon, size: 22, color: AppTheme.accent),
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
              color: AppTheme.accentMuted.withValues(alpha: 0.25),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              project.company,
              style: AppTheme.label.copyWith(
                color: AppTheme.accent,
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
          const _SectionHeader(title: 'Experience', subtitle: 'Where I\'ve worked'),
          const SizedBox(height: 28),
          ...PortfolioData.experiences.map(
            (e) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _ExperienceTile(
                experience: e,
                stackHeader: LayoutBreakpoints.isCompact(width),
              ),
            ),
          ),
          const SizedBox(height: 24),
          const _SectionHeader(title: 'Education', subtitle: null),
          const SizedBox(height: 20),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: PortfolioData.education
                .map(
                  (ed) => SizedBox(
                    width: LayoutBreakpoints.isExpanded(width)
                        ? 360
                        : width - padding.horizontal,
                    child: Container(
                      padding: const EdgeInsets.all(22),
                      decoration: AppTheme.cardDecoration(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(ed.degree, style: AppTheme.cardTitle),
                          const SizedBox(height: 6),
                          Text(ed.institution, style: AppTheme.body.copyWith(fontSize: 14)),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(ed.duration, style: AppTheme.label),
                              if (ed.score.isNotEmpty)
                                Text(ed.score, style: AppTheme.label.copyWith(
                                  color: AppTheme.textPrimary,
                                )),
                            ],
                          ),
                        ],
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

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: AppTheme.cardDecoration(),
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
          const _SectionHeader(
            title: 'Contact',
            subtitle: 'Open to roles and freelance Flutter work',
          ),
          const SizedBox(height: 28),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              _ContactCard(
                width: cardWidth,
                icon: Icons.mail_outline_rounded,
                title: 'Email',
                value: PortfolioData.email,
                onTap: () => launchUrl(Uri.parse('mailto:${PortfolioData.email}')),
              ),
              _ContactCard(
                width: cardWidth,
                icon: Icons.phone_outlined,
                title: 'Phone',
                value: PortfolioData.phone,
                onTap: () => launchUrl(Uri.parse('tel:${PortfolioData.phone}')),
              ),
              _ContactCard(
                width: cardWidth,
                icon: Icons.location_on_outlined,
                title: 'Location',
                value: PortfolioData.location,
                onTap: null,
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppTheme.radiusMd),
          child: Ink(
            decoration: AppTheme.cardDecoration(),
            padding: const EdgeInsets.all(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, color: AppTheme.accent, size: 24),
                const SizedBox(height: 12),
                Text(title, style: AppTheme.label),
                const SizedBox(height: 4),
                Text(value, style: AppTheme.body.copyWith(color: AppTheme.textPrimary)),
              ],
            ),
          ),
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
        Text(title, style: AppTheme.sectionTitle),
        if (subtitle != null) ...[
          const SizedBox(height: 8),
          Text(subtitle!, style: AppTheme.body.copyWith(fontSize: 15)),
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
    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: AppTheme.cardDecoration(highlighted: true),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(value, style: AppTheme.displayMedium.copyWith(fontSize: 28)),
          const SizedBox(height: 4),
          Text(label, style: AppTheme.label),
        ],
      ),
    );
  }
}

/// Multi-column wrap that sizes children by available width (no fixed aspect ratio).
class _ResponsiveWrap extends StatelessWidget {
  const _ResponsiveWrap({
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
