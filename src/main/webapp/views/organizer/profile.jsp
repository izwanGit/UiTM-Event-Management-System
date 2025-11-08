<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page
	import="java.util.List, model.Event, dao.EventDAO, model.Organiser, dao.OrganiserDAO"%>
<%@ page import="jakarta.servlet.http.HttpSession"%>

<%
// Declare session once
HttpSession sessions = request.getSession(); // Removed duplicate declaration

String userId = (String) sessions.getAttribute("userId");

if (userId == null) {
	// If user is not logged in, redirect to the login page
	response.sendRedirect(request.getContextPath() + "/login.jsp");
	return; // Stop further processing of the page
}
%>

<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Organiser Events</title>
<link rel="shortcut icon" type="image/x-icon" href="/UiTM_Event_Management_System/assets/images/uitm.png" />

<!-- DaisyUI and TailwindCSS -->
<link
	href="https://cdn.jsdelivr.net/npm/daisyui@4.12.19/dist/full.min.css"
	rel="stylesheet" type="text/css" />
<script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-base-200">
	<header
		class="bg-primary text-primary-content p-4 flex items-center justify-between">
		<img src="https://perak.uitm.edu.my/images/corporate/TAPAH-PUTIH.png"
			alt="UiTM Perak Logo" class="h-16">
		<h1 class="text-lg font-bold text-center flex-grow">Organiser
			Profile</h1>
		<nav class="flex gap-2">
			<a href="profile.jsp" class="btn btn-sm btn-ghost">Profile</a> 
			<a href="/UiTM_Event_Management_System/LogoutServlet"
				class="btn btn-sm btn-error">Logout</a>
		</nav>
	</header>

	<div class="container mx-auto p-4">
		<!-- Organiser Profile Section -->
		<div class="card bg-base-100 shadow-md mb-6">
			<div class="card-body">
				<div class="flex justify-center">
					<h1 class="card-title text-2xl font-bold mb-4">Organiser
						Profile</h1>
				</div>
				<div class="divider divider-accent"></div>
				<%
				// Fetch the organiser ID from the session
				String organiserID = userId; // Replace with actual session logic

				// Fetch organiser details
				OrganiserDAO organiserDAO = new OrganiserDAO();
				Organiser organiser = organiserDAO.getOrganiserById(organiserID);

				if (organiser != null) {
				%>

				<div class="@container">
					<div class="flex flex-col @md:flex-row">
						<strong>Name:</strong>
						<p><%=organiser.getOrganiserName()%></p>
						<div class="divider divider"></div>
						<strong>Email:</strong>
						<p><%=organiser.getOrganiserEmail()%></p>
						<div class="divider"></div>
						<strong>Phone:</strong>
						<p><%=organiser.getOrganiserNoTel()%></p>
						<div class="divider"></div>
						<strong>Post Caption:</strong>
						<p><%=organiser.getPostCaption()%> <a href="edit-post-caption.jsp" class="btn btn-xs btn-ghost">Edit</a> </p>
					</div>
					<div>
						<div></div>
					</div>
				</div>
				<%
				} else {
				%>
				<p class="text-error">Organiser details not found.</p>
				<%
				}
				%>
			</div>
		</div>
		<div class="my-6 flex items-center justify-between gap-x-4">
			<!-- Left side: Create New Event and Delete buttons -->
			<div class="flex gap-4">
				<a href="create-events.jsp" class="btn btn-primary">Create New
					Event</a>
				<form action="DeleteEventServlet" method="GET">
					<button type="submit" class="btn btn-error">Delete</button>
				</form>
			</div>

			<!-- Right side: Toggle button -->
			<button onclick="toggleView()" id="toggleButton"
				class="btn btn-secondary">⊞</button>
		</div>


		<!-- Table View (Default) -->
		<div id="table-view">
			<div class="overflow-x-auto">
				<table class="table table-sm table-pin-rows table-pin-cols">
					<thead>
						<tr>
							<th>Event ID</th>
							<th>Poster</th>
							<th>Event Name</th>
							<th>Event Date</th>
							<th>Event Time</th>
							<th>Event Location</th>
							<th>Event Price</th>
							<th>Event Status</th>
							<th>Max Participants</th>
							<th>Description</th>
							<th>Actions</th>
						</tr>
					</thead>
					<tbody>
						<%
						List<Event> events = EventDAO.eventList(organiserID);
						for (Event event : events) {
						%>
						<tr>
							<td><%=event.getEventID()%></td>
							<td><img class="w-20 h-20 object-cover"
								src="../../assets/images/posters/<%=event.getEventID() + ".jpg"%>"
								alt="Event Image"></td>
							<td><%=event.getEventName()%></td>
							<td><%=event.getEventDate()%></td>
							<td><%=event.getEventTime()%></td>
							<td><%=event.getEventLocation()%></td>
							<td>RM <%=String.format("%.2f", event.getEventPrice())%></td>
							<%
							String status = event.getEventStatus();
							String statusClass = "";

							if ("Upcoming".equalsIgnoreCase(status)) {
								statusClass = "badge badge-warning"; // Yellow for upcoming
							} else if ("Ongoing".equalsIgnoreCase(status)) {
								statusClass = "badge badge-success"; // Green for ongoing
							} else if ("Ended".equalsIgnoreCase(status)) {
								statusClass = "badge badge-error"; // Red for ended
							}
							%>
							<td><span class="<%=statusClass%>"><%=status%></span></td>

							<td><%=event.getMaxParticipant()%></td>
							<td><%=event.getDescription()%></td>
							<td class="flex gap-2"><a
								href="edit-events.jsp?eventID=<%=event.getEventID()%>"
								class="btn btn-sm btn-primary w-24 text-center">Edit</a>

								<form action="ViewFeedbackServlet" method="POST">
									<input type="hidden" name="EventID"
										value="<%=event.getEventID()%>">
									<button type="submit" class="btn btn-sm btn-primary w-24">View
										Feedback</button>
								</form>

								<form action="ViewPaymentServlet" method="GET">
									<input type="hidden" name="eventID"
										value="<%=event.getEventID()%>">
									<button type="submit" class="btn btn-sm btn-primary w-24">View
										Payment</button>
								</form></td>

							<%
							}
							%>
						</tr>
					</tbody>
				</table>
			</div>
		</div>

		<!-- Grid View (Hidden by Default) -->
		<div id="grid-view"
			class="hidden grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
			<%
			for (Event event : events) {
			%>
			<div class="card bg-base-100 shadow-md">
				<figure>
					<img class="w-full h-48 object-cover"
						src="../../assets/images/posters/<%=event.getEventID() + ".jpg"%>"
						alt="Event Image">
				</figure>
				<div class="card-body">
					<h3 class="card-title text-lg font-bold"><%=event.getEventName()%></h3>
					<p>
						<strong>Date:</strong><%=event.getEventDate()%></p>
					<p>
						<strong>Time:</strong><%=event.getEventTime()%></p>
					<p>
						<strong>Location:</strong><%=event.getEventLocation()%></p>
					<p>
						<strong>Price:</strong> RM
						<%=String.format("%.2f", event.getEventPrice())%></p>
					<%
					String status = event.getEventStatus();
					String statusClass = "";

					if ("Upcoming".equalsIgnoreCase(status)) {
						statusClass = "badge badge-warning"; // Yellow for upcoming
					} else if ("Ongoing".equalsIgnoreCase(status)) {
						statusClass = "badge badge-success"; // Green for ongoing
					} else if ("Ended".equalsIgnoreCase(status)) {
						statusClass = "badge badge-error"; // Red for ended
					}
					%>
					<p>
						<strong>Status:</strong> <span class="<%=statusClass%>"><%=status%></span>
					</p>

					<p>
						<strong>Max Participants:</strong><%=event.getMaxParticipant()%></p>
					<p><%=event.getDescription()%></p>

					<!-- Action Buttons -->
					<div class="card-actions justify-end gap-2">
						<a href="edit-events.jsp?eventID=<%=event.getEventID()%>"
							class="btn btn-sm btn-primary w-24 text-center">Edit</a>

						<form action="ViewFeedbackServlet" method="POST">
							<input type="hidden" name="EventID"
								value="<%=event.getEventID()%>">
							<button type="submit" class="btn btn-sm btn-primary w-24">View
								Feedback</button>
						</form>

						<form action="ViewPaymentServlet" method="GET">
							<input type="hidden" name="eventID"
								value="<%=event.getEventID()%>">
							<button type="submit" class="btn btn-sm btn-primary w-24">View
								Payment</button>
						</form>
					</div>
				</div>
			</div>
			<%
			}
			%>
		</div>
		<%
		String toastMessage = (String) request.getAttribute("toastMessage");
		String toastType = (String) request.getAttribute("toastType");
		%>

		<%
		if (toastMessage != null && toastType != null) {
		%>
		<div class="toast toast-end">
			<div class="alert alert-<%=toastType%>">
				<span><%=toastMessage%></span>
			</div>
		</div>
		<%
		}
		%>
	</div>

	<script>
        setTimeout(() => {
            const toasts = document.querySelectorAll('.toast');
            toasts.forEach(toast => toast.remove());
        }, 3000);
    </script>

	<script>
        function toggleView() {
            var tableView = document.getElementById("table-view");
            var gridView = document.getElementById("grid-view");
            var button = document.getElementById("toggleButton");

            if (tableView.classList.contains("hidden")) {
                // Switch to Table View
                tableView.classList.remove("hidden");
                gridView.classList.add("hidden");
                button.textContent = "⊞";
            } else {
                // Switch to Grid View
                tableView.classList.add("hidden");
                gridView.classList.remove("hidden");
                button.textContent = "☰";
            }
        }
    </script>
</body>
</html>
