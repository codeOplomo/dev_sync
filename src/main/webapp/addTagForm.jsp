<%--
  Created by IntelliJ IDEA.
  User: Youcode
  Date: 08/10/2024
  Time: 21:27
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
  <title>Add Tag</title>
  <style>
    body {
      font-family: Arial, sans-serif;
      background-color: #f0f0f0;
      margin: 0;
      padding: 0;
      display: flex;
    }

    .content {
      margin-left: 220px; /* Adjust to match sidebar width */
      padding: 40px;
      width: calc(100% - 220px);
    }

    .container {
      background-color: #fff;
      padding: 40px;
      border-radius: 8px;
      box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
      max-width: 800px; /* Increased max-width for larger form */
      width: 80%; /* Use a larger width to fit more space */
      margin: 0 auto;
    }

    h2 {
      text-align: left; /* Align title to the left for better layout consistency */
      margin-bottom: 20px;
    }

    form {
      display: flex;
      flex-direction: column;
    }

    label {
      margin-bottom: 5px;
      font-weight: bold;
    }

    input[type="text"] {
      padding: 10px;
      margin-bottom: 20px; /* Increased space between fields */
      border: 1px solid #ccc;
      border-radius: 4px;
      font-size: 16px;
    }

    input[type="submit"] {
      background-color: #4CAF50;
      color: white;
      padding: 15px;
      border: none;
      border-radius: 4px;
      cursor: pointer;
      font-size: 18px; /* Make the submit button more prominent */
    }

    input[type="submit"]:hover {
      background-color: #45a049;
    }

    .back-link {
      display: inline-block;
      margin-top: 20px;
      text-decoration: none;
      color: #007BFF;
      font-size: 16px;
    }

    .back-link:hover {
      text-decoration: underline;
    }

  </style>
</head>
<body>
<%@ include file="layout/sidebar.jsp" %>

<div class="content">
  <div class="container">
    <h2>Add Tag</h2>

    <form action="tagForms" method="post">
      <label for="name">Tag Name:</label>
      <input type="text" id="name" name="name" required>

      <input type="submit" value="Add Tag">
    </form>
    <a href="tags" class="back-link">Back</a>
  </div>
</div>
</body>
</html>

</body>
</html>
