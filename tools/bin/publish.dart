import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as path;

main(List<String> args) async {
  final temDir = Directory.systemTemp.createTempSync("system_clock");
  print("temDir = ${temDir.path}");
  if (temDir.existsSync()) {
    temDir.deleteSync(recursive: true);
  }
  temDir.createSync(recursive: true);
  final rootPath = Process.runSync("git", ["rev-parse", "--show-toplevel"]);
  if (rootPath.exitCode != 0) {
    throw "Not a git project?";
  }
  await _copy(Directory(rootPath.stdout.toString().trim()), temDir);
  await _publish(temDir);
}

Future<void> _copy(Directory from, Directory dest) async {
  final files = Process.runSync(
    "git",
    ["ls-files", "--cached", "--others", "--exclude-standard"],
    workingDirectory: from.path,
  ).outputLines.map((e) => e.platformPath).toSet();

  from.listSync(recursive: true, followLinks: false).forEach((var entity) {
    final entityRelativePath = path.relative(entity.path, from: from.path).platformPath;
    if (!files.contains(entityRelativePath)) {
      return;
    }
    final dir = Directory(path.join(dest.path, path.dirname(entityRelativePath)));
    if (!dir.existsSync()) {
      dir.createSync(recursive: true);
    }
    if (entity is File) {
      entity.copySync(path.join(dest.path, entityRelativePath));
    } else if (entity is Link) {
      final newFilePath = path.normalize(path.join(dest.path, entityRelativePath));
      final target = File(path.normalize(path.absolute(path.dirname(entity.absolute.path), entity.targetSync())));
      target.copySync(newFilePath);
    }
  });
}

extension on String {
  String get platformPath {
    if (Platform.isWindows) {
      return replaceAll("/", "\\");
    } else {
      return replaceAll("\\", "/");
    }
  }
}

extension on ProcessResult {
  List<String> get outputLines {
    if (exitCode != 0) {
      throw "Can't get stdout. exitCode = $exitCode";
    }
    final out = this.stdout.toString().trim();
    return LineSplitter.split(out).toList();
  }
}

Future<void> _publish(Directory dir) async {
  Process process;
  if (Platform.isWindows) {
    process = await Process.start("pwsh", ["-Command", "flutter", "pub", "publish"], workingDirectory: dir.path);
  } else {
    process = await Process.start("flutter", ["pub", "publish"], workingDirectory: dir.path);
  }

  process.stdin.addStream(stdin);
  stdout.addStream(process.stdout);
  stderr.addStream(process.stderr);
  final code = await process.exitCode;
  if (code != 0) {
    exit(code);
  }
}
