package com.uitm.eventmanagement.model;
public class GmailParticipant {
    private String participantId;
    private String participantName;
    private String participantEmail;
    private String participantPassword;
    private String participantNoTel;
	
    public GmailParticipant(String participantId, String participantName, String participantEmail,String participantPassword, String participantNoTel) {
    	this.participantId = participantId;
    	this.participantName = participantName;
    	this.participantEmail = participantEmail;
    	this.participantPassword = participantPassword;
    	this.participantNoTel = participantNoTel;
    }
    // Getters
    public String getParticipantId() {
        return participantId;
    }
    public String getParticipantName() {
        return participantName;
    }
    
    public String getParticipantEmail() {
        return participantEmail;
    }
    public String getParticipantPassword() {
        return participantPassword;
    }
    public String getParticipantNoTel() {
        return participantNoTel;
    }
    // Setters
    public void setParticipantId(String participantId) {
        this.participantId = participantId;
    }
    public void setParticipantName(String participantName) {
        this.participantName = participantName;
    }
    public void setParticipantEmail(String participantEmail) {
        this.participantEmail = participantEmail;
    }
    public void setParticipantPassword(String participantPassword) {
        this.participantPassword = participantPassword;
    }
    public void setParticipantNoTel(String participantNoTel) {
        this.participantNoTel = participantNoTel;
    }
}
