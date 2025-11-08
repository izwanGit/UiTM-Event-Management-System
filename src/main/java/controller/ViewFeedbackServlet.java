package controller;

import dao.FeedbackDAO;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.ServletException;
import model.FeedbackReport;
import java.io.IOException;
import java.util.List;

public class ViewFeedbackServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession session = request.getSession();
        String userId = (String) session.getAttribute("userId");

        if (userId == null) {
            // If user is not logged in, redirect to the login page
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
		String eventID = request.getParameter("EventID");

		if (eventID != null && !eventID.isEmpty()) {
		    List<FeedbackReport> feedbackList = FeedbackDAO.getFeedbackReportByEventID(eventID);
		    request.setAttribute("eventID", eventID);  // Set eventID attribute
		    request.setAttribute("feedbackList", feedbackList);  // Set feedbackList attribute
		    request.getRequestDispatcher("/views/organizer/view-feedback.jsp").forward(request, response);
		} else {
		    // Handle the case where eventID is null or empty
		    response.sendRedirect("events.jsp");  // Redirect back to events page
		}

	}

}
