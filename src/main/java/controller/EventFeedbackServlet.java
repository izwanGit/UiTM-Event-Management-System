package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.EventFeedback;

import java.io.IOException;
import java.util.List;

import dao.FeedbackDAO;

public class EventFeedbackServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    public EventFeedbackServlet() {
        super();
    }
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
    	
      	HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("login.jsp"); // Redirect if session expired
            return;
        }
        String participantId = (String) session.getAttribute("userId"); 

        // Instantiate the DAO
        FeedbackDAO dao = new FeedbackDAO();

        // Get the registered events for the participant
        List<EventFeedback> feedback = dao.getNoFeedback(participantId);  // Passing the participant ID to the DAO method
        //System.out.println("Found " + feedback.size() + " events.");


        // Set the events as a request attribute
        request.setAttribute("eventFeedback", feedback);
        
        // Forward to JSP
        request.getRequestDispatcher("views/give-feedback.jsp").forward(request, response);
    }
    

}
