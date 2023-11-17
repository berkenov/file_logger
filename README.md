# file_logger
// Write to a log file
await writeToFile("Sample log entry");

// Get all log files with .log.txt extension
List<File> logFiles = await getLogsFiles();

// Get all files or files with a specific extension
List<File> allFiles = await getFiles();
List<File> txtFiles = await getFiles(fileExtension: '.txt');
