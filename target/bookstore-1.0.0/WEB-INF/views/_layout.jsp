<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%
  String bodyPath = (String) request.getAttribute("body");
  boolean isAdmin = bodyPath != null && bodyPath.startsWith("/WEB-INF/admin/");
  request.setAttribute("isAdminPage", isAdmin);
  request.setAttribute("currentPath", request.getRequestURI());
%>
<!doctype html>
<html>
<head>
  <meta charset="utf-8"/>
  <jsp:include page="/WEB-INF/views/_csrf.jsp"/>
  <meta name="viewport" content="width=device-width, initial-scale=1"/>
  <title>${pageTitle}</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/vendor/bootstrap/css/bootstrap.min.css" />
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css?v=2.0" />
  
  <% if (!isAdmin) { %>
  <!-- Critical CSS for USER pages only - Vinabook Style -->
  <style>
    /* Critical CSS - Force override Bootstrap immediately */
    * { margin: 0; padding: 0; box-sizing: border-box; }
    a, a:hover, a:focus, a:active, a:visited { text-decoration: none !important; color: inherit; }
    
    /* Navbar */
    .navbar { background: white !important; border-bottom: 1px solid #dee2e6 !important; padding: 0 !important; box-shadow: 0 1px 3px rgba(0,0,0,0.05) !important; position: sticky !important; top: 0 !important; z-index: 1000 !important; }
    .navbar-top { display: none !important; }
    .navbar-main { padding: 10px 0 !important; border-bottom: 1px solid #e9ecef !important; }
    .navbar-main .container { display: grid !important; grid-template-columns: 180px 1fr auto auto !important; gap: 20px !important; align-items: center !important; }
    .navbar-brand { font-size: 1.5rem !important; font-weight: 700 !important; color: #dc3545 !important; padding: 0 !important; margin: 0 !important; white-space: nowrap !important; }
    .navbar-brand:hover { color: #c72333 !important; }
    .navbar-search { flex: 1 !important; max-width: 600px !important; }
    .cart-btn { display: flex !important; align-items: center !important; gap: 6px !important; padding: 8px 16px !important; border-radius: 24px !important; background: white !important; border: 1px solid #dee2e6 !important; color: #212529 !important; font-size: 0.9rem !important; font-weight: 500 !important; transition: all 0.3s ease !important; white-space: nowrap !important; }
    .cart-btn:hover { border-color: #dc3545 !important; color: #dc3545 !important; box-shadow: 0 2px 6px rgba(220,53,69,0.08) !important; }
    .cart-btn svg { width: 18px !important; height: 18px !important; }
    .search-form { display: flex !important; border: 2px solid #dc3545 !important; border-radius: 8px !important; overflow: hidden !important; }
    .search-input { flex: 1 !important; padding: 12px 16px !important; border: none !important; }
    .search-btn { padding: 12px 24px !important; background: #dc3545 !important; color: white !important; border: none !important; font-weight: 600 !important; }
    .navbar-nav { background: #dc3545 !important; padding: 8px 0 !important; margin: 0 !important; }
    .navbar-nav .container { display: flex !important; justify-content: center !important; gap: 24px !important; }
    .nav-link { color: white !important; font-weight: 500 !important; padding: 6px 12px !important; border-radius: 4px !important; font-size: 0.9rem !important; }
    .nav-link:hover { background: rgba(255,255,255,0.1) !important; color: white !important; }
    
    /* Hero Banner */
    .hero-banner { background: linear-gradient(135deg, #dc3545 0%, #ff6b35 100%) !important; color: white !important; padding: 32px 24px !important; border-radius: 12px !important; margin-bottom: 32px !important; box-shadow: 0 4px 16px rgba(0,0,0,0.12) !important; }
    .hero-banner, .hero-banner * { color: white !important; }
    .hero-title { font-size: 1.75rem !important; font-weight: 700 !important; margin-bottom: 10px !important; }
    .hero-text { font-size: 1rem !important; margin-bottom: 20px !important; max-width: 600px !important; }
    
    /* Categories */
    .section { padding: 32px 0 !important; }
    .section-header { margin-bottom: 24px !important; border-bottom: 2px solid #dc3545 !important; padding-bottom: 12px !important; }
    .section-title { font-size: 1.5rem !important; font-weight: 700 !important; text-transform: uppercase !important; color: #212529 !important; }
    .category-grid { display: grid !important; grid-template-columns: repeat(auto-fit, minmax(180px, 1fr)) !important; gap: 16px !important; margin-bottom: 32px !important; list-style: none !important; padding: 0 !important; }
    .category-card { display: block !important; background: white !important; border: 1px solid #e9ecef !important; border-radius: 8px !important; padding: 24px 16px !important; text-align: center !important; transition: all 0.3s ease !important; cursor: pointer !important; text-decoration: none !important; }
    .category-card:hover { box-shadow: 0 2px 8px rgba(0,0,0,0.08) !important; border-color: #dc3545 !important; transform: translateY(-4px) !important; }
    .category-icon { font-size: 2.5rem !important; margin-bottom: 12px !important; color: #dc3545 !important; display: block !important; }
    .category-name { font-weight: 600 !important; color: #212529 !important; font-size: 1rem !important; display: block !important; }
    
    /* Grid & Cards */
    .grid { display: grid !important; gap: 16px !important; list-style: none !important; padding: 0 !important; }
    .grid--4 { grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)) !important; }
    .card { background: white !important; border: 1px solid #e9ecef !important; border-radius: 8px !important; overflow: hidden !important; transition: all 0.3s ease !important; height: 100% !important; display: flex !important; flex-direction: column !important; }
    .card:hover { box-shadow: 0 6px 20px rgba(220,53,69,0.15) !important; transform: translateY(-4px) !important; border-color: #dc3545 !important; }
    .card-img-top { width: 100% !important; height: 280px !important; object-fit: cover !important; border-bottom: 1px solid #e9ecef !important; }
    .card-body { padding: 16px !important; flex: 1 !important; display: flex !important; flex-direction: column !important; }
    .card-title { font-size: 1rem !important; font-weight: 600 !important; margin-bottom: 8px !important; line-height: 1.4 !important; display: -webkit-box !important; -webkit-line-clamp: 2 !important; -webkit-box-orient: vertical !important; overflow: hidden !important; min-height: 2.8em !important; }
    .card-title a { color: #212529 !important; }
    .card-title a:hover { color: #dc3545 !important; }
    .card-text { font-size: 0.875rem !important; color: #6c757d !important; margin-bottom: 12px !important; flex: 1 !important; }
    .card-footer { padding: 12px 16px !important; background: #f8f9fa !important; border-top: 1px solid #e9ecef !important; display: flex !important; justify-content: space-between !important; align-items: center !important; }
    .card-price { font-size: 1.125rem !important; font-weight: 700 !important; color: #dc3545 !important; }
    
    /* Footer */
    .footer { background: #212529 !important; color: white !important; padding: 48px 0 24px !important; margin-top: 64px !important; }
    .footer, .footer * { color: rgba(255,255,255,0.8) !important; }
    .footer-title { color: white !important; font-weight: 700 !important; }
    .footer a:hover { color: white !important; }
    
    /* Buttons */
    .btn { border-radius: 4px !important; padding: 12px 24px !important; font-weight: 500 !important; transition: all 0.3s ease !important; }
    .btn-primary { background: #dc3545 !important; border-color: #dc3545 !important; color: white !important; }
    .btn-primary:hover { background: #c72333 !important; border-color: #c72333 !important; transform: translateY(-2px) !important; box-shadow: 0 2px 8px rgba(0,0,0,0.08) !important; }
    .btn-outline-primary { background: transparent !important; color: #dc3545 !important; border-color: #dc3545 !important; }
    .btn-outline-primary:hover { background: #dc3545 !important; color: white !important; }
    
    /* Container */
    .container { width: min(1200px, 95%) !important; margin-inline: auto !important; }
    
    /* User Menu */
    .navbar-user { display: flex !important; align-items: center !important; gap: 8px !important; }
    .user-dropdown-toggle { display: flex !important; align-items: center !important; gap: 8px !important; padding: 6px 12px 6px 6px !important; border-radius: 24px !important; background: white !important; border: 1px solid #dee2e6 !important; transition: all 0.3s ease !important; cursor: pointer !important; text-decoration: none !important; }
    .user-dropdown-toggle:hover { border-color: #dc3545 !important; box-shadow: 0 2px 6px rgba(220,53,69,0.08) !important; }
    .user-avatar { width: 36px !important; height: 36px !important; border-radius: 50% !important; background: linear-gradient(135deg, #dc3545, #ff6b35) !important; color: white !important; display: flex !important; align-items: center !important; justify-content: center !important; font-size: 1rem !important; font-weight: 700 !important; }
    .user-name { font-weight: 600 !important; color: #212529 !important; font-size: 0.9rem !important; max-width: 150px !important; overflow: hidden !important; text-overflow: ellipsis !important; white-space: nowrap !important; }
    .auth-btn { display: flex !important; align-items: center !important; gap: 6px !important; padding: 8px 16px !important; border-radius: 24px !important; font-size: 0.9rem !important; font-weight: 500 !important; transition: all 0.3s ease !important; text-decoration: none !important; }
    .auth-btn svg { width: 16px !important; height: 16px !important; }
    .auth-btn-login { background: white !important; border: 1px solid #dee2e6 !important; color: #212529 !important; }
    .auth-btn-login:hover { border-color: #dc3545 !important; color: #dc3545 !important; box-shadow: 0 2px 6px rgba(220,53,69,0.08) !important; }
    .auth-btn-register { background: linear-gradient(135deg, #dc3545, #ff6b35) !important; border: none !important; color: white !important; }
    .auth-btn-register:hover { box-shadow: 0 2px 8px rgba(220,53,69,0.2) !important; transform: translateY(-1px) !important; }
    .logout-btn { display: flex !important; align-items: center !important; gap: 6px !important; padding: 8px 16px !important; border-radius: 24px !important; background: #dc3545 !important; color: white !important; border: none !important; font-size: 0.9rem !important; font-weight: 500 !important; cursor: pointer !important; transition: all 0.3s ease !important; text-decoration: none !important; }
    .logout-btn:hover { background: #c72333 !important; box-shadow: 0 2px 8px rgba(220,53,69,0.3) !important; transform: translateY(-1px) !important; color: white !important; }
    .logout-btn svg { width: 16px !important; height: 16px !important; }
  </style>
  <% } else { %>
  <!-- ADMIN PAGE - Modern Dashboard Design -->
  <style>
    body { background: #f5f6fa !important; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif !important; margin: 0 !important; padding: 0 !important; }
    
    /* Admin Layout */
    .admin-wrapper { display: flex !important; min-height: 100vh !important; }
    
    /* Sidebar */
    .admin-sidebar { width: 260px !important; background: linear-gradient(180deg, #1e3a8a 0%, #1e40af 100%) !important; color: white !important; position: fixed !important; height: 100vh !important; overflow-y: auto !important; box-shadow: 2px 0 10px rgba(0,0,0,0.1) !important; z-index: 1000 !important; transition: width 0.3s ease, transform 0.3s ease !important; }
    .admin-sidebar.collapsed { width: 70px !important; }
    .admin-sidebar::-webkit-scrollbar { width: 6px !important; }
    .admin-sidebar::-webkit-scrollbar-track { background: rgba(255,255,255,0.1) !important; }
    .admin-sidebar::-webkit-scrollbar-thumb { background: rgba(255,255,255,0.3) !important; border-radius: 3px !important; }
    
    .sidebar-brand { padding: 24px 20px !important; border-bottom: 1px solid rgba(255,255,255,0.1) !important; display: flex !important; align-items: center !important; justify-content: space-between !important; }
    .sidebar-brand h4 { margin: 0 !important; font-size: 1.5rem !important; font-weight: 700 !important; color: white !important; display: flex !important; align-items: center !important; gap: 10px !important; white-space: nowrap !important; overflow: hidden !important; }
    .admin-sidebar.collapsed .sidebar-brand h4 span { display: none !important; }
    .toggle-sidebar { background: rgba(255,255,255,0.1) !important; border: none !important; color: white !important; width: 32px !important; height: 32px !important; border-radius: 6px !important; display: flex !important; align-items: center !important; justify-content: center !important; cursor: pointer !important; transition: all 0.2s !important; flex-shrink: 0 !important; }
    .toggle-sidebar:hover { background: rgba(255,255,255,0.2) !important; }
    .admin-sidebar.collapsed .toggle-sidebar { margin: 0 auto !important; }
    
    .sidebar-nav { padding: 20px 0 !important; }
    .nav-section-title { padding: 0 20px !important; font-size: 0.75rem !important; text-transform: uppercase !important; letter-spacing: 1px !important; color: rgba(255,255,255,0.6) !important; margin: 20px 0 10px !important; font-weight: 600 !important; white-space: nowrap !important; overflow: hidden !important; transition: opacity 0.2s !important; }
    .admin-sidebar.collapsed .nav-section-title { opacity: 0 !important; height: 0 !important; margin: 0 !important; padding: 0 !important; }
    
    .nav-item { margin: 4px 12px !important; }
    .nav-link { display: flex !important; align-items: center !important; gap: 12px !important; padding: 12px 16px !important; color: rgba(255,255,255,0.85) !important; border-radius: 8px !important; transition: all 0.2s !important; font-size: 0.95rem !important; text-decoration: none !important; white-space: nowrap !important; overflow: hidden !important; }
    .nav-link:hover { background: rgba(255,255,255,0.1) !important; color: white !important; transform: translateX(4px) !important; }
    .nav-link.active { background: rgba(255,255,255,0.15) !important; color: white !important; font-weight: 600 !important; }
    .nav-link svg { width: 20px !important; height: 20px !important; flex-shrink: 0 !important; }
    .admin-sidebar.collapsed .nav-link { justify-content: center !important; padding: 12px !important; }
    .admin-sidebar.collapsed .nav-link span { display: none !important; }
    .admin-sidebar.collapsed .nav-link:hover { transform: none !important; }
    
    /* Main Content */
    .admin-main { margin-left: 260px !important; flex: 1 !important; display: flex !important; flex-direction: column !important; min-height: 100vh !important; transition: margin-left 0.3s ease !important; }
    .admin-sidebar.collapsed ~ .admin-main { margin-left: 70px !important; }
    
    /* Top Header */
    .admin-header { background: white !important; padding: 16px 32px !important; box-shadow: 0 2px 4px rgba(0,0,0,0.05) !important; display: flex !important; justify-content: space-between !important; align-items: center !important; position: sticky !important; top: 0 !important; z-index: 999 !important; }
    .admin-header-left h5 { margin: 0 !important; font-size: 1.25rem !important; font-weight: 600 !important; color: #1e293b !important; }
    .admin-header-right { display: flex !important; align-items: center !important; gap: 16px !important; }
    
    /* Content Area */
    .admin-content { padding: 32px !important; flex: 1 !important; max-width: 100% !important; box-sizing: border-box !important; overflow-x: hidden !important; }
    
    /* Cards */
    .admin-card { background: white !important; border-radius: 12px !important; padding: 24px !important; margin-bottom: 24px !important; box-shadow: 0 1px 3px rgba(0,0,0,0.08) !important; border: 1px solid #e5e7eb !important; }
    .admin-title { margin: 0 0 24px 0 !important; font-size: 1.5rem !important; font-weight: 700 !important; color: #1e293b !important; }
    
    /* Dashboard Stats */
    .stats-grid { display: grid !important; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)) !important; gap: 20px !important; margin-bottom: 32px !important; }
    .stat-card { background: white !important; border-radius: 12px !important; padding: 24px !important; box-shadow: 0 1px 3px rgba(0,0,0,0.08) !important; border-left: 4px solid #3b82f6 !important; transition: all 0.3s !important; }
    .stat-card:hover { box-shadow: 0 4px 12px rgba(0,0,0,0.12) !important; transform: translateY(-2px) !important; }
    .stat-card.success { border-left-color: #10b981 !important; }
    .stat-card.warning { border-left-color: #f59e0b !important; }
    .stat-card.danger { border-left-color: #ef4444 !important; }
    .stat-label { font-size: 0.875rem !important; color: #64748b !important; margin-bottom: 8px !important; font-weight: 500 !important; text-transform: uppercase !important; letter-spacing: 0.5px !important; display: block !important; }
    .stat-value { font-size: 2rem !important; font-weight: 700 !important; color: #1e293b !important; margin: 0 !important; display: block !important; }
    
    /* Buttons */
    .btn { display: inline-block !important; font-weight: 500 !important; text-align: center !important; cursor: pointer !important; border: 1px solid transparent !important; padding: 0.625rem 1.25rem !important; font-size: 0.925rem !important; border-radius: 8px !important; transition: all 0.2s !important; text-decoration: none !important; }
    .btn-primary { color: white !important; background: linear-gradient(135deg, #3b82f6, #2563eb) !important; border: none !important; box-shadow: 0 1px 3px rgba(59,130,246,0.3) !important; }
    .btn-primary:hover { background: linear-gradient(135deg, #2563eb, #1d4ed8) !important; box-shadow: 0 4px 8px rgba(59,130,246,0.4) !important; transform: translateY(-1px) !important; }
    .btn-success { color: white !important; background: linear-gradient(135deg, #10b981, #059669) !important; border: none !important; box-shadow: 0 1px 3px rgba(16,185,129,0.3) !important; }
    .btn-success:hover { background: linear-gradient(135deg, #059669, #047857) !important; box-shadow: 0 4px 8px rgba(16,185,129,0.4) !important; transform: translateY(-1px) !important; }
    .btn-danger { color: white !important; background: linear-gradient(135deg, #ef4444, #dc2626) !important; border: none !important; box-shadow: 0 1px 3px rgba(239,68,68,0.3) !important; }
    .btn-danger:hover { background: linear-gradient(135deg, #dc2626, #b91c1c) !important; box-shadow: 0 4px 8px rgba(239,68,68,0.4) !important; transform: translateY(-1px) !important; }
    .btn-sm { padding: 0.4rem 0.875rem !important; font-size: 0.875rem !important; }
    .btn-outline-primary { color: #3b82f6 !important; border: 2px solid #3b82f6 !important; background: white !important; }
    .btn-outline-primary:hover { background: #3b82f6 !important; color: white !important; }
    .btn:disabled { opacity: 0.5 !important; cursor: not-allowed !important; pointer-events: none !important; }
    
    /* Forms */
    .form-label { font-weight: 600 !important; color: #374151 !important; margin-bottom: 0.5rem !important; font-size: 0.9rem !important; display: block !important; }
    .form-control, .form-select { border: 2px solid #e5e7eb !important; border-radius: 8px !important; padding: 0.625rem 0.875rem !important; font-size: 0.95rem !important; transition: all 0.2s !important; width: 100% !important; box-sizing: border-box !important; }
    .form-control:focus, .form-select:focus { border-color: #3b82f6 !important; box-shadow: 0 0 0 3px rgba(59,130,246,0.1) !important; outline: none !important; }
    .form-control:disabled, .form-select:disabled { background-color: #f9fafb !important; cursor: not-allowed !important; opacity: 0.6 !important; }
    
    /* Tables */
    .table-responsive { background: white !important; border-radius: 8px !important; overflow-x: auto !important; -webkit-overflow-scrolling: touch !important; }
    .table { width: 100% !important; margin-bottom: 0 !important; color: #1e293b !important; border-collapse: collapse !important; }
    .table thead th { padding: 16px !important; background: #f8fafc !important; font-weight: 600 !important; font-size: 0.875rem !important; color: #475569 !important; text-transform: uppercase !important; letter-spacing: 0.5px !important; border-bottom: 2px solid #e5e7eb !important; }
    .table tbody td { padding: 16px !important; border-bottom: 1px solid #f1f5f9 !important; vertical-align: middle !important; }
    .table tbody tr:hover { background: #f9fafb !important; }
    .table tbody tr:last-child td { border-bottom: none !important; }
    
    /* Pagination */
    .pagination { display: flex !important; gap: 4px !important; padding: 0 !important; margin: 20px 0 0 !important; list-style: none !important; justify-content: center !important; }
    .page-item .page-link { padding: 8px 14px !important; border: 2px solid #e5e7eb !important; background: white !important; color: #64748b !important; border-radius: 6px !important; font-weight: 500 !important; transition: all 0.2s !important; text-decoration: none !important; }
    .page-item.active .page-link { background: #3b82f6 !important; border-color: #3b82f6 !important; color: white !important; }
    .page-item:not(.disabled) .page-link:hover { background: #f1f5f9 !important; border-color: #cbd5e1 !important; }
    .page-item.disabled .page-link { opacity: 0.5 !important; cursor: not-allowed !important; }
    
    /* Alerts */
    .alert { position: relative !important; padding: 1rem 1.25rem !important; margin-bottom: 1rem !important; border: 1px solid transparent !important; border-radius: 8px !important; }
    .alert-success { color: #0f5132 !important; background-color: #d1e7dd !important; border-color: #badbcc !important; }
    .alert-danger { color: #842029 !important; background-color: #f8d7da !important; border-color: #f5c2c7 !important; }
    .alert-warning { color: #664d03 !important; background-color: #fff3cd !important; border-color: #ffecb5 !important; }
    .alert-info { color: #055160 !important; background-color: #cff4fc !important; border-color: #b6effb !important; }
    .alert-dismissible .btn-close { position: absolute !important; top: 0 !important; right: 0 !important; padding: 1.25rem 1rem !important; background: transparent !important; border: 0 !important; opacity: 0.5 !important; }
    .btn-close { cursor: pointer !important; }
    .btn-close:hover { opacity: 1 !important; }
    .fade { transition: opacity 0.15s linear !important; }
    .fade.show { opacity: 1 !important; }
    
    /* Grid System */
    .row { display: flex !important; flex-wrap: wrap !important; margin: 0 -12px !important; }
    .col-md-3 { flex: 0 0 25% !important; max-width: 25% !important; padding: 0 12px !important; box-sizing: border-box !important; }
    .col-md-4 { flex: 0 0 33.333333% !important; max-width: 33.333333% !important; padding: 0 12px !important; box-sizing: border-box !important; }
    .col-md-6 { flex: 0 0 50% !important; max-width: 50% !important; padding: 0 12px !important; box-sizing: border-box !important; }
    .col-md-9 { flex: 0 0 75% !important; max-width: 75% !important; padding: 0 12px !important; box-sizing: border-box !important; }
    .col-12 { flex: 0 0 100% !important; max-width: 100% !important; padding: 0 12px !important; box-sizing: border-box !important; }
    .g-3 { gap: 1rem !important; }
    
    /* Utilities */
    .d-flex { display: flex !important; }
    .d-block { display: block !important; }
    .gap-2 { gap: 0.5rem !important; }
    .mb-3 { margin-bottom: 1rem !important; }
    .me-1 { margin-right: 0.25rem !important; }
    .me-2 { margin-right: 0.5rem !important; }
    .p-3 { padding: 1rem !important; }
    .justify-content-center { justify-content: center !important; }
    .align-items-center { align-items: center !important; }
    .text-muted { color: #6c757d !important; }
    .text-danger { color: #dc3545 !important; }
    .small { font-size: 0.875rem !important; }
    hr { margin: 1rem 0 !important; border: 0 !important; border-top: 1px solid #dee2e6 !important; }
    textarea { min-height: 100px !important; resize: vertical !important; }
    
    /* Responsive */
    @media (max-width: 768px) {
      .admin-sidebar { width: 70px !important; }
      .admin-sidebar .sidebar-brand h4 span { display: none !important; }
      .admin-sidebar .nav-section-title { opacity: 0 !important; height: 0 !important; margin: 0 !important; padding: 0 !important; }
      .admin-sidebar .nav-link { justify-content: center !important; padding: 12px !important; }
      .admin-sidebar .nav-link span { display: none !important; }
      .admin-main { margin-left: 70px !important; }
      .col-md-3, .col-md-4, .col-md-6, .col-md-9 { flex: 0 0 100% !important; max-width: 100% !important; }
    }
  </style>
  <% } %>

</head>
<body>
<!-- Flash Messages Display -->
<c:if test="${not empty sessionScope.flashMessages}">
  <div class="container mt-3">
    <c:forEach var="msg" items="${sessionScope.flashMessages}">
      <div class="alert ${msg.bootstrapAlertClass} alert-dismissible fade show" role="alert">
        ${msg.message}
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
      </div>
    </c:forEach>
    <%
      session.removeAttribute("flashMessages");
    %>
  </div>
</c:if>

<% if (isAdmin) { %>
  <!-- ===== ADMIN LAYOUT - Modern Dashboard ===== -->
  <div class="admin-wrapper">
    <!-- Sidebar -->
    <aside class="admin-sidebar" id="adminSidebar">
      <div class="sidebar-brand">
        <h4>
          <span>Admin</span>
        </h4>
        <button class="toggle-sidebar" onclick="toggleSidebar()" title="Thu gọn menu">
          <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="currentColor" viewBox="0 0 16 16">
            <path fill-rule="evenodd" d="M2.5 12a.5.5 0 0 1 .5-.5h10a.5.5 0 0 1 0 1H3a.5.5 0 0 1-.5-.5zm0-4a.5.5 0 0 1 .5-.5h10a.5.5 0 0 1 0 1H3a.5.5 0 0 1-.5-.5zm0-4a.5.5 0 0 1 .5-.5h10a.5.5 0 0 1 0 1H3a.5.5 0 0 1-.5-.5z"/>
          </svg>
        </button>
      </div>
      
      <nav class="sidebar-nav">
        <div class="nav-section-title">Menu chính</div>
        <div class="nav-item">
          <a class="nav-link ${fn:contains(currentPath, '/admin') && !fn:contains(currentPath, '/admin/books') && !fn:contains(currentPath, '/admin/categories') && !fn:contains(currentPath, '/admin/orders') ? 'active' : ''}" href="${pageContext.request.contextPath}/admin">
            <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="currentColor" viewBox="0 0 16 16">
              <path d="M8 4a.5.5 0 0 1 .5.5V6a.5.5 0 0 1-1 0V4.5A.5.5 0 0 1 8 4zM3.732 5.732a.5.5 0 0 1 .707 0l.915.914a.5.5 0 1 1-.708.708l-.914-.915a.5.5 0 0 1 0-.707zM2 10a.5.5 0 0 1 .5-.5h1.586a.5.5 0 0 1 0 1H2.5A.5.5 0 0 1 2 10zm9.5 0a.5.5 0 0 1 .5-.5h1.5a.5.5 0 0 1 0 1H12a.5.5 0 0 1-.5-.5zm.754-4.246a.389.389 0 0 0-.527-.02L7.547 9.31a.91.91 0 1 0 1.302 1.258l3.434-4.297a.389.389 0 0 0-.029-.518z"/>
              <path fill-rule="evenodd" d="M0 10a8 8 0 1 1 15.547 2.661c-.442 1.253-1.845 1.602-2.932 1.25C11.309 13.488 9.475 13 8 13c-1.474 0-3.31.488-4.615.911-1.087.352-2.49.003-2.932-1.25A7.988 7.988 0 0 1 0 10zm8-7a7 7 0 0 0-6.603 9.329c.203.575.923.876 1.68.63C4.397 12.533 6.358 12 8 12s3.604.532 4.923.96c.757.245 1.477-.056 1.68-.631A7 7 0 0 0 8 3z"/>
            </svg>
            <span>Dashboard</span>
          </a>
        </div>
        
        <div class="nav-section-title">Quản lý</div>
        <div class="nav-item">
          <a class="nav-link ${fn:contains(currentPath, '/admin/books') || fn:contains(currentPath, '/admin/book') ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/books">
            <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="currentColor" viewBox="0 0 16 16">
              <path d="M1 2.828c.885-.37 2.154-.769 3.388-.893 1.33-.134 2.458.063 3.112.752v9.746c-.935-.53-2.12-.603-3.213-.493-1.18.12-2.37.461-3.287.811V2.828zm7.5-.141c.654-.689 1.782-.886 3.112-.752 1.234.124 2.503.523 3.388.893v9.923c-.918-.35-2.107-.692-3.287-.81-1.094-.111-2.278-.039-3.213.492V2.687zM8 1.783C7.015.936 5.587.81 4.287.94c-1.514.153-3.042.672-3.994 1.105A.5.5 0 0 0 0 2.5v11a.5.5 0 0 0 .707.455c.882-.4 2.303-.881 3.68-1.02 1.409-.142 2.59.087 3.223.877a.5.5 0 0 0 .78 0c.633-.79 1.814-1.019 3.222-.877 1.378.139 2.8.62 3.681 1.02A.5.5 0 0 0 16 13.5v-11a.5.5 0 0 0-.293-.455c-.952-.433-2.48-.952-3.994-1.105C10.413.809 8.985.936 8 1.783z"/>
            </svg>
            <span>Quản lý sách</span>
          </a>
        </div>
        <div class="nav-item">
          <a class="nav-link ${fn:contains(currentPath, '/admin/categories') ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/categories">
            <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="currentColor" viewBox="0 0 16 16">
              <path d="M0 2a2 2 0 0 1 2-2h12a2 2 0 0 1 2 2v12a2 2 0 0 1-2 2H2a2 2 0 0 1-2-2V2zm8.5 2v1.5H15V2a1 1 0 0 0-1-1H9.5a1 1 0 0 0-1 1v2zM1 4v10a1 1 0 0 0 1 1h6.5a1 1 0 0 0 1-1V4H1z"/>
            </svg>
            <span>Danh mục</span>
          </a>
        </div>
        <div class="nav-item">
          <a class="nav-link ${fn:contains(currentPath, '/admin/orders') ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/orders">
            <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="currentColor" viewBox="0 0 16 16">
              <path d="M5 1a2 2 0 0 0-2 2v2H2a2 2 0 0 0-2 2v6a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V7a2 2 0 0 0-2-2h-1V3a2 2 0 0 0-2-2H5zM4 3a1 1 0 0 1 1-1h6a1 1 0 0 1 1 1v2H4V3zm1 5a1 1 0 0 1 1-1h4a1 1 0 0 1 1 1v3a1 1 0 0 1-1 1H6a1 1 0 0 1-1-1V8z"/>
            </svg>
            <span>Đơn hàng</span>
          </a>
        </div>
        <div class="nav-item">
          <a class="nav-link ${fn:contains(currentPath, '/admin/users') ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/users">
            <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="currentColor" viewBox="0 0 16 16">
              <path d="M15 14s1 0 1-1-1-4-5-4-5 3-5 4 1 1 1 1h8zm-7.978-1A.261.261 0 0 1 7 12.996c.001-.264.167-1.03.76-1.72C8.312 10.629 9.282 10 11 10c1.717 0 2.687.63 3.24 1.276.593.69.758 1.457.76 1.72l-.008.002a.274.274 0 0 1-.014.002H7.022zM11 7a2 2 0 1 0 0-4 2 2 0 0 0 0 4zm3-2a3 3 0 1 1-6 0 3 3 0 0 1 6 0zM6.936 9.28a5.88 5.88 0 0 0-1.23-.247A7.35 7.35 0 0 0 5 9c-4 0-5 3-5 4 0 .667.333 1 1 1h4.216A2.238 2.238 0 0 1 5 13c0-1.01.377-2.042 1.09-2.904.243-.294.526-.569.846-.816zM4.92 10A5.493 5.493 0 0 0 4 13H1c0-.26.164-1.03.76-1.724.545-.636 1.492-1.256 3.16-1.275zM1.5 5.5a3 3 0 1 1 6 0 3 3 0 0 1-6 0zm3-2a2 2 0 1 0 0 4 2 2 0 0 0 0-4z"/>
            </svg>
            <span>Quản lý Users</span>
          </a>
        </div>
        
        <div class="nav-section-title">Khác</div>
        <div class="nav-item">
          <a class="nav-link" href="${pageContext.request.contextPath}/">
            <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="currentColor" viewBox="0 0 16 16">
              <path d="M8.354 1.146a.5.5 0 0 0-.708 0l-6 6A.5.5 0 0 0 1.5 7.5v7a.5.5 0 0 0 .5.5h4.5a.5.5 0 0 0 .5-.5v-4h2v4a.5.5 0 0 0 .5.5H14a.5.5 0 0 0 .5-.5v-7a.5.5 0 0 0-.146-.354L8.354 1.146zM2.5 14V7.707l5.5-5.5 5.5 5.5V14H10v-4a.5.5 0 0 0-.5-.5h-3a.5.5 0 0 0-.5.5v4H2.5z"/>
            </svg>
            <span>Trang chủ</span>
          </a>
        </div>
        <div class="nav-item">
          <a class="nav-link" href="${pageContext.request.contextPath}/logout">
            <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="currentColor" viewBox="0 0 16 16">
              <path fill-rule="evenodd" d="M10 12.5a.5.5 0 0 1-.5.5h-8a.5.5 0 0 1-.5-.5v-9a.5.5 0 0 1 .5-.5h8a.5.5 0 0 1 .5.5v2a.5.5 0 0 0 1 0v-2A1.5 1.5 0 0 0 9.5 2h-8A1.5 1.5 0 0 0 0 3.5v9A1.5 1.5 0 0 0 1.5 14h8a1.5 1.5 0 0 0 1.5-1.5v-2a.5.5 0 0 0-1 0v2z"/>
              <path fill-rule="evenodd" d="M15.854 8.354a.5.5 0 0 0 0-.708l-3-3a.5.5 0 0 0-.708.708L14.293 7.5H5.5a.5.5 0 0 0 0 1h8.793l-2.147 2.146a.5.5 0 0 0 .708.708l3-3z"/>
            </svg>
            <span>Đăng xuất</span>
          </a>
        </div>
      </nav>
    </aside>
    
    <!-- Main Content -->
    <main class="admin-main">
      <!-- Top Header -->
      <header class="admin-header">
        <div class="admin-header-left">
          <h5>Hệ thống quản trị BookStore</h5>
        </div>
        <div class="admin-header-right">
          <c:if test="${not empty sessionScope.me}">
            <span style="color: #64748b; font-size: 0.9rem; margin-right: 8px;">Xin chào,</span>
            <span style="color: #1e293b; font-weight: 600; font-size: 0.9rem;">${sessionScope.me.fullName}</span>
          </c:if>
        </div>
      </header>
      
      <!-- Flash Messages in Admin -->
      <c:if test="${not empty sessionScope.flashMessages}">
        <div style="padding: 20px 32px 0;">
          <c:forEach var="msg" items="${sessionScope.flashMessages}">
            <div class="alert ${msg.bootstrapAlertClass} alert-dismissible fade show" role="alert">
              ${msg.message}
              <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
          </c:forEach>
          <% session.removeAttribute("flashMessages"); %>
        </div>
      </c:if>
      
      <!-- Content -->
      <div class="admin-content">
        <jsp:include page="<%= bodyPath %>" />
      </div>
    </main>
  </div>
<% } else { %>
  <!-- ===== USER HEADER - Vinabook Style ===== -->
<header class="navbar">
  <!-- Main Navigation - All in one row -->
  <div class="navbar-main">
    <div class="container">
      <a class="navbar-brand" href="${pageContext.request.contextPath}/">
        📚 BookStore
      </a>

      <div class="navbar-search">
        <form class="search-form" method="get" action="${pageContext.request.contextPath}/search">
          <input class="search-input" name="q" value="${param.q}" placeholder="Tìm kiếm sách theo tên, tác giả..."/>
          <button class="search-btn" type="submit">Tìm kiếm</button>
        </form>
      </div>

      <a href="${pageContext.request.contextPath}/cart" class="cart-btn">
        <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" fill="currentColor" viewBox="0 0 16 16">
          <path d="M0 1.5A.5.5 0 0 1 .5 1H2a.5.5 0 0 1 .485.379L2.89 3H14.5a.5.5 0 0 1 .491.592l-1.5 8A.5.5 0 0 1 13 12H4a.5.5 0 0 1-.491-.408L2.01 3.607 1.61 2H.5a.5.5 0 0 1-.5-.5zM3.102 4l1.313 7h8.17l1.313-7H3.102zM5 12a2 2 0 1 0 0 4 2 2 0 0 0 0-4zm7 0a2 2 0 1 0 0 4 2 2 0 0 0 0-4zm-7 1a1 1 0 1 1 0 2 1 1 0 0 1 0-2zm7 0a1 1 0 1 1 0 2 1 1 0 0 1 0-2z"/>
        </svg>
        <span>Giỏ hàng</span>
      </a>

      <div class="navbar-user">
        <c:choose>
          <c:when test="${not empty sessionScope.me}">
            <a class="user-dropdown-toggle" href="${pageContext.request.contextPath}/account">
              <div class="user-avatar">${fn:substring(sessionScope.me.fullName,0,1)}</div>
              <span class="user-name">${sessionScope.me.fullName}</span>
            </a>
            <a href="${pageContext.request.contextPath}/logout" class="logout-btn">
              <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" viewBox="0 0 16 16">
                <path fill-rule="evenodd" d="M10 12.5a.5.5 0 0 1-.5.5h-8a.5.5 0 0 1-.5-.5v-9a.5.5 0 0 1 .5-.5h8a.5.5 0 0 1 .5.5v2a.5.5 0 0 0 1 0v-2A1.5 1.5 0 0 0 9.5 2h-8A1.5 1.5 0 0 0 0 3.5v9A1.5 1.5 0 0 0 1.5 14h8a1.5 1.5 0 0 0 1.5-1.5v-2a.5.5 0 0 0-1 0v2z"/>
                <path fill-rule="evenodd" d="M15.854 8.354a.5.5 0 0 0 0-.708l-3-3a.5.5 0 0 0-.708.708L14.293 7.5H5.5a.5.5 0 0 0 0 1h8.793l-2.147 2.146a.5.5 0 0 0 .708.708l3-3z"/>
              </svg>
              Đăng xuất
            </a>
          </c:when>
          <c:otherwise>
            <a href="${pageContext.request.contextPath}/login" class="auth-btn auth-btn-login">
              <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" viewBox="0 0 16 16">
                <path fill-rule="evenodd" d="M6 3.5a.5.5 0 0 1 .5-.5h8a.5.5 0 0 1 .5.5v9a.5.5 0 0 1-.5.5h-8a.5.5 0 0 1-.5-.5v-2a.5.5 0 0 0-1 0v2A1.5 1.5 0 0 0 6.5 14h8a1.5 1.5 0 0 0 1.5-1.5v-9A1.5 1.5 0 0 0 14.5 2h-8A1.5 1.5 0 0 0 5 3.5v2a.5.5 0 0 0 1 0v-2z"/>
                <path fill-rule="evenodd" d="M11.854 8.354a.5.5 0 0 0 0-.708l-3-3a.5.5 0 1 0-.708.708L10.293 7.5H1.5a.5.5 0 0 0 0 1h8.793l-2.147 2.146a.5.5 0 0 0 .708.708l3-3z"/>
              </svg>
              Đăng nhập
            </a>
            <a href="${pageContext.request.contextPath}/register" class="auth-btn auth-btn-register">
              <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" viewBox="0 0 16 16">
                <path d="M8 8a3 3 0 1 0 0-6 3 3 0 0 0 0 6zm2-3a2 2 0 1 1-4 0 2 2 0 0 1 4 0zm4 8c0 1-1 1-1 1H3s-1 0-1-1 1-4 6-4 6 3 6 4zm-1-.004c-.001-.246-.154-.986-.832-1.664C11.516 10.68 10.289 10 8 10c-2.29 0-3.516.68-4.168 1.332-.678.678-.83 1.418-.832 1.664h10z"/>
              </svg>
              Đăng ký
            </a>
          </c:otherwise>
        </c:choose>
      </div>
    </div>
  </div>

  <!-- Category Navigation -->
  <div class="navbar-nav">
    <div class="container">
      <a class="nav-link" href="${pageContext.request.contextPath}/">Trang chủ</a>
      <a class="nav-link" href="${pageContext.request.contextPath}/books">Tất cả sách</a>
      <a class="nav-link" href="${pageContext.request.contextPath}/books?category=van-hoc">Văn học</a>
      <a class="nav-link" href="${pageContext.request.contextPath}/books?category=kinh-te">Kinh tế</a>
      <a class="nav-link" href="${pageContext.request.contextPath}/books?category=tam-ly-ky-nang-song">Tâm lý - Kỹ năng</a>
      <a class="nav-link" href="${pageContext.request.contextPath}/books?category=thieu-nhi">Thiếu nhi</a>
    </div>
  </div>
</header>

<!-- ===== USER CONTENT ===== -->
<div class="container py-3">
  <jsp:include page="<%= bodyPath %>"/>
</div>

<!-- ===== FOOTER - Vinabook Style ===== -->
<footer class="footer">
  <div class="container">
    <div class="footer-top">
      <div class="row">
        <div class="col-md-3">
          <div class="footer-section">
            <h5 class="footer-title">VỀ BOOKSTORE</h5>
            <p style="color: rgba(255,255,255,0.8); font-size: 0.875rem;">
              Cửa hàng sách trực tuyến hàng đầu Việt Nam. 
              Chuyên cung cấp sách văn học, kinh tế, thiếu nhi với giá tốt nhất.
            </p>
            <div class="footer-social">
              <a href="#" class="social-link" title="Facebook">📘</a>
              <a href="#" class="social-link" title="Instagram">📷</a>
              <a href="#" class="social-link" title="YouTube">📺</a>
              <a href="#" class="social-link" title="Twitter">🐦</a>
            </div>
          </div>
        </div>

        <div class="col-md-3">
          <div class="footer-section">
            <h5 class="footer-title">DANH MỤC</h5>
            <ul class="footer-links">
              <li><a href="${pageContext.request.contextPath}/books">Tất cả sách</a></li>
              <li><a href="${pageContext.request.contextPath}/books?category=van-hoc">Văn học</a></li>
              <li><a href="${pageContext.request.contextPath}/books?category=kinh-te">Kinh tế</a></li>
              <li><a href="${pageContext.request.contextPath}/books?category=tam-ly-ky-nang-song">Tâm lý - Kỹ năng sống</a></li>
              <li><a href="${pageContext.request.contextPath}/books?category=thieu-nhi">Thiếu nhi</a></li>
            </ul>
          </div>
        </div>

        <div class="col-md-3">
          <div class="footer-section">
            <h5 class="footer-title">HỖ TRỢ KHÁCH HÀNG</h5>
            <ul class="footer-links">
              <li><a href="${pageContext.request.contextPath}/cart">Giỏ hàng</a></li>
              <li><a href="${pageContext.request.contextPath}/orders">Đơn hàng của tôi</a></li>
              <li><a href="#">Chính sách đổi trả</a></li>
              <li><a href="#">Phương thức thanh toán</a></li>
              <li><a href="#">Vận chuyển & Giao hàng</a></li>
            </ul>
          </div>
        </div>

        <div class="col-md-3">
          <div class="footer-section">
            <h5 class="footer-title">LIÊN HỆ</h5>
            <ul class="footer-links">
              <li style="color: rgba(255,255,255,0.8);"> Hotline: 0123-456-789</li>
              <li style="color: rgba(255,255,255,0.8);">📧 Email: support@bookstore.com</li>
              <li style="color: rgba(255,255,255,0.8);">🕐 T2-T7: 8:00 - 20:00</li>
            </ul>
          </div>
        </div>
      </div>
    </div>

    <div class="footer-bottom">
      <p style="margin: 0;">
        © 2025 BookStore - Cửa hàng sách trực tuyến uy tín.
      </p>
      <p style="margin-top: 8px; font-size: 0.75rem;">
        Chấp nhận thanh toán: VISA, Mastercard, JCB, COD | 
        Vận chuyển: GHTK, Ninja Van, VNPost
      </p>
    </div>
  </div>
</footer>
<% } %>

<script src="${pageContext.request.contextPath}/assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
<script>
  // Sidebar toggle function
  function toggleSidebar() {
    const sidebar = document.getElementById('adminSidebar');
    if (sidebar) {
      sidebar.classList.toggle('collapsed');
      // Save state to localStorage
      const isCollapsed = sidebar.classList.contains('collapsed');
      localStorage.setItem('sidebarCollapsed', isCollapsed);
    }
  }
  
  // Restore sidebar state on page load
  document.addEventListener('DOMContentLoaded', function() {
    const sidebar = document.getElementById('adminSidebar');
    if (sidebar) {
      const isCollapsed = localStorage.getItem('sidebarCollapsed') === 'true';
      if (isCollapsed) {
        sidebar.classList.add('collapsed');
      }
    }
  });

  // small helper for AJAX: include CSRF token header automatically
  (function(){
    const meta = document.querySelector('meta[name="csrf-token"]');
    if (!meta) return;
    const token = meta.getAttribute('content');

    window.fetchWithCsrf = function(url, opts){
      opts = opts || {};
      opts.headers = opts.headers || {};
      if (!opts.headers['X-CSRF-Token'] && !opts.headers['x-csrf-token']) opts.headers['X-CSRF-Token'] = token;
      return fetch(url, opts);
    };

    // On page load, append a hidden _csrf input into every POST form (if not already present)
    function injectCsrfIntoForms(){
      try {
        const forms = document.getElementsByTagName('form');
        for (let i = 0; i < forms.length; i++){
          const form = forms[i];
          const method = (form.getAttribute('method') || '').toLowerCase();
          if (method === 'post'){
            // skip if already has _csrf field
            if (form.querySelector('input[name="_csrf"]')) continue;
            const input = document.createElement('input');
            input.type = 'hidden';
            input.name = '_csrf';
            input.value = token;
            form.appendChild(input);
          }
        }
      } catch(e){
        console.error('CSRF injection failed', e);
      }
    }

    if (document.readyState === 'loading'){
      document.addEventListener('DOMContentLoaded', injectCsrfIntoForms);
    } else {
      injectCsrfIntoForms();
    }
  })();
</script>
</body>
</html>
