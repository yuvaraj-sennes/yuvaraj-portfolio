import 'package:flutter_test/flutter_test.dart';

import 'package:about/data/portfolio_data.dart';

void main() {
  test('Portfolio content is configured', () {
    expect(PortfolioData.name, 'Yuvaraj S');
    expect(PortfolioData.yearsExperience, greaterThanOrEqualTo(3));
    expect(PortfolioData.projects.length, greaterThanOrEqualTo(10));
  });
}
