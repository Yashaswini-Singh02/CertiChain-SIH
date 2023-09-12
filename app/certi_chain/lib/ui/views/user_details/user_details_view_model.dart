part of 'user_details_view.dart';

class UserDetailViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  TextEditingController nameController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController aadharController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  Future<void> handleSubmitButton(BuildContext context) async {
    log('Submit button pressed');
    Map<String, String> requestBody = {
      "name": nameController.text,
      "dob": dobController.text,
      "aadharNumber": aadharController.text,
      "email": emailController.text,
      "walletAddress": AuthLogic.evmPubAddress ?? '',
    };

    var url = Uri.parse('http://192.168.1.2:8080/api/v1/users');
    var response = await http.post(
      url,
      body: jsonEncode(requestBody),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 201) {
      log(response.body);
      log('Login and POST request successful');
      HelperFunction.name = nameController.text;
      _navigationService.clearStackAndShow(Routes.homeView);
    } else {
      log('Error in POST request: ${response.statusCode}');
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("POST Request Failed"),
          content: const Text("Please try again."),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("OK"),
            ),
          ],
        ),
      );
    }
  }
}
