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
  await _replaceSymlinkWithRealFile(temDir);
  await _publish(temDir);
}

Future<void> _copy(Directory from, Directory dest) async {
  final paths =
      from.listSync(recursive: true, followLinks: false).map((e) => path.relative(e.path, from: from.path)).toList();

  final checkIgnoreResult =
      Process.runSync("git", ["check-ignore", "--no-index", ...paths], workingDirectory: from.path);

  final gitIgnored = LineSplitter.split(checkIgnoreResult.stdout.toString().trim()).toList();

  gitIgnored.addAll([".git", "tools"]);
  bool isGitIgnored(String relativePath) {
    if (gitIgnored.any((element) => relativePath.startsWith(element))) {
      return true;
    }
    return false;
  }

  void copyDirectory(Directory source, Directory destination) =>
      source.listSync(recursive: false, followLinks: false).forEach((var entity) {
        if (isGitIgnored(path.relative(entity.path, from: from.path))) {
          return;
        }
        if (entity is Directory) {
          var newDirectory = Directory(path.join(destination.path, path.basename(entity.path)));
          newDirectory.createSync();
          copyDirectory(entity, newDirectory);
        } else if (entity is File) {
          entity.copySync(path.join(destination.path, path.basename(entity.path)));
        } else if (entity is Link) {
          var newLink = Link(path.join(destination.path, path.basename(entity.path)));
          newLink.createSync(entity.targetSync());
        }
      });
  copyDirectory(from, dest);
}

Future<void> _replaceSymlinkWithRealFile(Directory dir) async {
  final files = dir.listSync(recursive: true);
  files.forEach((file) {
    if (file is File) {
      final path = file.resolveSymbolicLinksSync();
      if (path != file.path) {
        file.deleteSync();
        File(path).copySync(file.path);
        print("replaced " + file.path + " by $path");
      }
    }
  });
}

Future<void> _publish(Directory dir) async {
  final process = await Process.start("flutter", ["pub", "publish"], workingDirectory: dir.path);
  process.stdin.addStream(stdin);
  stdout.addStream(process.stdout);
  stderr.addStream(process.stderr);
  final code = await process.exitCode;
  if (code != 0) {
    exit(code);
  }
}
