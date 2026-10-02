package vn.bookstore.web;

import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import vn.bookstore.dao.BookDAO;
import vn.bookstore.dao.CategoryDAO;
import vn.bookstore.model.Book;
import vn.bookstore.model.Category;
import vn.bookstore.model.User;
import vn.bookstore.util.FlashMessage;

@WebServlet("/admin/books")
@MultipartConfig
public class AdminBookServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        try {
            BookDAO dao = new BookDAO();
            CategoryDAO categoryDAO = new CategoryDAO();

            // Lấy danh mục để hiển thị trong form
            List<Category> categories = categoryDAO.findAll();
            req.setAttribute("categories", categories);

            
            // Phân trang
            int page = 1;
            int pageSize = 10;

            try {
                String p = req.getParameter("page");
                String ps = req.getParameter("pageSize");
                if (p != null) page = Math.max(1, Integer.parseInt(p));
                if (ps != null) pageSize = Math.max(1, Integer.parseInt(ps));
            } catch (NumberFormatException ignored) {}

            String q = req.getParameter("q");

            int totalItems = dao.count(q);
            int totalPages = Math.max(1, (int) Math.ceil((double) totalItems / pageSize));
            if (page > totalPages) page = totalPages;

            int offset = (page - 1) * pageSize;

            List<Book> books = dao.findPage(q, offset, pageSize);

            req.setAttribute("books", books);
            req.setAttribute("categories", categories);
            req.setAttribute("currentPage", page);
            req.setAttribute("totalPages", totalPages);
            req.setAttribute("pageSize", pageSize);
            req.setAttribute("totalItems", totalItems);

            req.setAttribute("pageTitle", "Admin - Quản lý sách");
            req.setAttribute("body", "/WEB-INF/admin/books.jsp");

            req.getRequestDispatcher("/WEB-INF/views/_layout.jsp").forward(req, resp);

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        FlashMessage.FlashMessages flash = new FlashMessage.FlashMessages();

        try {
            // Kiểm tra quyền ADMIN
            User me = (User) req.getSession().getAttribute("me");
            if (me == null || !"ADMIN".equals(me.getRoleCode())) {
                resp.sendError(HttpServletResponse.SC_FORBIDDEN);
                return;
            }

            // Lấy dữ liệu form
            String title = req.getParameter("title");
            String author = req.getParameter("author");
            String priceStr = req.getParameter("price");
            String stockStr = req.getParameter("stock");
            String categoryIdStr = req.getParameter("categoryId");

            if (title == null || title.trim().isEmpty() ||
                author == null || author.trim().isEmpty()) {

                flash.addError("Tiêu đề và tác giả là bắt buộc.");
                req.getSession().setAttribute("flashMessages", flash.getMessages());
                resp.sendRedirect(req.getContextPath() + "/admin/books");
                return;
            }

            double price = 0;
            int stock = 0;
            int categoryId = 0;

            try { price = Double.parseDouble(priceStr); } catch (Exception ignored) {}
            try { stock = Integer.parseInt(stockStr); } catch (Exception ignored) {}
            try { categoryId = Integer.parseInt(categoryIdStr); } catch (Exception ignored) {}

            // Tạo đối tượng Book
            Book b = new Book();
            b.setTitle(title.trim());
            b.setAuthor(author.trim());
            b.setPrice(price);
            b.setStock(stock);
            b.setCategoryId(categoryId);

            // Upload ảnh bìa
            Part coverPart = req.getPart("cover");
            if (coverPart != null && coverPart.getSize() > 0) {
                String submitted = coverPart.getSubmittedFileName();
                String ext = "";

                if (submitted != null && submitted.contains(".")) {
                    ext = submitted.substring(submitted.lastIndexOf('.'));
                }

                String filename = System.currentTimeMillis() + "-" + java.util.UUID.randomUUID() + ext;
                String uploadsDir = req.getServletContext().getRealPath("/uploads/books");

                Path uploadsPath = Paths.get(uploadsDir);
                if (!Files.exists(uploadsPath)) Files.createDirectories(uploadsPath);

                Path target = uploadsPath.resolve(filename);

                try (InputStream in = coverPart.getInputStream()) {
                    Files.copy(in, target, StandardCopyOption.REPLACE_EXISTING);
                    b.setCoverUrl(req.getContextPath() + "/uploads/books/" + filename);
                }
            }

            // Lưu vào DB
            BookDAO dao = new BookDAO();
            int id = dao.create(b);

            if (id > 0) {
                flash.addSuccess("Thêm sách thành công.");
            } else {
                flash.addError("Không thể thêm sách.");
            }

        } catch (Exception e) {
            flash.addError("Lỗi hệ thống: " + e.getMessage());
        }

        req.getSession().setAttribute("flashMessages", flash.getMessages());
        resp.sendRedirect(req.getContextPath() + "/admin/books");
    }
}
