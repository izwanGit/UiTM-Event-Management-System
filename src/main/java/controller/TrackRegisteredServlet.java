package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.EventRegistration;

import java.io.IOException;
import java.util.List;

import dao.RegistrationDAO;

public class TrackRegisteredServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    public TrackRegisteredServlet() {
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
        RegistrationDAO dao = new RegistrationDAO();


        // Get the registered events for the participant
        List<EventRegistration> events = dao.getRegisteredEvents(participantId);  // Passing the participant ID to the DAO method

        // Set the events as a request attribute
        request.setAttribute("trackRegistered", events);
        
        // Forward to JSP
        request.getRequestDispatcher("views/track-registered.jsp").forward(request, response);
    }
    

}
