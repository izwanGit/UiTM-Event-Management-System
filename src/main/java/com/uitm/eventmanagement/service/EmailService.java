package com.uitm.eventmanagement.service;
import java.io.IOException;
import com.sendgrid.*;
public class EmailService {
    
    private static final String SENDGRID_API_KEY = "SENDGRID_API_KEY"; // Replace with your SendGrid API Key
    private static final String FROM_EMAIL = "uems.info@gmail.com"; // Replace with your sender email
	
    public void sendEmail(String to, String subject, String body) throws IOException {
        Email from = new Email(FROM_EMAIL);
        Email recipient = new Email(to);
        Content content = new Content("text/plain", body);
        Mail mail = new Mail(from, subject, recipient, content);
        SendGrid sg = new SendGrid(SENDGRID_API_KEY);
        Request request = new Request();
        
        try {
            request.setMethod(Method.POST);
            request.setEndpoint("mail/send");
            request.setBody(mail.build());
            Response response = sg.api(request);
            System.out.println("Response Code: " + response.getStatusCode());
            System.out.println("Response Body: " + response.getBody());
        } catch (IOException ex) {
            throw ex;
        }
    }
}