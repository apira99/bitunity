import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';

class EmailService {
  static Future<bool> sendActivationEmail(String parentEmail, String activationLink) async {
    // Use your actual email and app password (if 2FA is enabled)
    final smtpServer = gmail('japira1899@gmail.com', 'lhdm tnfz nihz dktv');

    final message = Message()
      ..from = Address('japira1899@gmail.com', 'Fruitykid')
      ..recipients.add(parentEmail)
      ..subject = 'Activate your Fruitykid account'
      ..html = '''
        <html>
        <body>
          <h1>Welcome to Fruitykid!</h1>
          <p>Please click the button below to verify your email address and activate your account:</p>
          <a href="$activationLink" style="padding: 10px 20px; background-color: #007BFF; color: white; text-decoration: none; border-radius: 5px;">Verify Email</a>
          <p>If the button doesn't work, copy and paste the following link into your browser:</p>
          <p>$activationLink</p>
        </body>
        </html>
      ''';

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ' + sendReport.toString());
      return true;
    } catch (e) {
      print('Message not sent. $e');
      return false;
    }
  }
}
