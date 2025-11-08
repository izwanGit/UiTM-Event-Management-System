package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import dao.OrganiserDAO;

import java.io.IOException;

public class EditPostCaptionServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		HttpSession session = request.getSession();
		String userId = (String) session.getAttribute("userId");

		if (userId == null) {
			// If user is not logged in, redirect to the login page
			response.sendRedirect(request.getContextPath() + "/login.jsp");
			return;
		}
		try {
			// Retrieve form parameters
			String organiserID = request.getParameter("organiserID");
			String postCaption = request.getParameter("postCaption");

			// Update the post caption in the database
			OrganiserDAO organiserDAO = new OrganiserDAO();
			boolean isUpdated = organiserDAO.updatePostCaption(organiserID, postCaption);

			if (!isUpdated) {
				throw new Exception("Failed to update post caption.");
			}

			// Redirect back to the profile page
			request.setAttribute("toastMessage", "Caption edited successfully!");
			request.setAttribute("toastType", "info"); // or "success", "error", etc.
			request.getRequestDispatcher("profile.jsp").forward(request, response);

		} catch (Exception e) {
			e.printStackTrace();
			request.setAttribute("errorMessage", "Error: " + e.getMessage());
			request.getRequestDispatcher("error.jsp").forward(request, response);
		}
	}
}