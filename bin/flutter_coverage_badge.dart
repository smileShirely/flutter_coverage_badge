import 'dart:io';

import 'package:args/args.dart';
import 'package:flutter_coverage_badge/flutter_coverage_badge.dart';

Future main(List<String> args) async {
  final package = Directory.current;
  final parser = ArgParser();

  parser.addFlag('help', abbr: 'h', help: 'Show usage', negatable: false);
  parser.addFlag('badge',
      help: 'Generate coverage badge SVG image in your package root',
      defaultsTo: true);

  var excludeList = <String>[];

  parser.addMultiOption('exclude', abbr: 'e', help: 'Exclude',
      callback: (List<String> args) {
    excludeList = args;
  });

  final options = parser.parse(args);
  if (options.wasParsed('help')) {
    print(parser.usage);
    return;
  }
  //await runTestsWithCoverage(Directory.current.path).then((_) {
  //  print('Coverage report saved to "coverage/lcov.info".');
  //});
  final coverageFile = File('coverage/lcov.info');

  final lineCoverage = calculateLineCoverage(coverageFile);

  for (final excludeItem in excludeList) {
    await excludeCoverage(Directory.current.path, coverageFile, excludeItem);
  }

  generateBadge(package, lineCoverage);
  return;
}
