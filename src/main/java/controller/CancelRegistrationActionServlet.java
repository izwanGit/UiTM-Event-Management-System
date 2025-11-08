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

//@WebServlet("/CancelRegistrationServlet")  // Ensure this URL is mapped correctly in your web.xml or annotation
public class CancelRegistrationActionServlet extends HttpServlet {
  private static final long serialVersionUID = 1L;

  protected void doGet(HttpServletRequest request, HttpServletResponse response) 
	        throws ServletException, IOException {

	    HttpSession session = request.getSession(false);
	    if (session == null || session.getAttribute("userId") == null) {
	        response.sendRedirect("login.jsp"); // Redirect if session expired
	        return;
	    }
	    String participantId = (String) session.getAttribute("userId");
	    
	    RegistrationDAO dao = new RegistrationDAO();
	    boolean status = dao.deleteRegistration(request.getParameter("registrationId"));

	    if (status) {
	        request.setAttribute("successMessage", "Event registration successfully canceled!");
	        request.setAttribute("messageType", "success");
	    } else {
	        request.setAttribute("errorMessage", "Cancellation is not permitted for events that have already occurred");
	        request.setAttribute("messageType", "error");
	    }

	    // Retrieve updated list of registered events
	    List<EventRegistration> events = dao.getCancelableEvents(participantId);
	    request.setAttribute("registeredEvents", events);

	    // Forward to JSP
	    request.getRequestDispatcher("views/cancel-registration.jsp").forward(request, response);
	}

}
