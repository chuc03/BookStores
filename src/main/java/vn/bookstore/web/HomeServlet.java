package vn.bookstore.web;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import vn.bookstore.dao.BookDAO;

@WebServlet("/")
public class HomeServlet extends HttpServlet {

    private final BookDAO bookDAO = new BookDAO();

    @Override
        protected void doGet(final HttpServletRequest req, final HttpServletResponse resp)
            throws ServletException, IOException {

        try {
            req.setAttribute("books", bookDAO.findAll(null));
            req.getRequestDispatcher("/WEB-INF/views/home.jsp")
               .forward(req, resp);
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
