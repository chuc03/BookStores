package vn.bookstore.web.filter;

import java.io.IOException;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import vn.bookstore.util.CsrfUtil;

public class CsrfFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {}

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;

        HttpSession session = req.getSession(true);
        CsrfUtil.getOrCreateToken(session);

        String method = req.getMethod();
        boolean safe = method.equals("GET") || method.equals("HEAD") || method.equals("OPTIONS") || method.equals("TRACE");
        if (!safe) {
            String token = (String) session.getAttribute("csrfToken");
            String provided = req.getHeader("X-CSRF-Token");
            if (provided == null) provided = req.getParameter("_csrf");
            if (token == null || provided == null || !token.equals(provided)) {
                resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Invalid CSRF token");
                return;
            }
        }

        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {}
}
