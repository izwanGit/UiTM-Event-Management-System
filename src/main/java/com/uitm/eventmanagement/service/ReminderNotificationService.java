package com.uitm.eventmanagement.service;
import java.io.IOException;
import com.uitm.eventmanagement.model.GmailEvent;
import com.uitm.eventmanagement.model.GmailParticipant;
public class ReminderNotificationService {
    private EmailService emailService = new EmailService();
    public void sendReminders(GmailEvent event, GmailParticipant participant) throws IOException {
        String subject = "Reminder: " + event.getEventName();
        String body = "Hello " + participant.getParticipantName() + ",\n\n"
                    + "This is a reminder for your event:\n"
                    + "Event: " + event.getEventName() + "\n"
                    + "Date: " + event.getEventDate() + "\n"
                    + "Time: " + event.getEventTime() + "\n"
                    + "Location: " + event.getEventLocation() + "\n\n"
                    + "Thank you!";
        
        emailService.sendEmail(participant.getParticipantEmail(), subject, body);
    }
}