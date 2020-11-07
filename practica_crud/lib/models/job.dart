class Job {
  final int studentID;
  final String lastName;
  final String firstName;
  final DateTime enrollmentDate;

  Job({this.studentID, this.lastName, this.firstName, this.enrollmentDate});

  factory Job.fromJson(Map<String, dynamic> json) {
    return Job(
      studentID: json['StudentID'],
      lastName: json['LastName'],
      firstName: json['FirstName'],
      enrollmentDate: DateTime.parse(json['EnrollmentDate']),
    );
  }
}
