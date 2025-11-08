<%@ page import="java.util.List, model.Event, java.util.HashMap, java.util.Map, java.util.ArrayList" %>
<%@ page import="java.text.NumberFormat, java.text.SimpleDateFormat, java.util.Date, java.util.Locale" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="dao.RegistrationDAO" %>

<%
    // Format the currency
    NumberFormat currencyFormat = NumberFormat.getCurrencyInstance(new Locale("ms", "MY"));
    // Format the date and time
    SimpleDateFormat timeFormat = new SimpleDateFormat("hh:mm a");
%>

<%
    String registrationStatus = (String) session.getAttribute("registrationStatus");
	System.out.println("Registration Status: " + registrationStatus); // Debugging

	if (registrationStatus != null) {
    	session.removeAttribute("registrationStatus"); } // Clear the session attribute after displaying
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Browse Events</title>
<link rel="shortcut icon" type="image/x-icon" href="/UiTM_Event_Management_System/assets/images/uitm.png" />

<!-- DaisyUI and TailwindCSS -->
<link
	href="https://cdn.jsdelivr.net/npm/daisyui@4.12.19/dist/full.min.css"
	rel="stylesheet" type="text/css" />
<script src="https://cdn.tailwindcss.com"></script>
    <style>
	    body {
	        display: flex;
	        flex-direction: column;
	        min-height: 100vh;
	    }
	    .content {
	        flex: 1;
	    }
	</style>
</head>
<body class="bg-base-200">

	<!-- Floating Notification -->
    <div id="notification" class="fixed top-4 left-1/2 transform -translate-x-1/2 p-4 bg-green-500 text-white rounded-lg shadow-lg hidden z-50">
    	<p><strong><%= request.getAttribute("successMessage") != null ? request.getAttribute("successMessage") : "" %></strong></p>
	</div>

    
    <script>
        // Display the notification if it exists
        window.onload = function() {
            var notification = document.getElementById("notification");
            var registrationStatus = "<%= registrationStatus != null ? registrationStatus : "" %>"; // Pass the message directly

            // Check if the status is present and show the notification
            if (registrationStatus) {
                notification.classList.remove("hidden");

                // Automatically hide the notification after 3 seconds
                setTimeout(function() {
                    notification.classList.add("hidden");
                }, 3000); // 3000ms = 3 seconds
            }
        };
    </script>
	
	<header
		class="bg-primary text-primary-content p-4 flex items-center justify-between">
		<img src="https://perak.uitm.edu.my/images/corporate/TAPAH-PUTIH.png"
			alt="UiTM Perak Logo" class="h-16">
		<h1 class="text-lg font-bold text-center flex-grow">Browse Events</h1>
		<nav class="flex gap-2">
			<a href="/UiTM_Event_Management_System/BrowseEventServlet" class="btn btn-sm btn-ghost">Browse Events</a> 
			<a href="/UiTM_Event_Management_System/TrackRegisteredServlet" class="btn btn-sm btn-ghost">Track Registration</a> 
			<a href="/UiTM_Event_Management_System/EventFeedbackServlet" class="btn btn-sm btn-ghost">Give Feedback</a> 
			<a href="/UiTM_Event_Management_System/CancelRegistrationServlet" class="btn btn-sm btn-ghost">Cancel Registration</a> 
			<a href="/UiTM_Event_Management_System/LogoutServlet" class="btn btn-sm btn-error">Logout</a>
		</nav>
	</header>

<!-- loop through eventList dynamically -->
	<div class="container mx-auto p-4">		

		<!-- Filter Form -->
		<form id="filterForm" method="get" action="${pageContext.request.contextPath}/BrowseEventFilterServlet">
		    <div class="bg-base-100 p-6 rounded-lg shadow-md mb-6">
		        <div class="grid	 grid-cols-1 md:grid-cols-4 gap-4">
		            <!-- Event Status Filter -->
		            <div>
		                <label class="block text-sm font-medium mb-1">Event Status</label>
		                <select class="select select-bordered w-full" name="status" id="status" onchange="submitFilterForm()">
		                    <option value="">All Statuses</option>
		                    <option value="Ongoing" <%= "Ongoing".equals(request.getParameter("status")) ? "selected" : "" %>>Ongoing</option>
		                    <option value="Upcoming" <%= "Upcoming".equals(request.getParameter("status")) ? "selected" : "" %>>Upcoming</option>
		                    <option value="Ended" <%= "Ended".equals(request.getParameter("status")) ? "selected" : "" %>>Ended</option>
		                </select>
		            </div>
		
		            <!-- Search by Event Name -->
		            <div>
		                <label class="block text-sm font-medium mb-1">Search by Name</label>
		                <input type="text" class="input input-bordered w-full" 
		                       name="searchByName" 
		                       id="searchByName"
		                       placeholder="Event name" 
		                       value="<%= request.getParameter("searchByName") != null ? request.getParameter("searchByName") : "" %>"
		                       oninput="submitFilterForm()">
		            </div>
		            
		            <%
						String lastPick = null;
						Cookie[] cookies = request.getCookies();
						if (cookies != null) {
						for (Cookie cookie : cookies) {
							if ("lastPick".equals(cookie.getName())) {
								lastPick = cookie.getValue();
								break;
							}
						}
						}
					%>
					
		            <!-- Organiser/Category Filter --> 
		            <div>
					    <label class="block text-sm font-medium mb-1">Category</label>
					    <select name="category" id="category" class="select select-bordered w-full" onchange="submitFilterForm()">
					        <option value="">All Categories</option>
					        <option value="ORG001" <%= "ORG001".equals(request.getParameter("category")) ? "selected" : "" %>>MPP</option>
					        <option value="ORG002" <%= "ORG002".equals(request.getParameter("category")) ? "selected" : "" %>>JSP</option>
					        <option value="ORG003" <%= "ORG003".equals(request.getParameter("category")) ? "selected" : "" %>>BASCO</option>
					    </select>
					</div>		
		
		            <!-- Reset Filters Button -->
		            <div class="flex items-end">
		                <button type="button" onclick="resetFilters()" class="btn btn-outline w-full">
		                    Reset Filters
		                </button>
		            </div>
		        </div>
		    </div>
		</form>

		<script>
		    // Function to submit the filter form
		    function submitFilterForm() {
		        document.getElementById("filterForm").submit();
		    }
		
		    // Function to reset all filters
		    function resetFilters() {
		        const form = document.getElementById("filterForm");
		        document.getElementById("status").value = "";
		        document.getElementById("searchByName").value = "";
		        document.getElementById("category").value = "";
		        form.submit();
		    }
		</script>
		
		<%
		    // Create a map of organiser IDs to category names
		    Map<String, String> categoryMap = new HashMap<>();
		    categoryMap.put("ORG001", "MPP");
		    categoryMap.put("ORG002", "JSP");
		    categoryMap.put("ORG003", "BASCO");
		
		    // Get the category name based on the lastPick organiser ID
		    String lastPickCategoryName = (lastPick != null) ? categoryMap.get(lastPick) : null;
		%>
		
		<% if (lastPick != null) { %>
		    <p class="text-sm text-primary mt-2">Last time, you registered <%= lastPickCategoryName %>'s event!</p>
		<% } else { %>
		    <p class="text-sm text-gray-500 mt-2">Register Now!</p>
		<% } %>
        
	</div>
	<div class="container mx-auto p-4">
	    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
	      <% 
	        String userId = (String) session.getAttribute("userId"); //afdef
	        Map<String, Integer> participantCounts = (Map<String, Integer>) request.getAttribute("participantCounts");
	        List<Event> eventList = (List<Event>) request.getAttribute("eventList");
	        if (eventList != null) {
	            for (Event event : eventList) {
	                int participantCount = participantCounts.getOrDefault(event.getEventID(), 0);
	                String status = event.getEventStatus();
	                String badgeClass = "";
	                
	             	// Check if the event has reached its max participants
	                boolean isMaxParticipantsReached = participantCount >= event.getMaxParticipant();
	                            
	                RegistrationDAO registrationDAO = new RegistrationDAO();
	                boolean isRegistered = registrationDAO.isUserRegistered(userId, event.getEventID()); // Check if user is already registered
	                
	                if ("Upcoming".equalsIgnoreCase(status)) {
	                    badgeClass = "badge-warning";
	                } else if ("Ongoing".equalsIgnoreCase(status)) {
	                    badgeClass = "badge-success";
	                } else if ("Ended".equalsIgnoreCase(status)) {
	                    badgeClass = "badge-error";
	                }
	                
	         String formattedEventPrice = currencyFormat.format(event.getEventPrice());
	         String formattedEventTime = timeFormat.format(event.getEventDate());
	    %>
	    
	                <div class="card bg-base-100 shadow-xl hover:shadow-2xl transition-shadow duration-200">
	                    <figure class="relative">
	                        <img src="/UiTM_Event_Management_System/assets/images/posters/<%=event.getEventID() %>.jpg" 
	                             alt="<%=event.getEventName() %>"
	                             class="h-48 w-full object-cover">
	                        <!-- Status Badge -->
	                        <div class="absolute bottom-4 right-4 space-y-2 flex flex-col items-end">
	                            <div class="<%= badgeClass %> badge text-white font-bold">
	                                <%= status %>
	                            </div>
	                            <!-- Participant Count -->
	                            <div class="badge badge-neutral bg-black/60 text-white">
	                                <%= participantCount %>/<%= event.getMaxParticipant() %> seats
	                            </div>
	                        </div>
	                    </figure>
	                    <div class="card-body p-4">
	                        <h2 class="card-title text-lg"><%= event.getEventName() %></h2>
	                        <div class="space-y-1">
	                            <p class="text-sm line-clamp-3"><%= event.getDescription() %></p>
	                            <div class="flex items-center gap-2 text-sm">
	                                <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 text-primary" fill="none" viewBox="0 0 24 24" stroke="currentColor">
	                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z"/>
	                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 11a3 3 0 11-6 0 3 3 0 016 0z"/>
	                                </svg>
	                                <span><%= event.getEventLocation() %></span>
	                            </div>
	                            <div class="flex items-center gap-2 text-sm">
	                                <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 text-primary" fill="none" viewBox="0 0 24 24" stroke="currentColor">
	                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"/>
	                                </svg>
	                                <span><%= event.getEventDate() %> • <%= formattedEventTime %></span>
	                            </div>
	                            <div class="flex items-center gap-2 text-sm font-bold">
	                                <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 text-primary" fill="none" viewBox="0 0 24 24" stroke="currentColor">
	                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8c-1.657 0-3 .895-3 2s1.343 2 3 2 3 .895 3 2-1.343 2-3 2m0-8c1.11 0 2.08.402 2.599 1M12 8V7m0 1v8m0 0v1m0-1c-1.11 0-2.08-.402-2.599-1M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/>
	                                </svg>
	                                <span><%= formattedEventPrice %></span>
	                            </div>
	                        </div>
	                        
	                        <div class="card-actions justify-end mt-2">
					            <% if ("Ended".equalsIgnoreCase(status) || "Ongoing".equalsIgnoreCase(status) || isMaxParticipantsReached) { %>
					                <button class="btn btn-secondary btn-sm" disabled>Closed</button>
					            <% } else if (isRegistered) { %>
					                <button class="btn btn-primary btn-sm" disabled>Registered</button>
					            <% } else { %>
					                <a href="<%= request.getContextPath() %>/RegisterEventServlet?eventID=<%= event.getEventID() %>" class="btn btn-primary btn-sm">Register Now</a>
					            <% } %>
							</div>
	                    </div>
	                </div>
	    <%
	            }
	        } else { 
	    %>
	        <p class="text-center text-red-500">No events available</p>
	    <%
	        }
	    %>
	    </div>
</div>

    <footer class="bg-base-300 text-base-content p-4 text-center mt-auto">
        &copy; 2024 UiTM Event Management System
    </footer>
</body>
</html>