<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Quản lý Khóa cá nhân - LUXCAR</title>

    <%@ include file="/common/header.jsp" %>

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Space+Mono:wght@400;700&family=DM+Sans:wght@300;400;500;600;700&display=swap" rel="stylesheet">

    <style>
        /* ── Reset & Base ─────────────────────────────────────────── */
        *, *::before, *::after { margin: 0; padding: 0; box-sizing: border-box; }

        :root {
            --black:   #000000;
            --white:   #ffffff;
            --gray-50: #f9f9f9;
            --gray-100:#f2f2f2;
            --gray-200:#e5e5e5;
            --gray-400:#999999;
            --gray-600:#555555;
            --gray-800:#222222;
            --green:   #0d6e3f;
            --green-bg:#e8f7ef;
            --red:     #c0392b;
            --red-bg:  #fdf0ee;
            --amber:   #b07800;
            --amber-bg:#fff8e6;
            --blue:    #1a56db;
            --blue-bg: #eff6ff;
            --mono:    'Space Mono', monospace;
            --sans:    'DM Sans', sans-serif;
            --radius:  10px;
            --shadow:  0 4px 24px rgba(0,0,0,0.07);
        }

        body { font-family: var(--sans); background: var(--gray-50); color: var(--black); }

        /* ── Layout ───────────────────────────────────────────────── */
        .profile-wrapper { display: flex; align-items: flex-start; min-height: 100vh; }

        /* ── Sidebar ──────────────────────────────────────────────── */
        .sidebar-menu { width: 280px; background: var(--black); color: var(--white); padding: 30px 0; position: sticky; top: 0; height: 100vh; overflow-y: auto; z-index: 1000; }
        .sidebar-header { padding: 0 20px 20px; border-bottom: 1px solid #333; text-align: center; }
        .sidebar-header h3 { font-size: 24px; font-weight: 600; margin: 0; }
        .sidebar-header p  { color: #999; font-size: 14px; margin-top: 5px; }
        .menu-items { padding: 20px 0; }
        .menu-item  { display: flex; align-items: center; padding: 12px 25px; color: var(--white); text-decoration: none; transition: all 0.3s; margin: 5px 10px; border-radius: 8px; }
        .menu-item i { width: 25px; margin-right: 12px; font-size: 18px; }
        .menu-item span { font-size: 15px; font-weight: 500; }
        .menu-item:hover  { background: #333; }
        .menu-item.active { background: var(--white); color: var(--black); }
        .menu-item.active i { color: var(--black); }
        .menu-divider { height: 1px; background: #333; margin: 15px 20px; }

        /* ── Main content ─────────────────────────────────────────── */
        .main-content { flex: 1; padding: 36px 40px; max-width: calc(100vw - 280px); }

        .page-header { margin-bottom: 32px; }
        .page-header h1 { font-size: 28px; font-weight: 700; letter-spacing: -.02em; display: flex; align-items: center; gap: 12px; }
        .page-header h1 i { font-size: 24px; color: var(--amber); }
        .breadcrumb { list-style: none; display: flex; margin-top: 8px; }
        .breadcrumb-item a   { color: var(--gray-400); text-decoration: none; font-size: 13px; }
        .breadcrumb-item.active { color: var(--black); font-size: 13px; font-weight: 500; }

        /* ── Status banner ────────────────────────────────────────── */
        .key-status-banner {
            display: flex; align-items: center; gap: 20px;
            background: var(--white); border-radius: var(--radius);
            border: 1px solid var(--gray-200); padding: 22px 28px;
            box-shadow: var(--shadow); margin-bottom: 28px;
        }
        .ksb-icon { width: 52px; height: 52px; border-radius: 12px; display: flex; align-items: center; justify-content: center; font-size: 22px; flex-shrink: 0; }
        .ksb-icon.has-key  { background: var(--green-bg); color: var(--green); }
        .ksb-icon.no-key   { background: var(--amber-bg); color: var(--amber); }
        .ksb-icon.lost-key { background: var(--red-bg);   color: var(--red); }
        .ksb-text h3 { font-size: 16px; font-weight: 700; margin-bottom: 4px; }
        .ksb-text p  { font-size: 13px; color: var(--gray-600); margin: 0; }
        .ksb-meta    { margin-left: auto; text-align: right; }
        .ksb-meta .label { font-size: 11px; color: var(--gray-400); text-transform: uppercase; letter-spacing: .06em; font-family: var(--mono); }
        .ksb-meta .value { font-size: 13px; font-weight: 600; color: var(--black); font-family: var(--mono); }

        /* ── Grid layout ──────────────────────────────────────────── */
        .km-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 24px; margin-bottom: 28px; }
        @media (max-width: 1100px) { .km-grid { grid-template-columns: 1fr; } }

        /* ── Cards ────────────────────────────────────────────────── */
        .km-card {
            background: var(--white); border-radius: var(--radius);
            border: 1px solid var(--gray-200); box-shadow: var(--shadow);
            overflow: hidden;
        }
        .km-card-header {
            padding: 18px 24px; border-bottom: 1px solid var(--gray-100);
            display: flex; align-items: center; gap: 12px;
        }
        .km-card-header .ch-icon { width: 36px; height: 36px; border-radius: 8px; display: flex; align-items: center; justify-content: center; font-size: 16px; flex-shrink: 0; }
        .km-card-header h4 { font-size: 15px; font-weight: 700; margin: 0; }
        .km-card-header p  { font-size: 12px; color: var(--gray-400); margin: 2px 0 0; }
        .km-card-body { padding: 24px; }

        /* ── Key preview box ──────────────────────────────────────── */
        .key-preview {
            background: var(--gray-50); border: 1px solid var(--gray-200);
            border-radius: 8px; padding: 14px 16px; margin-bottom: 16px;
            position: relative; overflow: hidden;
        }
        .key-preview::before {
            content: ''; position: absolute; left: 0; top: 0; bottom: 0;
            width: 3px; background: var(--black);
        }
        .key-preview .kp-label { font-size: 10px; font-weight: 700; text-transform: uppercase; letter-spacing: .08em; color: var(--gray-400); font-family: var(--mono); margin-bottom: 6px; }
        .key-preview .kp-val   { font-family: var(--mono); font-size: 11px; color: var(--gray-800); line-height: 1.7; word-break: break-all; max-height: 80px; overflow: hidden; position: relative; }
        .key-preview .kp-val::after { content: ''; position: absolute; bottom: 0; left: 0; right: 0; height: 24px; background: linear-gradient(transparent, var(--gray-50)); }
        .kp-copy { float: right; background: none; border: 1px solid var(--gray-200); border-radius: 6px; padding: 4px 10px; font-size: 11px; cursor: pointer; color: var(--gray-600); transition: .2s; font-family: var(--sans); }
        .kp-copy:hover { background: var(--black); color: var(--white); border-color: var(--black); }

        /* ── Algorithm selector ───────────────────────────────────── */
        .algo-tabs { display: flex; gap: 6px; margin-bottom: 18px; }
        .algo-tab { flex: 1; padding: 8px 4px; text-align: center; border: 1px solid var(--gray-200); border-radius: 8px; cursor: pointer; font-size: 13px; font-weight: 600; transition: .2s; background: var(--white); font-family: var(--mono); }
        .algo-tab:hover   { border-color: var(--black); }
        .algo-tab.active  { background: var(--black); color: var(--white); border-color: var(--black); }

        /* ── Key size selector ────────────────────────────────────── */
        .keysize-row { display: flex; gap: 8px; margin-bottom: 16px; }
        .keysize-opt { flex: 1; border: 1px solid var(--gray-200); border-radius: 8px; padding: 8px 4px; text-align: center; cursor: pointer; font-size: 12px; font-weight: 600; font-family: var(--mono); transition: .2s; background: var(--white); }
        .keysize-opt:hover  { border-color: var(--black); }
        .keysize-opt.active { background: var(--black); color: var(--white); border-color: var(--black); }

        /* ── Progress ─────────────────────────────────────────────── */
        .gen-progress { height: 3px; border-radius: 2px; background: var(--gray-100); overflow: hidden; margin-bottom: 10px; display: none; }
        .gen-progress-fill { height: 100%; background: var(--black); width: 0; transition: width .3s ease; }
        .gen-status { font-size: 12px; color: var(--gray-400); font-family: var(--mono); text-align: center; min-height: 18px; margin-bottom: 14px; }

        /* ── Buttons ──────────────────────────────────────────────── */
        .btn { display: inline-flex; align-items: center; justify-content: center; gap: 8px; padding: 10px 18px; border-radius: 8px; font-size: 13px; font-weight: 600; cursor: pointer; transition: .2s; border: 1px solid transparent; font-family: var(--sans); text-decoration: none; }
        .btn-black   { background: var(--black); color: var(--white); }
        .btn-black:hover { background: #333; }
        .btn-outline { background: var(--white); color: var(--black); border-color: var(--gray-200); }
        .btn-outline:hover { border-color: var(--black); background: var(--gray-50); }
        .btn-green   { background: var(--green);  color: var(--white); }
        .btn-green:hover { background: #0a5a33; }
        .btn-red     { background: var(--red);    color: var(--white); }
        .btn-red:hover   { background: #a93226; }
        .btn-amber   { background: var(--amber);  color: var(--white); }
        .btn-amber:hover { background: #8a5e00; }
        .btn:disabled { opacity: .4; cursor: not-allowed; }
        .btn-row { display: flex; gap: 10px; flex-wrap: wrap; }
        .btn-full { width: 100%; }

        /* ── Form elements ────────────────────────────────────────── */
        .form-group { margin-bottom: 16px; }
        .form-label { display: block; font-size: 13px; font-weight: 600; color: var(--gray-800); margin-bottom: 7px; }
        .form-control { width: 100%; padding: 10px 14px; border: 1px solid var(--gray-200); border-radius: 8px; font-size: 13px; font-family: var(--sans); transition: .2s; background: var(--white); }
        .form-control:focus { outline: none; border-color: var(--black); }

        /* ── Info box ─────────────────────────────────────────────── */
        .info-box { border-radius: 8px; padding: 12px 16px; font-size: 12.5px; display: flex; gap: 10px; align-items: flex-start; margin-bottom: 16px; line-height: 1.6; }
        .info-box i { flex-shrink: 0; margin-top: 1px; font-size: 14px; }
        .info-box.blue   { background: var(--blue-bg);  color: #1e40af; }
        .info-box.blue i { color: var(--blue); }
        .info-box.amber  { background: var(--amber-bg); color: #7c5700; }
        .info-box.amber i{ color: var(--amber); }
        .info-box.red    { background: var(--red-bg);   color: #991b1b; }
        .info-box.red  i { color: var(--red); }
        .info-box.green  { background: var(--green-bg); color: #065f33; }
        .info-box.green i{ color: var(--green); }

        /* ── Timeline (key history) ───────────────────────────────── */
        .key-timeline { list-style: none; }
        .kt-item { display: flex; gap: 14px; padding-bottom: 20px; position: relative; }
        .kt-item:not(:last-child)::before { content: ''; position: absolute; left: 15px; top: 32px; bottom: 0; width: 1px; background: var(--gray-200); }
        .kt-dot { width: 30px; height: 30px; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 12px; flex-shrink: 0; margin-top: 2px; }
        .kt-dot.created  { background: var(--green-bg); color: var(--green); }
        .kt-dot.sent     { background: var(--blue-bg);  color: var(--blue); }
        .kt-dot.lost     { background: var(--red-bg);   color: var(--red); }
        .kt-dot.current  { background: var(--black);    color: var(--white); }
        .kt-body h5 { font-size: 13px; font-weight: 700; margin-bottom: 2px; }
        .kt-body p  { font-size: 12px; color: var(--gray-600); margin: 0; }
        .kt-time    { font-size: 11px; color: var(--gray-400); font-family: var(--mono); margin-top: 2px; }

        /* ── Report lost modal ────────────────────────────────────── */
        .rl-backdrop { display: none; position: fixed; inset: 0; z-index: 9999; background: rgba(0,0,0,.6); align-items: center; justify-content: center; }
        .rl-backdrop.show { display: flex; }
        .rl-modal { background: var(--white); border-radius: 16px; width: 100%; max-width: 460px; margin: 16px; box-shadow: 0 24px 60px rgba(0,0,0,.25); animation: modalIn .25s cubic-bezier(.34,1.56,.64,1); overflow: hidden; }
        @keyframes modalIn { from { opacity:0; transform: scale(.92) translateY(16px); } to { opacity:1; transform: scale(1) translateY(0); } }
        .rl-header { padding: 20px 24px 16px; border-bottom: 1px solid var(--gray-100); display: flex; align-items: center; gap: 14px; }
        .rl-header-icon { width: 42px; height: 42px; border-radius: 10px; background: var(--red-bg); display: flex; align-items: center; justify-content: center; font-size: 20px; color: var(--red); flex-shrink: 0; }
        .rl-header-text h4 { font-size: 16px; font-weight: 700; margin: 0 0 2px; }
        .rl-header-text p  { font-size: 12px; color: var(--gray-400); margin: 0; }
        .rl-close { margin-left: auto; background: none; border: none; cursor: pointer; font-size: 20px; color: var(--gray-400); line-height: 1; }
        .rl-close:hover { color: var(--black); }
        .rl-body   { padding: 22px 24px; }
        .rl-footer { padding: 16px 24px; border-top: 1px solid var(--gray-100); display: flex; gap: 10px; justify-content: flex-end; }

        /* ── Email modal ─────────────────────────────────────────── */
        .em-backdrop { display: none; position: fixed; inset: 0; z-index: 9999; background: rgba(0,0,0,.6); align-items: center; justify-content: center; }
        .em-backdrop.show { display: flex; }
        .em-modal { background: var(--white); border-radius: 16px; width: 100%; max-width: 440px; margin: 16px; box-shadow: 0 24px 60px rgba(0,0,0,.25); animation: modalIn .25s cubic-bezier(.34,1.56,.64,1); overflow: hidden; }
        .em-header { padding: 20px 24px 16px; border-bottom: 1px solid var(--gray-100); display: flex; align-items: center; gap: 14px; }
        .em-header-icon { width: 42px; height: 42px; border-radius: 10px; background: var(--blue-bg); display: flex; align-items: center; justify-content: center; font-size: 20px; color: var(--blue); flex-shrink: 0; }
        .em-header-text h4 { font-size: 16px; font-weight: 700; margin: 0 0 2px; }
        .em-header-text p  { font-size: 12px; color: var(--gray-400); margin: 0; }
        .em-close  { margin-left: auto; background: none; border: none; cursor: pointer; font-size: 20px; color: var(--gray-400); line-height: 1; }
        .em-close:hover { color: var(--black); }
        .em-body   { padding: 22px 24px; }
        .em-footer { padding: 16px 24px; border-top: 1px solid var(--gray-100); display: flex; gap: 10px; justify-content: flex-end; }

        /* ── Toast ────────────────────────────────────────────────── */
        .km-toast { position: fixed; bottom: 28px; right: 28px; z-index: 99999; background: var(--black); color: var(--white); padding: 12px 20px; border-radius: 10px; font-size: 14px; font-weight: 500; display: flex; align-items: center; gap: 10px; box-shadow: 0 8px 32px rgba(0,0,0,.3); transform: translateY(80px); opacity: 0; transition: .35s cubic-bezier(.34,1.56,.64,1); pointer-events: none; }
        .km-toast.show { transform: translateY(0); opacity: 1; }
        .km-toast.success i { color: #4ade80; }
        .km-toast.error   i { color: #f87171; }
        .km-toast.info    i { color: #60a5fa; }

        /* ── Spinner ──────────────────────────────────────────────── */
        @keyframes spin { to { transform: rotate(360deg); } }
        .fa-spin { animation: spin .8s linear infinite; }

        /* ── Fingerprint display ──────────────────────────────────── */
        .fingerprint-grid { display: grid; grid-template-columns: repeat(8, 1fr); gap: 4px; margin: 12px 0; }
        .fp-cell { height: 20px; border-radius: 3px; background: var(--gray-100); transition: background .3s; }
        .fp-cell.active { background: var(--black); }

        /* ── Public key saved indicator ──────────────────────────── */
        .db-saved-badge { display: inline-flex; align-items: center; gap: 6px; font-size: 12px; font-weight: 600; padding: 4px 12px; border-radius: 20px; }
        .db-saved-badge.saved    { background: var(--green-bg); color: var(--green); }
        .db-saved-badge.not-saved{ background: var(--amber-bg); color: var(--amber); }
    </style>
</head>
<body>
<div class="profile-wrapper">

    <!-- ══════════════════════════════════════════════════════════════
         SIDEBAR
    ═══════════════════════════════════════════════════════════════ -->
    <div class="sidebar-menu">
        <div class="menu-items">
            <a href="${pageContext.request.contextPath}/dashboard"     class="menu-item"><i class="fas fa-chart-pie"></i><span>Bảng điều khiển</span></a>
            <a href="${pageContext.request.contextPath}/profile"       class="menu-item"><i class="fas fa-user-circle"></i><span>Thông tin cá nhân</span></a>
            <a href="${pageContext.request.contextPath}/profileEdit"   class="menu-item"><i class="fas fa-user-edit"></i><span>Chỉnh sửa thông tin</span></a>
            <a href="${pageContext.request.contextPath}/changePassword" class="menu-item"><i class="fas fa-lock"></i><span>Đổi mật khẩu</span></a>
            <a href="${pageContext.request.contextPath}/order"         class="menu-item"><i class="fas fa-shopping-bag"></i><span>Đơn hàng của tôi</span></a>
            <a href="${pageContext.request.contextPath}/cart"          class="menu-item"><i class="fas fa-shopping-cart"></i><span>Giỏ hàng</span></a>
            <a href="${pageContext.request.contextPath}/favorites"     class="menu-item"><i class="fas fa-heart"></i><span>Sản phẩm yêu thích</span></a>
            <a href="${pageContext.request.contextPath}/key-management" class="menu-item active"><i class="fas fa-key"></i><span>Quản lý Khóa cá nhân</span></a>
            <div class="menu-divider"></div>
            <a href="${pageContext.request.contextPath}/logout"        class="menu-item"><i class="fas fa-sign-out-alt"></i><span>Đăng xuất</span></a>
        </div>
    </div>

    <!-- ══════════════════════════════════════════════════════════════
         MAIN
    ═══════════════════════════════════════════════════════════════ -->
    <div class="main-content">

        <!-- Header -->
        <div class="page-header">
            <h1><i class="fas fa-key"></i> Quản lý Khóa cá nhân</h1>
            <nav><ol class="breadcrumb">
                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/home">Trang chủ</a> <i class="fas fa-chevron-right" style="font-size:9px;margin:0 6px;color:#ccc;"></i></li>
                <li class="breadcrumb-item active">Quản lý Khóa cá nhân</li>
            </ol></nav>
        </div>

        <!-- Status Banner -->
        <div class="key-status-banner" id="keyStatusBanner">
            <c:choose>
                <c:when test="${not empty userPublicKey and userPublicKey.status == 'ACTIVE'}">
                    <div class="ksb-icon has-key"><i class="fas fa-shield-check"></i></div>
                    <div class="ksb-text">
                        <h3>Khóa đang hoạt động</h3>
                        <p>Public Key của bạn đã được lưu trên hệ thống. Bạn có thể dùng chữ ký điện tử khi thanh toán.</p>
                    </div>
                    <div class="ksb-meta">
                        <div class="label">Thuật toán</div>
                        <div class="value">${userPublicKey.algorithm}</div>
                        <div class="label" style="margin-top:8px;">Tạo lúc</div>
                        <div class="value"><fmt:formatDate value="${userPublicKey.createdAt}" pattern="dd/MM/yyyy"/></div>
                    </div>
                </c:when>
                <c:when test="${not empty userPublicKey and userPublicKey.status == 'REVOKED'}">
                    <div class="ksb-icon lost-key"><i class="fas fa-ban"></i></div>
                    <div class="ksb-text">
                        <h3>Khóa đã bị thu hồi</h3>
                        <p>Khóa cũ đã bị vô hiệu hóa do báo mất. Hãy tạo cặp khóa mới để tiếp tục sử dụng.</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="ksb-icon no-key"><i class="fas fa-exclamation-triangle"></i></div>
                    <div class="ksb-text">
                        <h3>Chưa có khóa</h3>
                        <p>Bạn chưa đăng ký Public Key. Tạo cặp khóa mới để sử dụng chức năng chữ ký điện tử.</p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- Grid: Tạo khóa + Quản lý -->
        <div class="km-grid">

            <!-- ── CARD: Tạo cặp khóa mới ── -->
            <div class="km-card">
                <div class="km-card-header">
                    <div class="ch-icon" style="background:#f0f0f0;"><i class="fas fa-plus-square"></i></div>
                    <div>
                        <h4>Tạo cặp khóa mới</h4>
                        <p>Sinh RSA / DSA key pair ngay trên trình duyệt</p>
                    </div>
                </div>
                <div class="km-card-body">

                    <!-- Thuật toán -->
                    <div class="form-group">
                        <div class="form-label">Thuật toán chữ ký</div>
                        <div class="algo-tabs">
                            <div class="algo-tab active" data-algo="RSA-PSS">RSA-PSS</div>
                            <div class="algo-tab" data-algo="RSASSA-PKCS1-v1_5">PKCS#1</div>
                            <div class="algo-tab" data-algo="ECDSA">ECDSA</div>
                        </div>
                    </div>

                    <!-- Độ dài khóa (ẩn khi ECDSA) -->
                    <div class="form-group" id="keySizeGroup">
                        <div class="form-label">Độ dài khóa (bits)</div>
                        <div class="keysize-row">
                            <div class="keysize-opt" data-size="1024">1024</div>
                            <div class="keysize-opt active" data-size="2048">2048</div>
                            <div class="keysize-opt" data-size="4096">4096</div>
                        </div>
                    </div>

                    <!-- Tiến trình -->
                    <div class="gen-progress" id="genProgress"><div class="gen-progress-fill" id="genFill"></div></div>
                    <div class="gen-status" id="genStatus"></div>

                    <!-- Preview khóa -->
                    <div id="keyPreviewSection" style="display:none;">
                        <div class="fingerprint-grid" id="fingerprintGrid">
                            <c:forEach begin="1" end="32" var="i"><div class="fp-cell"></div></c:forEach>
                        </div>

                        <div class="key-preview" id="pubKeyPreview">
                            <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:6px;">
                                <div class="kp-label">Public Key (PEM)</div>
                                <button class="kp-copy" onclick="copyKey('pubKey')"><i class="fas fa-copy"></i> Copy</button>
                            </div>
                            <div class="kp-val" id="pubKeyVal"></div>
                        </div>

                        <div class="key-preview" id="privKeyPreview" style="border-color:#f0c060;">
                            <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:6px;">
                                <div class="kp-label" style="color:#b07800;">⚠ Private Key (PEM) — Chỉ hiển thị 1 lần</div>
                                <button class="kp-copy" onclick="copyKey('privKey')"><i class="fas fa-copy"></i> Copy</button>
                            </div>
                            <div class="kp-val" id="privKeyVal"></div>
                        </div>

                        <div class="info-box amber">
                            <i class="fas fa-exclamation-triangle"></i>
                            <span>Private Key <strong>không được lưu trên server</strong>. Tải xuống và bảo quản cẩn thận — nếu mất, bạn sẽ cần tạo lại và báo hủy khóa cũ.</span>
                        </div>

                        <div class="btn-row">
                            <button class="btn btn-black btn-full" onclick="downloadPrivKey()"><i class="fas fa-download"></i> Tải Private Key (.pem)</button>
                            <button class="btn btn-outline" style="flex:1;" onclick="downloadPubKey()"><i class="fas fa-download"></i> Public Key</button>
                            <button class="btn btn-green" style="flex:1;" onclick="savePublicKey()" id="btnSavePubKey"><i class="fas fa-database"></i> Lưu lên Server</button>
                        </div>

                        <div style="margin-top:12px;display:flex;align-items:center;gap:10px;">
                            <span class="db-saved-badge not-saved" id="dbSavedBadge"><i class="fas fa-times-circle"></i> Chưa lưu DB</span>
                            <span style="font-size:12px;color:var(--gray-400);" id="dbSavedNote">Public Key chưa được gửi lên máy chủ.</span>
                        </div>
                    </div>

                    <button class="btn btn-black btn-full" id="btnGenKey" onclick="generateKeyPair()">
                        <i class="fas fa-plus-circle" id="genBtnIcon"></i>
                        <span id="genBtnText">Tạo cặp khóa ngay</span>
                    </button>
                </div>
            </div>

            <!-- ── CARD: Hành động với khóa hiện tại ── -->
            <div class="km-card">
                <div class="km-card-header">
                    <div class="ch-icon" style="background:var(--amber-bg);color:var(--amber);"><i class="fas fa-cog"></i></div>
                    <div>
                        <h4>Quản lý khóa hiện tại</h4>
                        <p>Gửi email, xem thông tin, báo mất khóa</p>
                    </div>
                </div>
                <div class="km-card-body">

                    <!-- Thông tin Public Key trên server -->
                    <c:choose>
                        <c:when test="${not empty userPublicKey and userPublicKey.status == 'ACTIVE'}">
                            <div class="info-box green" style="margin-bottom:20px;">
                                <i class="fas fa-check-circle"></i>
                                <span>Public Key <strong>${userPublicKey.algorithm}</strong> đang hoạt động. Fingerprint: <code style="font-family:var(--mono);font-size:11px;">${userPublicKey.fingerprint}</code></span>
                            </div>

                            <div class="key-preview" style="margin-bottom:20px;">
                                <div class="kp-label">Public Key đang lưu (rút gọn)</div>
                                <div class="kp-val">${userPublicKey.publicKeyB64Truncated}...</div>
                            </div>

                            <div class="btn-row" style="margin-bottom:16px;">
                                <button class="btn btn-outline" style="flex:1;" onclick="openEmailModal()">
                                    <i class="fas fa-envelope"></i> Gửi Email
                                </button>
                                <button class="btn btn-outline" style="flex:1;" onclick="viewFullKey()">
                                    <i class="fas fa-eye"></i> Xem đầy đủ
                                </button>
                            </div>

                            <div style="height:1px;background:var(--gray-100);margin:20px 0;"></div>

                            <div class="info-box red">
                                <i class="fas fa-exclamation-circle"></i>
                                <span>Nếu Private Key của bạn bị lộ hoặc mất, hãy <strong>báo mất ngay</strong> để hệ thống thu hồi khóa cũ và bảo vệ tài khoản.</span>
                            </div>

                            <button class="btn btn-red btn-full" onclick="openLostModal()">
                                <i class="fas fa-shield-exclamation"></i> Báo mất / Thu hồi khóa
                            </button>
                        </c:when>
                        <c:otherwise>
                            <div class="info-box amber">
                                <i class="fas fa-info-circle"></i>
                                <span>Bạn chưa có Public Key trên hệ thống. Hãy tạo cặp khóa mới và nhấn <strong>"Lưu lên Server"</strong> để kích hoạt chữ ký điện tử.</span>
                            </div>
                            <div style="text-align:center;padding:30px 0;">
                                <i class="fas fa-key" style="font-size:52px;color:var(--gray-200);display:block;margin-bottom:14px;"></i>
                                <p style="color:var(--gray-400);font-size:14px;">Chưa có khóa nào được đăng ký</p>
                            </div>
                        </c:otherwise>
                    </c:choose>

                </div>
            </div>
        </div>

        <!-- ── CARD: Lịch sử khóa ─── -->
        <div class="km-card">
            <div class="km-card-header">
                <div class="ch-icon" style="background:var(--blue-bg);color:var(--blue);"><i class="fas fa-history"></i></div>
                <div>
                    <h4>Lịch sử khóa</h4>
                    <p>Toàn bộ sự kiện tạo, gửi, thu hồi khóa của tài khoản</p>
                </div>
            </div>
            <div class="km-card-body">
                <ul class="key-timeline" id="keyTimeline">
                    <c:choose>
                        <c:when test="${not empty keyHistory}">
                            <c:forEach var="event" items="${keyHistory}">
                                <li class="kt-item">
                                    <div class="kt-dot ${event.type == 'CREATED' ? 'created' : event.type == 'SENT' ? 'sent' : event.type == 'REVOKED' ? 'lost' : 'current'}">
                                        <i class="fas ${event.type == 'CREATED' ? 'fa-plus' : event.type == 'SENT' ? 'fa-envelope' : event.type == 'REVOKED' ? 'fa-ban' : 'fa-circle'}"></i>
                                    </div>
                                    <div class="kt-body">
                                        <h5>${event.label}</h5>
                                        <p>${event.description}</p>
                                        <div class="kt-time"><fmt:formatDate value="${event.createdAt}" pattern="HH:mm:ss — dd/MM/yyyy"/></div>
                                    </div>
                                </li>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <li style="text-align:center;padding:30px 0;color:var(--gray-400);font-size:14px;">
                                <i class="fas fa-clock" style="font-size:32px;display:block;margin-bottom:10px;color:var(--gray-200);"></i>
                                Chưa có hoạt động nào được ghi nhận.
                            </li>
                        </c:otherwise>
                    </c:choose>
                </ul>
                <!-- Fallback JS timeline (demo khi chưa có DB) -->
                <ul class="key-timeline" id="jsTimeline" style="display:none;"></ul>
            </div>
        </div>

    </div><!-- /main-content -->
</div><!-- /profile-wrapper -->

<!-- ══════════════════════════════════════════════════════════════════
     MODAL: BÁO MẤT KHÓA
═══════════════════════════════════════════════════════════════════ -->
<div class="rl-backdrop" id="lostBackdrop">
    <div class="rl-modal">
        <div class="rl-header">
            <div class="rl-header-icon"><i class="fas fa-shield-exclamation"></i></div>
            <div class="rl-header-text">
                <h4>Báo mất / Thu hồi khóa</h4>
                <p>Hành động này không thể hoàn tác</p>
            </div>
            <button class="rl-close" onclick="closeLostModal()">&times;</button>
        </div>
        <div class="rl-body">
            <div class="info-box red" style="margin-bottom:18px;">
                <i class="fas fa-exclamation-triangle"></i>
                <span>Sau khi xác nhận, Public Key hiện tại sẽ bị <strong>vô hiệu hóa ngay lập tức</strong>. Các đơn hàng đang dùng chữ ký cũ vẫn hợp lệ, nhưng bạn sẽ không thể ký mới cho đến khi tạo khóa mới.</span>
            </div>
            <div class="form-group">
                <label class="form-label">Lý do báo mất <span style="color:var(--red);">*</span></label>
                <select class="form-control" id="lostReason">
                    <option value="" disabled selected>Chọn lý do...</option>
                    <option value="LOST_FILE">Mất file Private Key</option>
                    <option value="LEAKED">Private Key bị lộ / chia sẻ nhầm</option>
                    <option value="DEVICE_STOLEN">Thiết bị bị đánh cắp</option>
                    <option value="UPGRADE">Nâng cấp lên thuật toán mạnh hơn</option>
                    <option value="OTHER">Lý do khác</option>
                </select>
            </div>
            <div class="form-group" id="lostNoteGroup" style="display:none;">
                <label class="form-label">Ghi chú thêm</label>
                <textarea class="form-control" id="lostNote" rows="3" placeholder="Mô tả thêm tình huống..."></textarea>
            </div>
            <div class="form-group">
                <label class="form-label">Xác nhận bằng cách nhập: <code style="font-family:var(--mono);font-size:12px;background:var(--gray-100);padding:2px 6px;border-radius:4px;">THU HOI KHOA</code></label>
                <input type="text" class="form-control" id="lostConfirmInput" placeholder="Nhập đúng cụm từ trên..." autocomplete="off">
            </div>
        </div>
        <div class="rl-footer">
            <button class="btn btn-outline" onclick="closeLostModal()">Hủy bỏ</button>
            <button class="btn btn-red" id="btnConfirmLost" disabled onclick="confirmRevokeKey()">
                <i class="fas fa-ban"></i> Xác nhận Thu hồi
            </button>
        </div>
    </div>
</div>

<!-- ══════════════════════════════════════════════════════════════════
     MODAL: GỬI EMAIL
═══════════════════════════════════════════════════════════════════ -->
<div class="em-backdrop" id="emailBackdrop">
    <div class="em-modal">
        <div class="em-header">
            <div class="em-header-icon"><i class="fas fa-envelope"></i></div>
            <div class="em-header-text">
                <h4>Gửi Public Key qua Email</h4>
                <p>Sao lưu khóa vào hộp thư hoặc gửi đến đối tác</p>
            </div>
            <button class="em-close" onclick="closeEmailModal()">&times;</button>
        </div>
        <div class="em-body">
            <div class="info-box blue" style="margin-bottom:18px;">
                <i class="fas fa-info-circle"></i>
                <span>Chỉ <strong>Public Key</strong> được đính kèm. Private Key không bao giờ gửi qua email.</span>
            </div>
            <div class="form-group">
                <label class="form-label">Địa chỉ email nhận</label>
                <input type="email" class="form-control" id="emailRecipient"
                       value="${sessionScope.user.email}" placeholder="example@email.com">
            </div>
            <div class="form-group">
                <label class="form-label">Ghi chú (tùy chọn)</label>
                <textarea class="form-control" id="emailNote" rows="2" placeholder="Thêm nội dung kèm theo..."></textarea>
            </div>
        </div>
        <div class="em-footer">
            <button class="btn btn-outline" onclick="closeEmailModal()">Hủy</button>
            <button class="btn btn-black" id="btnSendEmail" onclick="sendKeyEmail()">
                <i class="fas fa-paper-plane"></i> Gửi ngay
            </button>
        </div>
    </div>
</div>

<!-- Toast -->
<div class="km-toast" id="kmToast">
    <i class="fas fa-check-circle" id="toastIcon"></i>
    <span id="toastMsg"></span>
</div>

<script>
    /* ═══════════════════════════════════════════════════════════════════
       STATE
    ═══════════════════════════════════════════════════════════════════ */
    let generatedKeyPair   = null; // { publicKeyPem, privateKeyPem, publicKeyB64 }
    let selectedAlgo       = 'RSA-PSS';
    let selectedKeySize    = 2048;
    let publicKeySavedToDB = false;
    const jsTimeline       = [];

    /* ═══════════════════════════════════════════════════════════════════
       ALGO / SIZE TABS
    ═══════════════════════════════════════════════════════════════════ */
    document.querySelectorAll('.algo-tab').forEach(function(tab) {
        tab.addEventListener('click', function() {
            document.querySelectorAll('.algo-tab').forEach(function(t) { t.classList.remove('active'); });
            this.classList.add('active');
            selectedAlgo = this.dataset.algo;
            document.getElementById('keySizeGroup').style.display =
                selectedAlgo === 'ECDSA' ? 'none' : 'block';
            generatedKeyPair = null;
            document.getElementById('keyPreviewSection').style.display = 'none';
            document.getElementById('btnGenKey').style.display = 'flex';
        });
    });

    document.querySelectorAll('.keysize-opt').forEach(function(opt) {
        opt.addEventListener('click', function() {
            document.querySelectorAll('.keysize-opt').forEach(function(o) { o.classList.remove('active'); });
            this.classList.add('active');
            selectedKeySize = parseInt(this.dataset.size);
        });
    });

    /* ═══════════════════════════════════════════════════════════════════
       GENERATE KEY PAIR — dùng Web Crypto API
    ═══════════════════════════════════════════════════════════════════ */
    async function generateKeyPair() {
        const btn = document.getElementById('btnGenKey');
        btn.disabled = true;
        document.getElementById('genBtnIcon').className = 'fas fa-spinner fa-spin';
        document.getElementById('genBtnText').textContent = 'Đang tạo khóa...';

        const prog = document.getElementById('genProgress');
        const fill = document.getElementById('genFill');
        const status = document.getElementById('genStatus');
        prog.style.display = 'block';
        publicKeySavedToDB = false;

        function setProgress(pct, msg) {
            fill.style.width = pct + '%';
            status.textContent = msg;
        }

        try {
            setProgress(10, 'Khởi tạo bộ sinh số ngẫu nhiên (CSPRNG)...');
            await sleep(200);
            setProgress(30, 'Sinh cặp khóa ' + selectedAlgo + (selectedAlgo !== 'ECDSA' ? '-' + selectedKeySize : '-P-256') + '...');

            let keyPair;
            if (selectedAlgo === 'ECDSA') {
                keyPair = await crypto.subtle.generateKey(
                    { name: 'ECDSA', namedCurve: 'P-256' },
                    true, ['sign', 'verify']
                );
            } else {
                const algoName = selectedAlgo === 'RSA-PSS' ? 'RSA-PSS' : 'RSASSA-PKCS1-v1_5';
                keyPair = await crypto.subtle.generateKey(
                    { name: algoName, modulusLength: selectedKeySize, publicExponent: new Uint8Array([1, 0, 1]), hash: 'SHA-256' },
                    true, ['sign', 'verify']
                );
            }

            setProgress(60, 'Export khóa sang định dạng PEM...');
            await sleep(150);

            const pubDer  = await crypto.subtle.exportKey('spki',  keyPair.publicKey);
            const privDer = await crypto.subtle.exportKey('pkcs8', keyPair.privateKey);

            setProgress(80, 'Mã hóa Base64 & định dạng PEM...');
            await sleep(100);

            const pubPem  = derToPem(pubDer,  'PUBLIC KEY');
            const privPem = derToPem(privDer, 'PRIVATE KEY');
            const pubB64  = arrayBufferToBase64(pubDer);

            setProgress(95, 'Tính toán fingerprint...');
            await sleep(80);

            generatedKeyPair = { publicKeyPem: pubPem, privateKeyPem: privPem, publicKeyB64: pubB64 };

            // Hiển thị fingerprint
            await renderFingerprint(pubDer);

            // Hiển thị preview
            document.getElementById('pubKeyVal').textContent  = pubPem;
            document.getElementById('privKeyVal').textContent = privPem;
            document.getElementById('keyPreviewSection').style.display = 'block';
            document.getElementById('btnGenKey').style.display = 'none';

            // DB badge reset
            document.getElementById('dbSavedBadge').className = 'db-saved-badge not-saved';
            document.getElementById('dbSavedBadge').innerHTML = '<i class="fas fa-times-circle"></i> Chưa lưu DB';
            document.getElementById('dbSavedNote').textContent = 'Public Key chưa được gửi lên máy chủ.';

            setProgress(100, 'Hoàn tất ✓');
            addTimelineEvent('created', 'Tạo cặp khóa ' + selectedAlgo, 'Khóa mới được tạo trong trình duyệt, chưa lưu lên server.');
            showToast('success', 'Tạo cặp khóa thành công!');

        } catch (err) {
            console.error(err);
            status.textContent = 'Lỗi: ' + err.message;
            showToast('error', 'Lỗi khi tạo khóa: ' + err.message);
        } finally {
            btn.disabled = false;
            document.getElementById('genBtnIcon').className = 'fas fa-plus-circle';
            document.getElementById('genBtnText').textContent = 'Tạo lại cặp khóa';
        }
    }

    /* ═══════════════════════════════════════════════════════════════════
       SAVE PUBLIC KEY TO SERVER
    ═══════════════════════════════════════════════════════════════════ */
    async function savePublicKey() {
        if (!generatedKeyPair) { showToast('error', 'Chưa có khóa để lưu.'); return; }

        const btn = document.getElementById('btnSavePubKey');
        btn.disabled = true;
        btn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Đang lưu...';

        try {
            const res = await fetch('${pageContext.request.contextPath}/save-public-key', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: new URLSearchParams({
                    publicKey: generatedKeyPair.publicKeyB64,
                    algorithm: selectedAlgo
                })
            });
            const text = await res.text();

            if (text === 'success') {
                publicKeySavedToDB = true;
                document.getElementById('dbSavedBadge').className = 'db-saved-badge saved';
                document.getElementById('dbSavedBadge').innerHTML = '<i class="fas fa-check-circle"></i> Đã lưu DB';
                document.getElementById('dbSavedNote').textContent = 'Public Key đã được ghi vào cơ sở dữ liệu.';
                btn.innerHTML = '<i class="fas fa-check"></i> Đã lưu';
                addTimelineEvent('created', 'Lưu Public Key lên server', 'Public Key (' + selectedAlgo + ') đã được đăng ký thành công.');
                showToast('success', 'Public Key đã lưu lên server thành công!');
            } else if (text === 'already_exists') {
                showToast('info', 'Public Key đã tồn tại — đã được cập nhật.');
                btn.innerHTML = '<i class="fas fa-check"></i> Đã cập nhật';
            } else {
                throw new Error(text);
            }
        } catch (err) {
            showToast('error', 'Lỗi lưu khóa: ' + err.message);
            btn.disabled = false;
            btn.innerHTML = '<i class="fas fa-database"></i> Lưu lên Server';
        }
    }

    /* ═══════════════════════════════════════════════════════════════════
       DOWNLOAD
    ═══════════════════════════════════════════════════════════════════ */
    function downloadPrivKey() {
        if (!generatedKeyPair) { showToast('error', 'Chưa có khóa.'); return; }
        downloadFile(generatedKeyPair.privateKeyPem, 'luxcar_private_key.pem', 'application/x-pem-file');
        addTimelineEvent('sent', 'Tải Private Key xuống máy', 'File luxcar_private_key.pem được lưu về thiết bị.');
        showToast('info', 'Đã tải Private Key — bảo quản cẩn thận!');
    }

    function downloadPubKey() {
        if (!generatedKeyPair) { showToast('error', 'Chưa có khóa.'); return; }
        downloadFile(generatedKeyPair.publicKeyPem, 'luxcar_public_key.pem', 'application/x-pem-file');
        showToast('info', 'Đã tải Public Key.');
    }

    function downloadFile(content, filename, mimeType) {
        const blob = new Blob([content], { type: mimeType });
        const url  = URL.createObjectURL(blob);
        const a    = document.createElement('a');
        a.href = url; a.download = filename; a.click();
        URL.revokeObjectURL(url);
    }

    /* ═══════════════════════════════════════════════════════════════════
       COPY KEY
    ═══════════════════════════════════════════════════════════════════ */
    function copyKey(type) {
        if (!generatedKeyPair) return;
        const text = type === 'pubKey' ? generatedKeyPair.publicKeyPem : generatedKeyPair.privateKeyPem;
        navigator.clipboard.writeText(text).then(function() {
            showToast('success', (type === 'pubKey' ? 'Public Key' : 'Private Key') + ' đã được copy!');
        });
    }

    /* ═══════════════════════════════════════════════════════════════════
       VIEW FULL KEY (mở tab mới với nội dung PEM)
    ═══════════════════════════════════════════════════════════════════ */
    function viewFullKey() {
        fetch('${pageContext.request.contextPath}/get-public-key')
            .then(function(r) { return r.text(); })
            .then(function(pem) {
                const win = window.open('', '_blank');
                win.document.write('<pre style="font-family:monospace;font-size:13px;padding:20px;">' + pem + '</pre>');
            })
            .catch(function() { showToast('error', 'Không lấy được khóa từ server.'); });
    }

    /* ═══════════════════════════════════════════════════════════════════
       MODAL: BÁO MẤT KHÓA
    ═══════════════════════════════════════════════════════════════════ */
    function openLostModal()  { document.getElementById('lostBackdrop').classList.add('show'); }
    function closeLostModal() { document.getElementById('lostBackdrop').classList.remove('show'); }

    document.getElementById('lostBackdrop').addEventListener('click', function(e) {
        if (e.target === this) closeLostModal();
    });

    document.getElementById('lostReason').addEventListener('change', function() {
        document.getElementById('lostNoteGroup').style.display =
            this.value === 'OTHER' ? 'block' : 'none';
    });

    document.getElementById('lostConfirmInput').addEventListener('input', function() {
        document.getElementById('btnConfirmLost').disabled = (this.value.trim() !== 'THU HOI KHOA');
    });

    async function confirmRevokeKey() {
        const reason = document.getElementById('lostReason').value;
        const note   = document.getElementById('lostNote').value;

        if (!reason) { showToast('error', 'Vui lòng chọn lý do.'); return; }

        const btn = document.getElementById('btnConfirmLost');
        btn.disabled = true;
        btn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Đang xử lý...';

        try {
            const res  = await fetch('${pageContext.request.contextPath}/revoke-key', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: new URLSearchParams({ reason: reason, note: note })
            });
            const text = await res.text();

            if (text === 'success') {
                closeLostModal();
                addTimelineEvent('lost', 'Thu hồi khóa — ' + reasonLabel(reason), note || 'Khóa cũ đã bị vô hiệu hóa.');
                showToast('success', 'Khóa đã bị thu hồi. Hãy tạo cặp khóa mới.');
                // Cập nhật banner
                updateStatusBanner('revoked');
            } else {
                throw new Error(text);
            }
        } catch (err) {
            showToast('error', 'Lỗi thu hồi khóa: ' + err.message);
            btn.disabled = false;
            btn.innerHTML = '<i class="fas fa-ban"></i> Xác nhận Thu hồi';
        }
    }

    function reasonLabel(v) {
        const map = { LOST_FILE:'Mất file', LEAKED:'Bị lộ', DEVICE_STOLEN:'Thiết bị bị mất', UPGRADE:'Nâng cấp', OTHER:'Khác' };
        return map[v] || v;
    }

    /* ═══════════════════════════════════════════════════════════════════
       MODAL: GỬI EMAIL
    ═══════════════════════════════════════════════════════════════════ */
    function openEmailModal()  { document.getElementById('emailBackdrop').classList.add('show'); }
    function closeEmailModal() { document.getElementById('emailBackdrop').classList.remove('show'); }

    document.getElementById('emailBackdrop').addEventListener('click', function(e) {
        if (e.target === this) closeEmailModal();
    });

    async function sendKeyEmail() {
        const email = document.getElementById('emailRecipient').value.trim();
        const note  = document.getElementById('emailNote').value.trim();

        if (!email) { showToast('error', 'Vui lòng nhập địa chỉ email.'); return; }

        const btn = document.getElementById('btnSendEmail');
        btn.disabled = true;
        btn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Đang gửi...';

        try {
            const res  = await fetch('${pageContext.request.contextPath}/send-key-email', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: new URLSearchParams({ email: email, note: note })
            });
            const text = await res.text();

            if (text === 'success') {
                closeEmailModal();
                addTimelineEvent('sent', 'Gửi Public Key qua email', 'Đã gửi đến: ' + email);
                showToast('success', 'Email đã được gửi thành công!');
            } else {
                throw new Error(text);
            }
        } catch (err) {
            showToast('error', 'Lỗi gửi email: ' + err.message);
        } finally {
            btn.disabled = false;
            btn.innerHTML = '<i class="fas fa-paper-plane"></i> Gửi ngay';
        }
    }

    /* ═══════════════════════════════════════════════════════════════════
       TIMELINE (JS fallback)
    ═══════════════════════════════════════════════════════════════════ */
    const TIMELINE_ICONS = {
        created: { cls: 'created', icon: 'fa-plus' },
        sent:    { cls: 'sent',    icon: 'fa-envelope' },
        lost:    { cls: 'lost',    icon: 'fa-ban' }
    };

    function addTimelineEvent(type, title, desc) {
        const now = new Date();
        const timeStr = now.toLocaleTimeString('vi-VN') + ' — ' + now.toLocaleDateString('vi-VN');
        jsTimeline.unshift({ type, title, desc, time: timeStr });
        renderJsTimeline();
    }

    function renderJsTimeline() {
        if (jsTimeline.length === 0) return;
        const tl = document.getElementById('jsTimeline');
        tl.style.display = 'block';
        tl.innerHTML = jsTimeline.map(function(ev) {
            const t = TIMELINE_ICONS[ev.type] || { cls: 'current', icon: 'fa-circle' };
            return '<li class="kt-item">' +
                '<div class="kt-dot ' + t.cls + '"><i class="fas ' + t.icon + '"></i></div>' +
                '<div class="kt-body"><h5>' + escHtml(ev.title) + '</h5>' +
                '<p>' + escHtml(ev.desc) + '</p>' +
                '<div class="kt-time">' + ev.time + '</div></div></li>';
        }).join('');
    }

    /* ═══════════════════════════════════════════════════════════════════
       STATUS BANNER UPDATE
    ═══════════════════════════════════════════════════════════════════ */
    function updateStatusBanner(status) {
        const banner = document.getElementById('keyStatusBanner');
        if (status === 'revoked') {
            banner.querySelector('.ksb-icon').className = 'ksb-icon lost-key';
            banner.querySelector('.ksb-icon').innerHTML = '<i class="fas fa-ban"></i>';
            banner.querySelector('.ksb-text h3').textContent = 'Khóa đã bị thu hồi';
            banner.querySelector('.ksb-text p').textContent  = 'Khóa cũ đã bị vô hiệu hóa. Hãy tạo cặp khóa mới để tiếp tục.';
            const meta = banner.querySelector('.ksb-meta');
            if (meta) meta.remove();
        }
    }

    /* ═══════════════════════════════════════════════════════════════════
       FINGERPRINT VISUALIZER
    ═══════════════════════════════════════════════════════════════════ */
    async function renderFingerprint(pubDer) {
        const hashBuf = await crypto.subtle.digest('SHA-256', pubDer);
        const bytes   = new Uint8Array(hashBuf);
        const cells   = document.querySelectorAll('.fp-cell');
        cells.forEach(function(cell, i) {
            cell.classList.toggle('active', (bytes[i % bytes.length] >> (i % 8)) & 1);
        });
    }

    /* ═══════════════════════════════════════════════════════════════════
       TOAST
    ═══════════════════════════════════════════════════════════════════ */
    let toastTimer;
    function showToast(type, msg) {
        const toast = document.getElementById('kmToast');
        const icons = { success: 'fa-check-circle', error: 'fa-times-circle', info: 'fa-info-circle' };
        document.getElementById('toastIcon').className = 'fas ' + (icons[type] || 'fa-info-circle');
        document.getElementById('toastMsg').textContent = msg;
        toast.className = 'km-toast show ' + type;
        clearTimeout(toastTimer);
        toastTimer = setTimeout(function() { toast.classList.remove('show'); }, 3500);
    }

    /* ═══════════════════════════════════════════════════════════════════
       UTILS
    ═══════════════════════════════════════════════════════════════════ */
    function derToPem(der, label) {
        const b64  = arrayBufferToBase64(der);
        const lines = b64.match(/.{1,64}/g).join('\n');
        return '-----BEGIN ' + label + '-----\n' + lines + '\n-----END ' + label + '-----';
    }

    function arrayBufferToBase64(buffer) {
        const bytes = new Uint8Array(buffer);
        let binary  = '';
        bytes.forEach(function(b) { binary += String.fromCharCode(b); });
        return window.btoa(binary);
    }

    function sleep(ms) { return new Promise(function(r) { setTimeout(r, ms); }); }

    function escHtml(s) {
        return (s || '').replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;').replace(/"/g,'&quot;');
    }
</script>
</body>
</html>