package model;

public class Participant {
	
	private String participantID;
	private String participantName;
	private String participantEmail;
	private String participantPassword;
	private String participantNoTel;
	
	public Participant() {
    }

    public Participant(String participantID, String participantName, String participantEmail, String participantPassword,  String participantNoTel) {
        this.participantID = participantID;
        this.participantName = participantName;
        this.participantEmail = participantEmail;
        this.participantPassword = participantPassword;
        this.participantNoTel = participantNoTel;
    }
    
	public String getParticipantID() {
		return this.participantID;
	}
	public String getParticipantName() {
		return this.participantName;
	}
	public String getParticipantEmail() {
		return this.participantEmail;
	}
	public String getParticipantPassword() {
		return this.participantPassword;
	}
	public String getParticipantNoTel() {
		return this.participantNoTel;
	}
	
	public void setParticipantID(String participantID) {
		this.participantID = participantID;
	}
	public void setParticipantName(String participantName) {
		this.participantName= participantName;
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


	
	public boolean validate()
	{
		if(participantPassword.isEmpty())
			return false;
		else
			return true;
	}
}

