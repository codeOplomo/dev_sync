package org.example.devsync4;

import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;

@WebServlet(name = "helloServlet", value = "/hello-servlet")
public class HelloServlet extends HttpServlet {
    private String message;

    public void init() throws ServletException {
        message = "Hello World!";
        try {
            EntityManagerFactory emf = Persistence.createEntityManagerFactory("myJPAUnit");
            message = "Connected to the database successfully!";
        } catch (Exception e) {
            message = "Error connecting to the database: " + e.getMessage();
        }


//        UserRepository userRepository = new UserRepository();
//        User user = new User();
//        user.setUsername("usr");
//        user.setFirstName("Jack");
//        user.setLastName("Smith");
//        user.setEmail("jack@example.com");
//        user.setPassword("password");
//        user.setRole(Role.USER);
//        try {
//            userRepository.save(user);
//        }catch (Exception e) {
//            message = "Error saving user: " + e.getMessage();
        }

//

    @Override
    public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();
        out.println("<html><body>");
        out.println("<h1>" + message + "</h1>");
        out.println("<a href='userForm.jsp'>Add User</a>"); // Link to the user form
        out.println("</body></html>");
    }


    public void destroy() {
    }
}