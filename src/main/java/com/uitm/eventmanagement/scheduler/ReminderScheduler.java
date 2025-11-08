package com.uitm.eventmanagement.scheduler;

import java.util.List;
import java.util.Timer;
import java.util.TimerTask;
import java.util.logging.Level;
import java.util.logging.Logger;

import com.uitm.eventmanagement.dao.GmailEventDAO;
import com.uitm.eventmanagement.dao.GmailParticipantDAO;
import com.uitm.eventmanagement.model.GmailEvent;
import com.uitm.eventmanagement.model.GmailParticipant;
import com.uitm.eventmanagement.service.ReminderNotificationService;

public class ReminderScheduler {
    private static final Logger logger = Logger.getLogger(ReminderScheduler.class.getName());

    public static void main(String[] args) {
        Timer timer = new Timer();
        TimerTask dailyTask = new TimerTask() {
            @Override 
            public void run() {
                try {
                    logger.info("Starting reminder task...");
                    ReminderNotificationService service = new ReminderNotificationService();
                    GmailEventDAO eventDAO = new GmailEventDAO();
                    GmailParticipantDAO participantDAO = new GmailParticipantDAO();
                    
                    List<GmailEvent> upcomingEvents = eventDAO.getUpcomingEvents();
                    for (GmailEvent event : upcomingEvents) {
                        List<GmailParticipant> participants = participantDAO.getParticipantsForEvent(event.getEventID());
                        for (GmailParticipant participant : participants) {
                            service.sendReminders(event, participant);
                        }
                    }
                    logger.info("Reminder task completed successfully.");
                } catch (Exception e) {
                    logger.log(Level.SEVERE, "Error occurred in reminder task", e);
                }
            }
        };
        
        long delay = 0;
        long period = 24 * 60 * 60 * 1000; // Every 24 hours
        timer.scheduleAtFixedRate(dailyTask, delay, period);
        
        logger.info("Reminder Scheduler started.");
    }
}