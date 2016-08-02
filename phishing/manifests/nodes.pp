# Defines all the node definitions for all of the containers defined above
class phishing::nodes ($ip_start = "172.18.0") {
  include phishing::gateway
  include phishing::webserver
  include phishing::mailserver
  include phishing::victimpc
}
