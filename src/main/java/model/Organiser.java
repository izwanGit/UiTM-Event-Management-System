package model;

public class Organiser {
	
	private String organiserID;
	private String organiserName;
	private String organiserEmail;
	private String organiserPassword;
	private String organiserNoTel;
	private String postCaption;
	
	public Organiser() {
    }

    public Organiser(String organiserID, String organiserName, String organiserEmail, String organiserPassword,  String organiserNoTel, String postCaption) {
        this.organiserID = organiserID;
        this.organiserName = organiserName;
        this.organiserEmail = organiserEmail;
        this.organiserPassword = organiserPassword;
        this.organiserNoTel = organiserNoTel;
        this.postCaption = postCaption;
    }
    
	public String getOrganiserID() {
		return this.organiserID;
	}
	public String getOrganiserName() {
		return this.organiserName;
	}
	public String getOrganiserEmail() {
		return this.organiserEmail;
	}
	public String getOrganiserPassword() {
		return this.organiserPassword;
	}
	public String getOrganiserNoTel() {
		return this.organiserNoTel;
	}
	public String getPostCaption() {
		return this.postCaption;
	}
	
	public void setOrganiserID(String organiserID) {
		this.organiserID = organiserID;
	}
	public void setOrganiserName(String organiserName) {
		this.organiserName= organiserName;
	}
	public void setOrganiserEmail(String organiserEmail) {
		this.organiserEmail = organiserEmail;
	}
	public void setOrganiserPassword(String organiserPassword) {
		this.organiserPassword = organiserPassword;
	}
	public void setOrganiserNoTel(String organiserNoTel) {
		this.organiserNoTel = organiserNoTel;
	}
	public void setPostCaption(String postCaption) {
		this.postCaption = postCaption;
	}

	public boolean validate()
	{
		if(organiserPassword.isEmpty())
			return false;
		else
			return true;
	}
}

