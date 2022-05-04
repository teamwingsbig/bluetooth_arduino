class api_url{
  //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    github token

  static String apiBaseURL="http://almafnoodcomputers.zapto.org:4000/api";

  static String loginURL="$apiBaseURL/login";
  static String dashboardURL="$apiBaseURL/dashboard";
  static String saveDoctor_URL="$apiBaseURL/login/saveDoctor";
  static String saveCheckup_URL="$apiBaseURL/login/saveCheckup";
  static String savePatient_URL="$apiBaseURL/login/savePatient";
  static String getDoctorProfile_URL="$apiBaseURL/login/fetchDoctorProfile?userid=";
  static String getPatientProfile_URL="$apiBaseURL/login/fetchPatientProfile?userid=";
  static String getPatientList_URL="$apiBaseURL/login/fetchPatientList";
  static String getPatientCheckupList_URL="$apiBaseURL/login/fetchPatientHistory?patientid=";

}