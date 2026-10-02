package vn.bookstore.web;

import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

@WebServlet("/admin/book/edit")
@MultipartConfig
public class AdminBookEditServlet extends HttpServlet {

    private final vn.bookstore.dao.BookDAO dao = new vn.bookstore.dao.BookDAO();
    private final vn.bookstore.dao.CategoryDAO categoryDAO = new vn.bookstore.dao.CategoryDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String idStr = req.getParameter("id");
        if (idStr == null) {
            resp.sendRedirect(req.getContextPath() + "/admin/books");
            return;
        }
        try {
            int id = Integer.parseInt(idStr);
            vn.bookstore.model.Book b = dao.findById(id);
            if (b == null) {
                req.getSession().setAttribute("flashMessages", java.util.List.of(new vn.bookstore.util.FlashMessage(
                        vn.bookstore.util.FlashMessage.MessageType.ERROR, "Sách không tìm thấy.")));
                resp.sendRedirect(req.getContextPath() + "/admin/books");
                return;
            }
            req.setAttribute("book", b);
            req.setAttribute("categories", categoryDAO.findAll());
            req.setAttribute("pageTitle", "Sửa sách #" + b.getId());
            req.setAttribute("body", "/WEB-INF/admin/book_edit.jsp");
            req.getRequestDispatcher("/WEB-INF/views/_layout.jsp").forward(req, resp);
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        vn.bookstore.util.FlashMessage.FlashMessages flash = new vn.bookstore.util.FlashMessage.FlashMessages();
        try {
            vn.bookstore.model.User me = (vn.bookstore.model.User) req.getSession().getAttribute("me");
            if (me == null || !"ADMIN".equals(me.getRoleCode())) {
                resp.sendError(HttpServletResponse.SC_FORBIDDEN);
                return;
            }
            String idStr = req.getParameter("id");
            String title = req.getParameter("title");
            String author = req.getParameter("author");
            String priceStr = req.getParameter("price");
            String stockStr = req.getParameter("stock");
            String categoryIdStr = req.getParameter("categoryId");
            String description = req.getParameter("description");
            if (idStr == null) {
                flash.addError("ID không hợp lệ.");
                req.getSession().setAttribute("flashMessages", flash.getMessages());
                resp.sendRedirect(req.getContextPath() + "/admin/books");
                return;
            }

            // VALIDATION
            if (title == null || title.trim().isEmpty()) {
                flash.addError("Tiêu đề sách không được để trống.");
                req.getSession().setAttribute("flashMessages", flash.getMessages());
                resp.sendRedirect(req.getContextPath() + "/admin/book/edit?id=" + idStr);
                return;
            }
            if (author == null || author.trim().isEmpty()) {
                flash.addError("Tác giả không được để trống.");
                req.getSession().setAttribute("flashMessages", flash.getMessages());
                resp.sendRedirect(req.getContextPath() + "/admin/book/edit?id=" + idStr);
                return;
            }

            int id = Integer.parseInt(idStr);
            double price = 0.0;
            int stock = 0;
            try {
                price = Double.parseDouble(priceStr);
            } catch (Exception ex) {
                ex.printStackTrace();
            }
            try {
                stock = Integer.parseInt(stockStr);
            } catch (Exception ex) {
                ex.printStackTrace();
            }

            // Validate price and stock
            if (price < 0) {
                flash.addError("Giá sách không được âm.");
                req.getSession().setAttribute("flashMessages", flash.getMessages());
                resp.sendRedirect(req.getContextPath() + "/admin/book/edit?id=" + idStr);
                return;
            }
            if (stock < 0) {
                flash.addError("Số lượng tồn kho không được âm.");
                req.getSession().setAttribute("flashMessages", flash.getMessages());
                resp.sendRedirect(req.getContextPath() + "/admin/book/edit?id=" + idStr);
                return;
            }
            vn.bookstore.model.Book b = dao.findById(id);
            if (b == null) {
                flash.addError("Sách không tìm thấy.");
                req.getSession().setAttribute("flashMessages", flash.getMessages());
                resp.sendRedirect(req.getContextPath() + "/admin/books");
                return;
            }
            b.setTitle(title != null ? title.trim() : "");
            b.setAuthor(author != null ? author.trim() : "");
            b.setPrice(price);
            b.setStock(stock);
            b.setDescription(description != null ? description.trim() : "");

            // Update category if provided
            if (categoryIdStr != null && !categoryIdStr.trim().isEmpty()) {
                try {
                    int categoryId = Integer.parseInt(categoryIdStr);
                    b.setCategoryId(categoryId);
                } catch (NumberFormatException ex) {
                    ex.printStackTrace();
                }
            }

            // handle uploaded cover: replace existing file if present
            try {
                Part coverPart = null;
                try {
                    coverPart = req.getPart("cover");
                } catch (Exception ex) {
                    ex.printStackTrace();
                }
                if (coverPart != null && coverPart.getSize() > 0) {
                    // delete old file if exists
                    String old = b.getCoverUrl();
                    if (old != null && old.contains("/uploads/books/")) {
                        String oldFilename = old.substring(old.lastIndexOf('/') + 1);
                        String oldPath = req.getServletContext().getRealPath("/uploads/books/" + oldFilename);
                        try {
                            Files.deleteIfExists(Paths.get(oldPath));
                        } catch (Exception ex) {
                            ex.printStackTrace();
                        }
                    }
                    String submitted = coverPart.getSubmittedFileName();
                    String ext = "";
                    if (submitted != null && submitted.contains("."))
                        ext = submitted.substring(submitted.lastIndexOf('.'));
                    String filename = System.currentTimeMillis() + "-" + java.util.UUID.randomUUID() + ext;
                    String uploadsDir = req.getServletContext().getRealPath("/uploads/books");
                    Path uploadsPath = Paths.get(uploadsDir);
                    if (!Files.exists(uploadsPath))
                        Files.createDirectories(uploadsPath);
                    Path target = uploadsPath.resolve(filename);
                    try (InputStream in = coverPart.getInputStream()) {
                        Files.copy(in, target, StandardCopyOption.REPLACE_EXISTING);
                        b.setCoverUrl(req.getContextPath() + "/uploads/books/" + filename);
                    }
                }
            } catch (Exception ex) {
                ex.printStackTrace();
            }
            boolean ok = dao.update(b);
            if (ok)
                flash.addSuccess("Cập nhật sách thành công.");
            else
                flash.addError("Không thể cập nhật sách.");
        } catch (Exception e) {
            flash.addError("Lỗi hệ thống: " + e.getMessage());
        }
        req.getSession().setAttribute("flashMessages", flash.getMessages());
        resp.sendRedirect(req.getContextPath() + "/admin/books");
    }
}
