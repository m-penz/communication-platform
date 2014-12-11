class MailSender{// Daniel Shiffman               
// http://www.shiffman.net     


// Example functions that check mail (pop3) and send mail (smtp)
// You can also do imap, but that's not included here

private String subject="New meeting notes";
private String mailTextPrefix="Hello. Seems as if somebody has used the communication platform!\nThat's great.\n\n\nYou can listen to the audio recordings here: ";
// A function to send mail
void sendMail(String text) {
  // Create a session
  String host="smtp.gmail.com";
  Properties props=new Properties();

  // SMTP Session
  props.put("mail.transport.protoco l", "smtp");
  props.put("mail.smtp.host", host);
  props.put("mail.smtp.port", "25");
  props.put("mail.smtp.auth", "true");
  // We need TTLS, which gmail requires
  props.put("mail.smtp.starttls.enable","true");

  // Create a session
  Session session = Session.getDefaultInstance(props, new GmailAuth());

  try
  {
    // Make a new message
    MimeMessage message = new MimeMessage(session);

    // Who is this message from
    message.setFrom(new InternetAddress("oneshotvideotii@gmail.com", "Name"));

    // Who is this message to (we could do fancier things like make a list or add CC's)
    message.setRecipients(Message.RecipientType.TO, InternetAddress.parse("oneshotvideotii@gmail.com", false));

    // Subject and body
    message.setSubject(subject);
    message.setText(mailTextPrefix+text);

    // We can do more here, set the date, the headers, etc.
    Transport.send(message);
    println("Mail sent!");
  }
  catch(Exception e)
  {
    e.printStackTrace();
  }

}

}
