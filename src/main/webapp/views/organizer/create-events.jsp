<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Create New Event</title>
<link rel="shortcut icon" type="image/x-icon" href="/UiTM_Event_Management_System/assets/images/uitm.png" />

<link
	href="https://cdn.jsdelivr.net/npm/daisyui@4.12.19/dist/full.min.css"
	rel="stylesheet" type="text/css" />
<script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-base-200 min-h-screen flex flex-col">
	<!-- Header -->
	<header
		class="bg-primary text-primary-content p-4 flex items-center justify-between">
		<img src="https://perak.uitm.edu.my/images/corporate/TAPAH-PUTIH.png"
			alt="UiTM Perak Logo" class="h-16">
		<h1 class="text-lg font-bold text-center flex-grow">Create New
			Event</h1>
		<nav class="flex gap-2">
			<a href="profile.jsp" class="btn btn-sm btn-ghost">Profile</a> 
			<a href="/UiTM_Event_Management_System/LogoutServlet"
				class="btn btn-sm btn-error">Logout</a>
		</nav>
	</header>

	<!-- Main Content -->
	<div class="container mx-auto p-4 flex-grow">
		<h2 class="text-xl font-semibold mb-4">Create a New Event</h2>

		<!-- Form to create new event -->
		<form id="createEventForm" action="CreateEventServlet" method="POST"
			enctype="multipart/form-data">
			<!-- Event Name -->
			<div class="mb-4">
				<label for="eventName" class="label">Event Name</label> <input
					type="text" id="eventName" name="eventName"
					class="input input-bordered w-full" placeholder="Enter event name"
					required>
			</div>

			<!-- Event Date -->
			<div class="mb-4">
				<label for="eventDate" class="label">Event Date</label> <input
					type="date" id="eventDate" name="eventDate"
					class="input input-bordered w-full" required>
			</div>

			<!-- Event Time -->
			<div class="mb-4">
				<label for="eventTime" class="label">Event Time</label> <input
					type="time" id="eventTime" name="eventTime"
					class="input input-bordered w-full" required>
			</div>

			<!-- Event Location -->
			<div class="mb-4">
				<label for="eventLocation" class="label">Event Location</label> <input
					type="text" id="eventLocation" name="eventLocation"
					class="input input-bordered w-full"
					placeholder="Enter event location" required>
			</div>

			<!-- Event Price -->
			<div class="mb-4">
				<label for="eventPrice" class="label">Event Price</label> <input
					type="number" id="eventPrice" name="eventPrice"
					class="input input-bordered w-full" placeholder="Enter event price"
					min="0" required>
			</div>

			<!-- Event Poster (Image Upload) -->
			<div class="mb-4">
				<label for="eventPoster" class="label">Event Poster</label> <input
					type="file" id="eventPoster" name="poster"
					class="file-input file-input-bordered w-full" accept="image/*"
					required>
			</div>

			<!-- Maximum Participants -->
			<div class="mb-4">
				<label for="maxParticipant" class="label">Maximum
					Participants</label> <input type="number" id="maxParticipant"
					name="maxParticipant" class="input input-bordered w-full"
					placeholder="Enter max participants" min="1" required>
			</div>

			<!-- Event Description -->
			<div class="mb-4">
				<label for="description" class="label">Description</label>
				<textarea name="description" id="description"
					class="input input-bordered w-full"
					placeholder="Enter the description" maxlength="1000" required></textarea>
			</div>

			<!-- Event Status -->
			<input type="hidden" id="eventStatus" name="eventStatus"
				value="Upcoming">
				
			<!-- Organizer ID (hidden field) -->
			<input type="hidden" id="organiserID" name="organiserID"
				value="ORG001">

			<div class="flex justify-between">
				<button type="submit" class="btn btn-primary">Create Event</button>
				<a type="button" href="profile.jsp" class="btn btn-ghost">Cancel</a>
			</div>
		</form>

		<!-- Error Message for incomplete form -->
		<p id="errorMessage" class="text-error mt-2 hidden">Please fill in
			all mandatory fields.</p>

		<!-- Date Constraint Error -->
		<p id="dateErrorMessage" class="text-error mt-4 hidden">The event
			date must be at least one week from today.</p>
	</div>

	<!-- Footer -->
	<footer class="bg-base-300 text-base-content p-4 text-center">
		&copy; 2024 UiTM Event Management System </footer>

	<script>
		// Constraints: Event must be at least 1 week away
		const errorMessage = document.getElementById('errorMessage');
		const dateErrorMessage = document.getElementById('dateErrorMessage');

		// Handle form submission
		document
				.getElementById('createEventForm')
				.addEventListener(
						'submit',
						function(event) {
							event.preventDefault();

							// Retrieve input values
							const eventName = document
									.getElementById('eventName').value;
							const eventDate = new Date(document
									.getElementById('eventDate').value);
							const eventTime = document
									.getElementById('eventTime').value;
							const eventLocation = document
									.getElementById('eventLocation').value;
							const eventPrice = document
									.getElementById('eventPrice').value;
							const maxParticipant = document
									.getElementById('maxParticipant').value;
							const eventPoster = document
									.getElementById('eventPoster').files[0]; // Get the uploaded file

							// Date Constraint: Check if the event date is at least 1 week ahead
							const currentDate = new Date();
							const minDate = new Date();
							minDate.setDate(currentDate.getDate() + 7); // Event must be at least 7 days later

							if (eventDate < minDate) {
								dateErrorMessage.classList.remove('hidden');
								return;
							} else {
								dateErrorMessage.classList.add('hidden');
							}

							// Form validation: Ensure all fields are filled in
							if (!eventName || !eventDate || !eventTime
									|| !eventLocation || !eventPrice
									|| !eventPoster || !maxParticipant) {
								errorMessage.classList.remove('hidden');
								return;
							} else {
								errorMessage.classList.add('hidden');
							}

							// Show confirmation message
							if (confirm("Are you sure you want to create this event?")) {
								// Submit the form
								event.target.submit();
							}
						});

		// Cancel Create Event
		function cancelCreate() {
			if (confirm("Are you sure you want to cancel creating this event?")) {
				window.location.href = 'home.html'; // Redirect back to the homepage
			}
		}
	</script>
</body>
</html>
