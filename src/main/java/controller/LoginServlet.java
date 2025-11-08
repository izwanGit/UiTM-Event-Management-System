package controller;
import model.Participant;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import dao.UserDAO;

public class LoginServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        UserDAO userDAO = new UserDAO();
        boolean isValidUser = userDAO.validateUser(username, password);

        if (isValidUser) {
            // Determine user type (Participant or Organiser)
            String userType = username.startsWith("ORG") ? "organiser" : "participant";

            // Set session attribute for user type
            HttpSession session = request.getSession();
            session.setAttribute("userType", userType);
            session.setAttribute("userId", username);

            // Redirect to appropriate dashboard based on user type
            if (userType.equals("organiser")) {
            	response.sendRedirect("views/organizer/profile.jsp");
            } else {
            	response.sendRedirect("BrowseEventServlet");
            }
        } else {
            // Invalid login, show error message
            request.setAttribute("error", "Invalid Username or Password");
            RequestDispatcher dispatcher = request.getRequestDispatcher("login.jsp");
            dispatcher.forward(request, response);
        }
    }

}
