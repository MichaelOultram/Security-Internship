#include <random>
#include <string>
#include <iostream>
#include <fstream>

void stringCheck() {

	std::string input;
	std::string password = "<%= @password %>"; // ruby generate random string
	std::cout << "Password: " << password << std::endl;

	std::cout << "Insert your password: " << std::endl;
	std::cin >> input;

	bool check = false;

	if (input[0] == password[0]) {
		if (input[1] == password[1]) {
			if (input[2] == password[2]) {
				if (input[3] == password[3]) {
					if (input[4] == password[3] - 1) {
						if (input[5] > password[2]) {
							check = true;
							system("chmod 755 tokenRE.txt");
							//OPEN FILE
							std::string line;
							std::ifstream myfile("tokenRE.txt");
							if (myfile.is_open()) {
								while (getline(myfile, line)) {
									std::cout << line << '\n';
								}
								myfile.close();
							}
						}
					}
				}
			}
		}
	}

	if (check == false) {
		std::cout << "Incorrect password" << std::endl;
	}
}

int main() {
	stringCheck();
}