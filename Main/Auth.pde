// Daniel Shiffman               
// http://www.shiffman.net       

// Simple Authenticator          
// Careful, this is terribly unsecure!!

import javax.mail.Authenticator;
import javax.mail.PasswordAuthentication;

public class GmailAuth extends Authenticator {

  public GmailAuth() {
    super();
  }

  public PasswordAuthentication getPasswordAuthentication() {
    String username, password;
    username = "oneshotvideotii@gmail.com";
    password = "oneshotrocks";
    System.out.println("authenticating. . ");
    return new PasswordAuthentication(username, password);
  }
}
