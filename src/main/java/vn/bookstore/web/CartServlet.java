package vn.bookstore.web;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import vn.bookstore.dao.BookDAO;
import vn.bookstore.model.Book;
import vn.bookstore.model.Cart;

@WebServlet(urlPatterns = { "/cart", "/cart/add", "/cart/update", "/cart/remove" })
public class CartServlet extends HttpServlet {
    private final BookDAO bookDAO = new BookDAO();

    private Cart cart(final HttpServletRequest req) {
        final HttpSession s = req.getSession();
        Cart cart = (Cart) s.getAttribute("cart");
        if (cart == null) {
            cart = new Cart();
            s.setAttribute("cart", cart);
        }
        return cart;
    }

    @Override
    protected void doGet(final HttpServletRequest req, final HttpServletResponse resp)
            throws ServletException, IOException {
        req.getRequestDispatcher("/WEB-INF/views/cart.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(final HttpServletRequest req, final HttpServletResponse resp)
            throws ServletException, IOException {
        final String path = req.getServletPath();
        final Cart cart = cart(req);

        try {
            if ("/cart/add".equals(path)) {
                String idParam = req.getParameter("id");
                String qtyParam = req.getParameter("qty");
                if (idParam == null) {
                    resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing id");
                    return;
                }
                int id;
                try {
                    id = Integer.parseInt(idParam);
                } catch (NumberFormatException ex) {
                    resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid id");
                    return;
                }
                int qty = 1;
                if (qtyParam != null) {
                    try {
                        qty = Integer.parseInt(qtyParam);
                    } catch (NumberFormatException ex) {
                        resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid qty");
                        return;
                    }
                }
                Book b = bookDAO.findById(id);
                if (b != null) {
                    // CHECK STOCK before adding to cart
                    if (b.getStock() < qty) {
                        req.getSession().setAttribute("cartError",
                                "Sách '" + b.getTitle() + "' chỉ còn " + b.getStock() + " cuốn trong kho");
                    } else {
                        cart.add(b, qty);
                    }
                }
                resp.sendRedirect(req.getContextPath() + "/cart");
                return;
            }

            if ("/cart/update".equals(path)) {
                String idParam = req.getParameter("id");
                String qtyParam = req.getParameter("qty");
                if (idParam == null || qtyParam == null) {
                    resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing parameters");
                    return;
                }
                int id, qty;
                try {
                    id = Integer.parseInt(idParam);
                } catch (NumberFormatException ex) {
                    resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid id");
                    return;
                }
                try {
                    qty = Integer.parseInt(qtyParam);
                } catch (NumberFormatException ex) {
                    resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid qty");
                    return;
                }
                cart.update(id, qty);
                resp.sendRedirect(req.getContextPath() + "/cart");
                return;
            }

            if ("/cart/remove".equals(path)) {
                String idParam = req.getParameter("id");
                if (idParam == null) {
                    resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing id");
                    return;
                }
                int id;
                try {
                    id = Integer.parseInt(idParam);
                } catch (NumberFormatException ex) {
                    resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid id");
                    return;
                }
                cart.remove(id);
                resp.sendRedirect(req.getContextPath() + "/cart");
                return;
            }

            resp.sendError(404);
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
