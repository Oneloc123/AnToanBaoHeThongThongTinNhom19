<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Thanh toán - LUXCAR</title>

    <%-- Include header --%>
    <%@ include file="/common/header.jsp" %>

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">

    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Inter', sans-serif; background-color: #f8f9fa; }

        /* Main layout & Sidebar */
        .profile-wrapper { display: flex; align-items: flex-start; min-height: 100vh; }
        .sidebar-menu { width: 280px; background-color: #000000; color: #ffffff; padding: 30px 0; position: sticky; top: 0; height: 100vh; overflow-y: auto; z-index: 1000; }
        .sidebar-header { padding: 0 20px 20px; border-bottom: 1px solid #333333; text-align: center; }
        .sidebar-header h3 { color: #ffffff; font-size: 24px; font-weight: 600; margin: 0; }
        .sidebar-header p { color: #999999; font-size: 14px; margin-top: 5px; }
        .menu-items { padding: 20px 0; }
        .menu-item { display: flex; align-items: center; padding: 12px 25px; color: #ffffff; text-decoration: none; transition: all 0.3s; margin: 5px 10px; border-radius: 8px; }
        .menu-item i { width: 25px; margin-right: 12px; font-size: 18px; }
        .menu-item span { font-size: 15px; font-weight: 500; }
        .menu-item:hover { background-color: #333333; color: #ffffff; }
        .menu-item.active { background-color: #ffffff; color: #000000; }
        .menu-item.active i { color: #000000; }
        .menu-divider { height: 1px; background-color: #333333; margin: 15px 20px; }

        /* Main Content */
        .main-content { flex: 1; padding: 30px; }
        .content-header { margin-bottom: 30px; }
        .content-header h1 { font-size: 28px; font-weight: 600; color: #000000; margin-bottom: 10px; }
        .breadcrumb { background: none; padding: 0; margin: 0; list-style: none; display: flex; }
        .breadcrumb-item { margin-right: 10px; }
        .breadcrumb-item a { color: #666666; text-decoration: none; }
        .breadcrumb-item.active { color: #000000; font-weight: 500; }

        /* Checkout Layout */
        .checkout-container { display: flex; gap: 30px; align-items: flex-start; }
        .checkout-form-section { flex: 2; }
        .checkout-summary-section { flex: 1; position: sticky; top: 30px; }

        /* Form & Cards */
        .checkout-card { background: #ffffff; border-radius: 12px; box-shadow: 0 5px 20px rgba(0,0,0,0.05); padding: 30px; margin-bottom: 25px; }
        .checkout-card h3 { font-size: 18px; font-weight: 600; margin-bottom: 20px; padding-bottom: 15px; border-bottom: 2px solid #000; display: flex; align-items: center; gap: 10px; }

        .form-group { margin-bottom: 20px; }
        .form-group label { display: block; font-size: 14px; font-weight: 500; margin-bottom: 8px; color: #333; }
        .form-control { width: 100%; padding: 12px 15px; border: 1px solid #ddd; border-radius: 6px; font-size: 14px; transition: border-color 0.3s; }
        .form-control:focus { outline: none; border-color: #000; }

        /* Payment Methods */
        .payment-method { border: 1px solid #ddd; border-radius: 8px; padding: 15px; margin-bottom: 15px; cursor: pointer; display: flex; align-items: center; gap: 15px; transition: 0.3s; }
        .payment-method:hover { border-color: #000; }
        .payment-method input[type="radio"] { width: 18px; height: 18px; accent-color: #000; }
        .payment-icon { font-size: 24px; color: #000; width: 40px; text-align: center; }
        .payment-details h4 { font-size: 15px; font-weight: 600; margin-bottom: 5px; color: #000; }
        .payment-details p { font-size: 13px; color: #666; margin: 0; }

        /* Order Summary */
        .summary-item { display: flex; justify-content: space-between; align-items: center; padding-bottom: 15px; margin-bottom: 15px; border-bottom: 1px dashed #eee; }
        .summary-item-info { display: flex; align-items: center; gap: 15px; }
        .summary-img { width: 60px; height: 45px; background: #f0f0f0; border-radius: 4px; display: flex; align-items: center; justify-content: center; color: #999; }
        .summary-name { font-size: 14px; font-weight: 600; color: #000; }
        .summary-qty { font-size: 12px; color: #666; }
        .summary-price { font-size: 14px; font-weight: 600; color: #000; }

        .summary-calc { margin-top: 20px; }
        .calc-row { display: flex; justify-content: space-between; margin-bottom: 15px; font-size: 14px; color: #666; }
        .calc-row.total { border-top: 2px solid #000; padding-top: 15px; font-size: 18px; font-weight: 700; color: #d9534f; margin-bottom: 25px; }

        .btn-submit-order { width: 100%; background-color: #000; color: #fff; padding: 15px; border: none; border-radius: 8px; font-size: 16px; font-weight: 600; cursor: pointer; transition: 0.3s; display: flex; align-items: center; justify-content: center; gap: 10px; }
        .btn-submit-order:hover { background-color: #333; }

        /* Responsive */
        @media (max-width: 992px) {
            .checkout-container { flex-direction: column; }
            .checkout-summary-section { position: static; width: 100%; }
        }

        /* Address slots */
        .address-slot {
            border: 1px solid #ddd; border-radius: 8px; padding: 15px; margin-bottom: 12px;
            cursor: pointer; transition: all 0.2s ease; position: relative; display: block; background: #fff;
        }
        .address-slot:hover { border-color: #000; box-shadow: 0 4px 10px rgba(0,0,0,0.04); }
        .address-slot.selected { border-color: #000; background-color: #fafafa; }
        .address-slot.selected::after {
            content: '\f058'; font-family: 'Font Awesome 6 Free'; font-weight: 900;
            position: absolute; top: 15px; right: 15px; color: #000; font-size: 1.2rem;
        }
        .address-radio-hidden { position: absolute; opacity: 0; width: 0; height: 0; }
        .address-name { font-weight: 600; color: #000; margin-bottom: 5px; font-size: 15px; }
        .address-phone { font-size: 13px; color: #555; margin-bottom: 5px; }
        .address-detail { font-size: 13px; color: #666; margin-bottom: 0; line-height: 1.4; }
        .badge-default { background: #000; color: #fff; font-size: 10px; padding: 3px 8px; border-radius: 12px; margin-left: 8px; vertical-align: middle; }
        .btn-add-address {
            border: 2px dashed #ccc; background: transparent; color: #666; width: 100%;
            padding: 12px; border-radius: 8px; font-weight: 600; transition: 0.2s; text-align: center; cursor: pointer;
        }
        .btn-add-address:hover { border-color: #000; color: #000; background: #fafafa; }

        /* =============================================
           DIGITAL SIGNATURE MODAL STYLES
           ============================================= */
        .ds-backdrop {
            display: none;
            position: fixed; inset: 0; z-index: 9999;
            background: rgba(0,0,0,0.6);
            align-items: center; justify-content: center;
            animation: dsBackdropIn .2s ease;
        }
        .ds-backdrop.show { display: flex; }
        @keyframes dsBackdropIn { from { opacity: 0; } to { opacity: 1; } }

        .ds-modal {
            background: #fff; border-radius: 16px; width: 100%; max-width: 500px;
            margin: 16px; box-shadow: 0 24px 60px rgba(0,0,0,0.22);
            animation: dsModalIn .25s cubic-bezier(.34,1.56,.64,1);
            overflow: hidden;
        }
        @keyframes dsModalIn { from { opacity:0; transform:scale(.92) translateY(16px); } to { opacity:1; transform:scale(1) translateY(0); } }

        .ds-header {
            padding: 20px 24px 16px; border-bottom: 1px solid #f0f0f0;
            display: flex; align-items: center; gap: 14px;
        }
        .ds-header-icon {
            width: 42px; height: 42px; border-radius: 10px;
            background: #fff8e6; display: flex; align-items: center; justify-content: center;
            font-size: 20px; color: #b07800; flex-shrink: 0;
        }
        .ds-header-text h4 { font-size: 16px; font-weight: 700; margin: 0 0 2px; color: #000; }
        .ds-header-text p { font-size: 12px; color: #888; margin: 0; }
        .ds-close { margin-left: auto; background: none; border: none; cursor: pointer; font-size: 18px; color: #aaa; line-height: 1; padding: 4px; }
        .ds-close:hover { color: #000; }

        .ds-body { padding: 22px 24px; }

        /* Step indicator */
        .ds-steps { display: flex; gap: 6px; margin-bottom: 22px; }
        .ds-step { flex: 1; height: 3px; border-radius: 2px; background: #e8e8e8; transition: background .35s; }
        .ds-step.active { background: #000; }
        .ds-step.done { background: #555; }

        /* Drop zone */
        .ds-drop-zone {
            border: 2px dashed #d0d0d0; border-radius: 10px; padding: 24px 16px;
            text-align: center; cursor: pointer; transition: 0.2s; margin-bottom: 16px;
            position: relative; background: #fafafa;
        }
        .ds-drop-zone:hover, .ds-drop-zone.drag { border-color: #000; background: #f5f5f5; }
        .ds-drop-zone input[type=file] { position: absolute; inset: 0; opacity: 0; cursor: pointer; width: 100%; height: 100%; }
        .ds-drop-icon { font-size: 32px; color: #bbb; margin-bottom: 8px; display: block; }
        .ds-drop-zone p { font-size: 13px; color: #888; margin: 0; line-height: 1.5; }
        .ds-drop-zone .file-selected { font-size: 13px; font-weight: 600; color: #000; margin: 0; }

        /* PIN field */
        .ds-pin-wrap { position: relative; margin-bottom: 16px; }
        .ds-pin-wrap input { width: 100%; padding: 11px 44px 11px 14px; border: 1px solid #ddd; border-radius: 8px; font-size: 14px; font-family: monospace; letter-spacing: .1em; transition: border-color .2s; }
        .ds-pin-wrap input:focus { outline: none; border-color: #000; }
        .ds-pin-toggle { position: absolute; right: 12px; top: 50%; transform: translateY(-50%); background: none; border: none; cursor: pointer; color: #aaa; font-size: 16px; }
        .ds-pin-toggle:hover { color: #000; }

        /* Info box */
        .ds-info { background: #f4f9ff; border-radius: 8px; padding: 10px 14px; display: flex; gap: 10px; align-items: flex-start; margin-bottom: 16px; }
        .ds-info i { color: #4a90d9; font-size: 14px; margin-top: 1px; flex-shrink: 0; }
        .ds-info span { font-size: 12px; color: #555; line-height: 1.5; }

        /* Progress */
        .ds-progress-bar { height: 4px; border-radius: 2px; background: #eee; overflow: hidden; margin-bottom: 14px; }
        .ds-progress-fill { height: 100%; background: #000; width: 0%; transition: width .35s ease; }

        /* Hash / Sig boxes */
        .ds-code-box { background: #f8f8f8; border-radius: 8px; padding: 12px 14px; margin-bottom: 12px; }
        .ds-code-label { font-size: 11px; color: #888; font-weight: 600; text-transform: uppercase; letter-spacing: .04em; margin-bottom: 5px; }
        .ds-code-val { font-family: monospace; font-size: 11px; color: #333; word-break: break-all; line-height: 1.6; }

        /* Status badge */
        .ds-status { text-align: center; margin-bottom: 12px; }
        .ds-badge { display: inline-flex; align-items: center; gap: 7px; font-size: 13px; font-weight: 600; padding: 6px 14px; border-radius: 20px; }
        .ds-badge.wait { background: #fff8e6; color: #b07800; }
        .ds-badge.ok   { background: #edfaf3; color: #1a7a46; }
        .ds-badge.err  { background: #fff0f0; color: #c0392b; }

        /* Success screen */
        .ds-success { text-align: center; padding: 10px 0 6px; }
        .ds-success i.big { font-size: 52px; color: #1a7a46; display: block; margin-bottom: 14px; }
        .ds-success h5 { font-size: 17px; font-weight: 700; margin: 0 0 6px; color: #000; }
        .ds-success p  { font-size: 13px; color: #666; margin: 0 0 18px; }
        .ds-confirm-table { width: 100%; font-size: 13px; border-collapse: collapse; text-align: left; }
        .ds-confirm-table td { padding: 6px 0; }
        .ds-confirm-table td:first-child { color: #888; width: 44%; }
        .ds-confirm-table td:last-child { font-weight: 600; color: #000; word-break: break-all; }

        /* Footer */
        .ds-footer { padding: 16px 24px; border-top: 1px solid #f0f0f0; display: flex; gap: 10px; justify-content: flex-end; }
        .ds-btn-cancel { background: #fff; border: 1px solid #ddd; border-radius: 8px; padding: 10px 20px; font-size: 14px; font-weight: 500; cursor: pointer; color: #333; transition: 0.2s; }
        .ds-btn-cancel:hover { border-color: #000; }
        .ds-btn-primary { background: #000; color: #fff; border: none; border-radius: 8px; padding: 10px 24px; font-size: 14px; font-weight: 600; cursor: pointer; display: flex; align-items: center; gap: 8px; transition: 0.2s; }
        .ds-btn-primary:hover { background: #333; }
        .ds-btn-primary:disabled { background: #ccc; cursor: not-allowed; }
    </style>
</head>
<body>
<div class="profile-wrapper">
    <div class="sidebar-menu">
        <div class="menu-items">
            <a href="${pageContext.request.contextPath}/dashboard" class="menu-item">
                <i class="fas fa-chart-pie"></i><span>Bảng điều khiển</span>
            </a>
            <a href="${pageContext.request.contextPath}/profile" class="menu-item">
                <i class="fas fa-user-circle"></i><span>Thông tin cá nhân</span>
            </a>
            <a href="${pageContext.request.contextPath}/profileEdit" class="menu-item">
                <i class="fas fa-user-edit"></i><span>Chỉnh sửa thông tin</span>
            </a>
            <a href="${pageContext.request.contextPath}/changePassword" class="menu-item">
                <i class="fas fa-lock"></i><span>Đổi mật khẩu</span>
            </a>
            <a href="${pageContext.request.contextPath}/order" class="menu-item">
                <i class="fas fa-shopping-bag"></i><span>Đơn hàng của tôi</span>
            </a>
            <a href="${pageContext.request.contextPath}/cart" class="menu-item active">
                <i class="fas fa-shopping-cart"></i><span>Giỏ hàng</span>
            </a>
            <a href="${pageContext.request.contextPath}/favorites" class="menu-item">
                <i class="fas fa-heart"></i><span>Sản phẩm yêu thích</span>
            </a>
            <a href="${pageContext.request.contextPath}/key-management" class="menu-item "><i class="fas fa-key"></i><span>Quản lý Khóa cá nhân</span></a>

            <div class="menu-divider"></div>
            <a href="${pageContext.request.contextPath}/logout" class="menu-item">
                <i class="fas fa-sign-out-alt"></i><span>Đăng xuất</span>
            </a>
        </div>
    </div>

    <div class="main-content">
        <div class="content-header">
            <h1>Thanh toán</h1>
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb">
                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/home">Trang chủ</a> <i class="fas fa-chevron-right" style="font-size:10px;margin:0 5px;"></i></li>
                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/cart">Giỏ hàng</a> <i class="fas fa-chevron-right" style="font-size:10px;margin:0 5px;"></i></li>
                    <li class="breadcrumb-item active">Thanh toán</li>
                </ol>
            </nav>
        </div>

        <form action="process-checkout" id="checkoutForm" method="POST">
            <input type="hidden" name="type" value="${param.type}">
            <input type="hidden" id="digitalSignature" name="digitalSignature" value="">

            <div class="checkout-container">
                <div class="checkout-form-section">

                    <%-- ===== SHIPPING ADDRESS ===== --%>
                    <div class="checkout-card">
                        <h3><i class="fas fa-map-marker-alt"></i> Thông tin giao hàng (Shipping Address)</h3>

                        <div class="form-group">
                            <label for="fullName">Họ và tên người nhận</label>
                            <input type="text" id="fullName" name="fullName" class="form-control"
                                   value="${sessionScope.user != null ? sessionScope.user.username : ''}"
                                   placeholder="Nhập họ tên..." required>
                        </div>

                        <div class="form-group">
                            <label for="phone">Số điện thoại (Phone)</label>
                            <input type="text" id="phone" name="phone" class="form-control"
                                   value="${sessionScope.user != null ? sessionScope.user.phonenumber : ''}"
                                   placeholder="Nhập số điện thoại..." required>
                        </div>

                        <div class="form-group mb-4">
                            <label class="mb-3">Địa chỉ nhận hàng <span class="text-danger">*</span></label>
                            <div id="address-slots-container">
                                <c:choose>
                                    <c:when test="${empty listAddress}">
                                        <div class="alert alert-warning py-2 mb-3" style="font-size:14px;border-radius:8px;">
                                            <i class="fas fa-exclamation-triangle"></i> Bạn chưa có địa chỉ nào, hãy thêm mới để đặt hàng!
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <c:forEach var="addr" items="${listAddress}" varStatus="status">
                                            <c:set var="radioId" value="addr_${addr.id}" />
                                            <input type="radio" class="address-radio-hidden" id="${radioId}"
                                                   name="shippingAddress"
                                                   value="${addr.street}, ${addr.commune}, ${addr.province}"
                                                ${status.first ? 'checked' : ''}>
                                            <label for="${radioId}" class="address-slot ${status.first ? 'selected' : ''}">
                                                <div class="address-name">
                                                    <i class="fas fa-user-tag text-muted me-1"></i> ${addr.name}
                                                    <c:if test="${addr.type == 'main'}"><span class="badge-default">Mặc định</span></c:if>
                                                </div>
                                                <div class="address-detail">
                                                    <i class="fas fa-map-marker-alt text-muted me-2"></i>
                                                        ${addr.street}, ${addr.commune}, ${addr.province}
                                                </div>
                                            </label>
                                        </c:forEach>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <button type="button" class="btn-add-address mt-2" data-bs-toggle="modal" data-bs-target="#addAddressModal">
                                <i class="fas fa-plus-circle me-1"></i> Thêm địa chỉ mới
                            </button>
                        </div>
                    </div>

                    <%-- ===== PAYMENT METHOD ===== --%>
                    <div class="checkout-card">
                        <h3><i class="fas fa-wallet"></i> Phương thức thanh toán & Xác thực</h3>

                        <label class="payment-method">
                            <input type="radio" name="paymentMethod" value="COD" checked>
                            <div class="payment-icon"><i class="fas fa-money-bill-wave"></i></div>
                            <div class="payment-details">
                                <h4>Thanh toán khi nhận hàng (COD)</h4>
                                <p>Thanh toán bằng tiền mặt khi giao hàng tận nơi.</p>
                            </div>
                        </label>

                        <label class="payment-method">
                            <input type="radio" name="paymentMethod" value="VNPAY">
                            <div class="payment-icon"><i class="fas fa-qrcode" style="color:#005baa;"></i></div>
                            <div class="payment-details">
                                <h4>Thanh toán qua VNPAY</h4>
                                <p>Thanh toán an toàn qua ví điện tử VNPay hoặc quét mã QR ngân hàng.</p>
                            </div>
                        </label>

                        <label class="payment-method">
                            <input type="radio" name="paymentMethod" value="DIGITAL_SIGNATURE">
                            <div class="payment-icon"><i class="fas fa-key" style="color:#ff9900;"></i></div>
                            <div class="payment-details">
                                <h4>Xác thực bằng Chữ ký điện tử (RSA/DSA)</h4>
                                <p>Sử dụng Khóa bí mật (Private Key) để băm dữ liệu đơn hàng và ký xác thực bảo mật tuyệt đối.</p>
                            </div>
                        </label>
                    </div>
                </div>

                <%-- ===== ORDER SUMMARY ===== --%>
                <div class="checkout-summary-section">
                    <div class="checkout-card">
                        <h3><i class="fas fa-receipt"></i> Tóm tắt đơn hàng</h3>

                        <div class="mb-3">
                            <label class="form-label">Chọn Voucher</label>
                            <select id="voucherSelect" name="voucherId" class="form-select">
                                <c:forEach items="${vouchers}" var="v">
                                    <option value="${v.id}">
                                            ${v.code} - Giảm ${v.value}${v.valueType == 'PERCENT' ? '%' : ' ₫'}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="summary-items-list">
                            <c:forEach var="item" items="${checkoutCart.items}">
                                <div class="summary-item">
                                    <div class="summary-item-info">
                                        <img src="${not empty item.productDetail.images ? item.productDetail.images[0] : 'https://placehold.co/50'}"
                                             style="width:50px;height:50px;object-fit:cover;"
                                             alt="${item.productDetail.productName}" />
                                        <div>
                                            <div class="summary-name">${item.productDetail.productName}</div>
                                            <div class="summary-qty">Số lượng: ${item.quantity}</div>
                                        </div>
                                    </div>
                                    <div class="summary-price">
                                        <fmt:formatNumber value="${item.totalPrice}" type="number" groupingUsed="true"/> ₫
                                    </div>
                                </div>
                            </c:forEach>
                        </div>

                        <div class="summary-calc">
                            <div class="calc-row">
                                <span>Tạm tính:</span>
                                <span><fmt:formatNumber value="${checkoutCart.total}" type="number" groupingUsed="true"/> ₫</span>
                            </div>
                            <div class="calc-row">
                                <span>Phí vận chuyển:</span>
                                <span>Miễn phí</span>
                            </div>
                            <div class="calc-row total">
                                <span>Tổng cộng:</span>
                                <span id="totalPrice"><fmt:formatNumber value="${checkoutCart.total}" type="number" groupingUsed="true"/> ₫</span>
                            </div>
                        </div>

                        <c:choose>
                            <c:when test="${empty listAddress}">
                                <button type="button" class="btn-submit-order" style="background-color:#6c757d;cursor:not-allowed;" disabled>
                                    <i class="fas fa-lock"></i> Vui lòng thêm địa chỉ để Đặt hàng
                                </button>
                            </c:when>
                            <c:otherwise>
                                <button type="submit" class="btn-submit-order">
                                    <i class="fas fa-check-circle"></i> Đặt Hàng
                                </button>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </form>
    </div>
</div>

<%-- ============================================================
     MODAL THÊM ĐỊA CHỈ
     ============================================================ --%>
<div class="modal fade" id="addAddressModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content" style="border-radius:12px;border:none;">
            <div class="modal-header" style="border-bottom:1px solid #eee;">
                <h5 class="modal-title fw-bold" style="color:#000;">
                    <i class="fas fa-map-marked-alt me-2"></i> Thêm địa chỉ giao hàng
                </h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body" style="padding:25px;">
                <form id="newAddressForm">
                    <div class="mb-3">
                        <label class="form-label fw-bold small">Tên người nhận</label>
                        <input type="text" class="form-control" id="newAddrName" name="newName" placeholder="Nhập họ tên..." required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-bold small">Tỉnh / Thành phố <span class="text-danger">*</span></label>
                        <select class="form-select" id="newAddrProvince" required>
                            <option value="" selected disabled>Chọn Tỉnh / Thành phố</option>
                        </select>
                    </div>
                    <div class="row">
                        <div class="col-6 mb-3">
                            <label class="form-label fw-bold small">Quận / Huyện <span class="text-danger">*</span></label>
                            <select class="form-select" id="newAddrDistrict" required disabled>
                                <option value="" selected disabled>Chọn Quận / Huyện</option>
                            </select>
                        </div>
                        <div class="col-6 mb-3">
                            <label class="form-label fw-bold small">Phường / Xã <span class="text-danger">*</span></label>
                            <select class="form-select" id="newAddrWard" required disabled>
                                <option value="" selected disabled>Chọn Phường / Xã</option>
                            </select>
                        </div>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-bold small">Số nhà, Tên đường <span class="text-danger">*</span></label>
                        <input type="text" class="form-control" id="newAddrStreet" name="newStreet" placeholder="VD: Số 120 Yên Lãng" required>
                    </div>
                </form>
            </div>
            <div class="modal-footer" style="border-top:none;">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal" style="border-radius:8px;">Hủy bỏ</button>
                <button type="button" class="btn btn-dark" id="btnSaveAddress" style="border-radius:8px;">
                    <i class="fas fa-save me-1"></i> Lưu địa chỉ
                </button>
            </div>
        </div>
    </div>
</div>

<%-- ============================================================
     DIGITAL SIGNATURE MODAL
     ============================================================ --%>
<div class="ds-backdrop" id="dsBackdrop" role="dialog" aria-modal="true" aria-labelledby="dsModalTitle">
    <div class="ds-modal" id="dsModal">
        <div class="ds-header">
            <div class="ds-header-icon"><i class="fas fa-key"></i></div>
            <div class="ds-header-text">
                <h4 id="dsModalTitle">Xác thực chữ ký điện tử</h4>
                <p>RSA / DSA · SHA-256 · Khóa cục bộ</p>
            </div>
            <button class="ds-close" onclick="dsClose()" aria-label="Đóng">&times;</button>
        </div>

        <div class="ds-body">
            <div class="ds-steps">
                <div class="ds-step active" id="dsSt1"></div>
                <div class="ds-step" id="dsSt2"></div>
                <div class="ds-step" id="dsSt3"></div>
            </div>

            <%-- STEP 1: Load key + PIN --%>
            <div id="dsStep1">
                <p style="font-size:12px;font-weight:600;text-transform:uppercase;letter-spacing:.05em;color:#888;margin-bottom:10px;">
                    Bước 1 — Nạp Private Key từ máy tính
                </p>

                <div class="ds-drop-zone" id="dsDropZone">
                    <input type="file" id="dsKeyFile" accept=".pem,.key,.p12,.pfx,.der" onchange="dsHandleFile(this)">
                    <i class="fas fa-file-certificate ds-drop-icon"></i>
                    <p id="dsDropText">
                        Kéo thả hoặc <strong>bấm để chọn</strong> file Private Key<br>
                        <span style="font-size:11px;">.pem &nbsp;·&nbsp; .key &nbsp;·&nbsp; .p12 &nbsp;·&nbsp; .pfx &nbsp;·&nbsp; .der</span>
                    </p>
                </div>

                <p style="font-size:12px;font-weight:600;text-transform:uppercase;letter-spacing:.05em;color:#888;margin-bottom:8px;">
                    Mã PIN chứng thư số
                </p>
                <div class="ds-pin-wrap">
                    <input type="password" id="dsPinInput" placeholder="Nhập mã PIN (tối thiểu 4 ký tự)..." maxlength="20" autocomplete="off">
                    <button type="button" class="ds-pin-toggle" id="dsPinToggleBtn" onclick="dsPinToggle()" aria-label="Hiện/ẩn PIN">
                        <i class="fas fa-eye" id="dsPinEyeIcon"></i>
                    </button>
                </div>

                <div class="ds-info">
                    <i class="fas fa-shield-alt"></i>
                    <span>File Private Key chỉ được đọc cục bộ trong trình duyệt. Không có nội dung khóa nào gửi lên máy chủ ở bước này.</span>
                </div>
            </div>

            <%-- STEP 2: Signing progress --%>
            <div id="dsStep2" style="display:none;">
                <p style="font-size:12px;font-weight:600;text-transform:uppercase;letter-spacing:.05em;color:#888;margin-bottom:12px;">
                    Bước 2 — Ký dữ liệu đơn hàng
                </p>

                <div class="ds-code-box">
                    <div class="ds-code-label">SHA-256 hash của đơn hàng</div>
                    <div class="ds-code-val" id="dsHashVal">—</div>
                </div>

                <div class="ds-progress-bar"><div class="ds-progress-fill" id="dsProgFill"></div></div>

                <div class="ds-status" id="dsStatusWrap">
                    <span class="ds-badge wait" id="dsBadge">
                        <i class="fas fa-spinner fa-spin"></i> Đang xử lý...
                    </span>
                </div>

                <div class="ds-code-box" id="dsSigBox" style="display:none;">
                    <div class="ds-code-label">Chữ ký số (Base64 · rút gọn)</div>
                    <div class="ds-code-val" id="dsSigVal"></div>
                </div>
            </div>

            <%-- STEP 3: Success + confirm --%>
            <div id="dsStep3" style="display:none;">
                <div class="ds-success">
                    <i class="fas fa-check-circle big"></i>
                    <h5>Ký số thành công!</h5>
                    <p>Chữ ký điện tử đã được xác minh và gắn vào đơn hàng.</p>
                </div>
                <table class="ds-confirm-table">
                    <tr><td>Phương thức</td><td id="cfMethod">RSA-PSS / SHA-256</td></tr>
                    <tr><td>File khóa</td><td id="cfKey">—</td></tr>
                    <tr><td>Thuật toán hash</td><td>SHA-256</td></tr>
                    <tr><td>Thời gian ký</td><td id="cfTime">—</td></tr>
                    <tr><td>Chữ ký (rút gọn)</td><td id="cfSig">—</td></tr>
                </table>
            </div>
        </div>

        <div class="ds-footer">
            <button class="ds-btn-cancel" id="dsCancelBtn" onclick="dsClose()">Hủy bỏ</button>
            <button class="ds-btn-primary" id="dsMainBtn" disabled onclick="dsNextStep()">
                <i class="fas fa-pencil-alt" id="dsMainIcon"></i>
                <span id="dsMainText">Ký xác nhận</span>
            </button>
        </div>
    </div>
</div>


<%-- ============================================================
     JAVASCRIPT
     ============================================================ --%>
<script>
    /* ---------------------------------------------------------------
       CHECKOUT FORM SUBMIT — intercept for Digital Signature
    --------------------------------------------------------------- */
    document.getElementById("checkoutForm").addEventListener("submit", function (e) {
        const method = document.querySelector('input[name="paymentMethod"]:checked').value;
        if (method === "DIGITAL_SIGNATURE") {
            const sig = document.getElementById("digitalSignature").value;
            if (!sig) {
                e.preventDefault();
                dsOpen();            // Mở modal chữ ký số mới
            }
            // Nếu đã có chữ ký (sau khi ký xong modal gọi dsSubmitForm()) thì để form submit bình thường
        }
    });

    /* ---------------------------------------------------------------
       DIGITAL SIGNATURE MODAL LOGIC
    --------------------------------------------------------------- */
    let dsStep = 1;
    let dsFileName = '';
    let dsSignatureFull = '';

    // Mở modal
    function dsOpen() {
        document.getElementById('dsBackdrop').classList.add('show');
        dsResetToStep1();
    }

    // Đóng modal
    function dsClose() {
        document.getElementById('dsBackdrop').classList.remove('show');
    }

    // Đóng khi click ngoài modal
    document.getElementById('dsBackdrop').addEventListener('click', function (e) {
        if (e.target === this) dsClose();
    });

    // Reset về bước 1
    function dsResetToStep1() {
        dsStep = 1;
        dsFileName = '';
        dsSignatureFull = '';
        dsUpdateStepBar();

        document.getElementById('dsStep1').style.display = 'block';
        document.getElementById('dsStep2').style.display = 'none';
        document.getElementById('dsStep3').style.display = 'none';

        document.getElementById('dsDropZone').style.borderColor = '#d0d0d0';
        document.getElementById('dsDropZone').style.background = '#fafafa';
        document.getElementById('dsDropText').innerHTML =
            'Kéo thả hoặc <strong>bấm để chọn</strong> file Private Key<br>' +
            '<span style="font-size:11px;">.pem &nbsp;·&nbsp; .key &nbsp;·&nbsp; .p12 &nbsp;·&nbsp; .pfx &nbsp;·&nbsp; .der</span>';
        document.getElementById('dsPinInput').value = '';
        document.getElementById('dsPinInput').type = 'password';
        document.getElementById('dsPinEyeIcon').className = 'fas fa-eye';

        document.getElementById('dsCancelBtn').textContent = 'Hủy bỏ';
        document.getElementById('dsCancelBtn').onclick = dsClose;
        document.getElementById('dsMainBtn').disabled = true;
        document.getElementById('dsMainIcon').className = 'fas fa-pencil-alt';
        document.getElementById('dsMainText').textContent = 'Ký xác nhận';
    }

    // Cập nhật thanh bước
    function dsUpdateStepBar() {
        [1, 2, 3].forEach(function (n) {
            const el = document.getElementById('dsSt' + n);
            el.classList.toggle('done', n < dsStep);
            el.classList.toggle('active', n === dsStep);
        });
    }

    // Chọn file Private Key
    function dsHandleFile(input) {
        const f = input.files[0];
        if (!f) return;
        dsFileName = f.name;
        const dz = document.getElementById('dsDropZone');
        dz.style.borderColor = '#000';
        dz.style.background = '#f0f0f0';
        document.getElementById('dsDropText').innerHTML =
            '<i class="fas fa-check-circle" style="color:#1a7a46;font-size:20px;display:block;margin-bottom:6px;"></i>' +
            '<span style="font-size:13px;font-weight:600;color:#000;">' + escapeHtml(f.name) + '</span><br>' +
            '<span style="font-size:11px;color:#888;">' + dsFormatBytes(f.size) + '</span>';
        dsCheckStep1();
    }

    // Kiểm tra đủ điều kiện để bật nút bước 1
    function dsCheckStep1() {
        const pinOk = document.getElementById('dsPinInput').value.trim().length >= 4;
        const fileOk = dsFileName !== '';
        document.getElementById('dsMainBtn').disabled = !(pinOk && fileOk);
    }

    document.getElementById('dsPinInput').addEventListener('input', dsCheckStep1);

    // Toggle hiện/ẩn PIN
    function dsPinToggle() {
        const inp = document.getElementById('dsPinInput');
        const ico = document.getElementById('dsPinEyeIcon');
        if (inp.type === 'password') {
            inp.type = 'text';
            ico.className = 'fas fa-eye-slash';
        } else {
            inp.type = 'password';
            ico.className = 'fas fa-eye';
        }
    }

    // Xử lý nút chính theo từng bước
    function dsNextStep() {
        if (dsStep === 1) dsGoStep2();
        else if (dsStep === 2.5) dsGoStep3();
        else if (dsStep === 3) dsSubmitForm();
    }

    // Bước 2: Tiến trình ký
    function dsGoStep2() {
        dsStep = 2;
        dsUpdateStepBar();
        document.getElementById('dsStep1').style.display = 'none';
        document.getElementById('dsStep2').style.display = 'block';
        document.getElementById('dsMainBtn').disabled = true;
        document.getElementById('dsCancelBtn').textContent = 'Quay lại';
        document.getElementById('dsCancelBtn').onclick = function () { dsResetToStep1(); };

        // Tạo hash giả lập từ dữ liệu đơn hàng
        const orderRaw = 'LUXCAR_ORDER_' + Date.now() + '_' + dsFileName + '_' + document.getElementById('totalPrice').textContent;
        document.getElementById('dsHashVal').textContent = dsFakeHash(orderRaw);

        const fill = document.getElementById('dsProgFill');
        const badge = document.getElementById('dsBadge');

        const stages = [
            [15, 'Đọc và giải mã Private Key...'],
            [35, 'Xác thực mã PIN...'],
            [55, 'Tính toán SHA-256 của đơn hàng...'],
            [75, 'Mã hóa bất đối xứng RSA-PSS...'],
            [90, 'Đóng gói chữ ký dạng Base64...'],
            [100, 'Xác minh chữ ký với Public Key...']
        ];

        let pct = 0, si = 0;
        const timer = setInterval(function () {
            if (pct >= 100) {
                clearInterval(timer);
                dsSigningDone();
                return;
            }
            pct = Math.min(pct + 2, 100);
            fill.style.width = pct + '%';
            if (si < stages.length && pct >= stages[si][0]) {
                badge.innerHTML = '<i class="fas fa-spinner fa-spin"></i> ' + stages[si][1];
                si++;
            }
        }, 40);
    }

    // Hoàn thành ký
    function dsSigningDone() {
        dsSignatureFull = dsFakeSig();
        document.getElementById('dsBadge').className = 'ds-badge ok';
        document.getElementById('dsBadge').innerHTML = '<i class="fas fa-check-circle"></i> Ký số hoàn tất';

        const sigBox = document.getElementById('dsSigBox');
        sigBox.style.display = 'block';
        document.getElementById('dsSigVal').textContent =
            dsSignatureFull.substring(0, 48) + '...' + dsSignatureFull.slice(-16);

        dsStep = 2.5;
        document.getElementById('dsMainBtn').disabled = false;
        document.getElementById('dsMainIcon').className = 'fas fa-arrow-right';
        document.getElementById('dsMainText').textContent = 'Xem xác nhận';
        document.getElementById('dsSt2').classList.add('done');
    }

    // Bước 3: Màn hình xác nhận
    function dsGoStep3() {
        dsStep = 3;
        dsUpdateStepBar();
        document.getElementById('dsStep2').style.display = 'none';
        document.getElementById('dsStep3').style.display = 'block';

        const now = new Date();
        document.getElementById('cfKey').textContent = dsFileName;
        document.getElementById('cfTime').textContent = now.toLocaleDateString('vi-VN') + ' ' + now.toLocaleTimeString('vi-VN');
        document.getElementById('cfSig').textContent = dsSignatureFull.substring(0, 20) + '...' + dsSignatureFull.slice(-8);

        document.getElementById('dsCancelBtn').style.display = 'none';
        document.getElementById('dsMainIcon').className = 'fas fa-shopping-cart';
        document.getElementById('dsMainText').textContent = 'Đặt hàng ngay';
        document.getElementById('dsMainBtn').disabled = false;
    }

    // Submit form sau khi ký xong
    function dsSubmitForm() {
        document.getElementById('digitalSignature').value = dsSignatureFull;
        document.getElementById('dsMainBtn').disabled = true;
        document.getElementById('dsMainText').textContent = 'Đang gửi...';
        document.getElementById('dsMainIcon').className = 'fas fa-spinner fa-spin';
        setTimeout(function () {
            document.getElementById('checkoutForm').submit();
        }, 400);
    }

    /* ---------------------------------------------------------------
       UTILITY FUNCTIONS
    --------------------------------------------------------------- */
    function dsFakeHash(input) {
        // Tạo chuỗi hex 64 ký tự giả lập SHA-256 (chỉ dùng cho demo giao diện)
        const seed = input.split('').reduce(function (acc, c) { return ((acc << 5) - acc + c.charCodeAt(0)) | 0; }, 0);
        let result = Math.abs(seed).toString(16).padStart(8, '0');
        const hex = '0123456789abcdef';
        const rng = Math.abs(seed);
        for (let i = result.length; i < 64; i++) {
            result += hex[(rng * (i + 7)) % 16 | 0];
        }
        return result.substring(0, 64);
    }

    function dsFakeSig() {
        // Tạo chuỗi Base64 giả lập (172 ký tự + ==) đại diện chữ ký RSA 2048-bit
        const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';
        let s = '';
        for (let i = 0; i < 172; i++) s += chars[Math.floor(Math.random() * chars.length)];
        return s + '==';
    }

    function dsFormatBytes(b) {
        return b > 1024 ? Math.round(b / 1024) + ' KB' : b + ' B';
    }

    function escapeHtml(str) {
        return str.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;');
    }

    // Drag & drop cho drop zone
    (function () {
        const dz = document.getElementById('dsDropZone');
        dz.addEventListener('dragover', function (e) { e.preventDefault(); dz.classList.add('drag'); });
        dz.addEventListener('dragleave', function () { dz.classList.remove('drag'); });
        dz.addEventListener('drop', function (e) {
            e.preventDefault();
            dz.classList.remove('drag');
            const f = e.dataTransfer.files[0];
            if (f) { document.getElementById('dsKeyFile').files = e.dataTransfer.files; dsHandleFile({ files: [f] }); }
        });
    })();

    /* ---------------------------------------------------------------
       VOUCHER
    --------------------------------------------------------------- */
    document.getElementById("voucherSelect").addEventListener("change", function () {
        const voucherId = this.value;
        const urlParams = new URLSearchParams(window.location.search);
        const type = urlParams.get('type') || '';
        fetch("${pageContext.request.contextPath}/voucher", {
            method: "POST",
            headers: { "Content-Type": "application/x-www-form-urlencoded" },
            body: "voucherId=" + voucherId + "&type=" + type
        })
            .then(function (r) { return r.text(); })
            .then(function (data) {
                document.getElementById("totalPrice").innerHTML = Number(data).toLocaleString('vi-VN') + " ₫";
            })
            .catch(function (err) { console.error("Voucher error:", err); });
    });

    /* ---------------------------------------------------------------
       ADDRESS SELECTION UI
    --------------------------------------------------------------- */
    document.querySelectorAll('input[name="shippingAddress"]').forEach(function (radio) {
        radio.addEventListener('change', function () {
            document.querySelectorAll('.address-slot').forEach(function (slot) { slot.classList.remove('selected'); });
            if (this.checked) {
                const label = document.querySelector('label[for="' + this.id + '"]');
                if (label) label.classList.add('selected');
            }
        });
    });

    /* ---------------------------------------------------------------
       SAVE NEW ADDRESS
    --------------------------------------------------------------- */
    document.getElementById("btnSaveAddress").addEventListener("click", function () {
        const name     = document.getElementById('newAddrName').value.trim();
        const province = document.getElementById('newAddrProvince').value;
        const district = document.getElementById('newAddrDistrict').value;
        const ward     = document.getElementById('newAddrWard').value;
        const street   = document.getElementById('newAddrStreet').value.trim();

        if (!name || !province || !district || !ward || !street) {
            alert("Vui lòng điền đủ thông tin!"); return;
        }

        const formData = new URLSearchParams();
        formData.append("name",     name);
        formData.append("province", province);
        formData.append("commune",  ward + ", " + district);
        formData.append("street",   street);
        formData.append("type",     "sub");

        const btn = document.getElementById('btnSaveAddress');
        btn.innerHTML = '<i class="fas fa-spinner fa-spin me-1"></i> Đang lưu...';
        btn.disabled = true;

        fetch('${pageContext.request.contextPath}/add-address', {
            method: 'POST',
            headers: { 'Content-type': 'application/x-www-form-urlencoded' },
            body: formData.toString()
        })
            .then(function (r) { return r.text(); })
            .then(function (data) {
                if (data === 'success') {
                    window.location.reload();
                } else if (data === 'full_slot') {
                    alert("Bạn chỉ lưu tối đa được 6 địa chỉ, vui lòng xóa bớt!");
                    btn.innerHTML = '<i class="fas fa-save me-1"></i> Lưu địa chỉ'; btn.disabled = false;
                } else {
                    alert("Có lỗi xảy ra, không thể lưu địa chỉ!");
                    btn.innerHTML = '<i class="fas fa-save me-1"></i> Lưu địa chỉ'; btn.disabled = false;
                }
            })
            .catch(function (err) {
                console.error('Error:', err); alert("Lỗi kết nối máy chủ"); btn.disabled = false;
            });
    });

    /* ---------------------------------------------------------------
       VIETNAM PROVINCE/DISTRICT/WARD API
    --------------------------------------------------------------- */
    let addressData = [];
    fetch('https://raw.githubusercontent.com/kenzouno1/DiaGioiHanhChinhVN/master/data.json')
        .then(function (r) { return r.json(); })
        .then(function (data) {
            addressData = data;
            const sel = document.getElementById('newAddrProvince');
            data.forEach(function (p) {
                const opt = document.createElement('option');
                opt.value = p.Name; opt.text = p.Name; opt.dataset.id = p.Id;
                sel.add(opt);
            });
        });

    document.getElementById('newAddrProvince').addEventListener('change', function () {
        const distSel = document.getElementById('newAddrDistrict');
        const wardSel = document.getElementById('newAddrWard');
        distSel.innerHTML = '<option value="" selected disabled>Chọn Quận / Huyện</option>';
        wardSel.innerHTML = '<option value="" selected disabled>Chọn Phường / Xã</option>';
        distSel.disabled = false; wardSel.disabled = true;

        const prov = addressData.find(function (p) { return p.Id === this.options[this.selectedIndex].dataset.id; }, this);
        if (prov && prov.Districts) {
            prov.Districts.forEach(function (d) {
                const opt = document.createElement('option');
                opt.value = d.Name; opt.text = d.Name; opt.dataset.id = d.Id;
                distSel.add(opt);
            });
        }
    });

    document.getElementById('newAddrDistrict').addEventListener('change', function () {
        const wardSel = document.getElementById('newAddrWard');
        wardSel.innerHTML = '<option value="" selected disabled>Chọn Phường / Xã</option>';
        wardSel.disabled = false;

        const provSel = document.getElementById('newAddrProvince');
        const prov = addressData.find(function (p) { return p.Id === provSel.options[provSel.selectedIndex].dataset.id; });
        const dist = prov && prov.Districts.find(function (d) { return d.Id === this.options[this.selectedIndex].dataset.id; }, this);
        if (dist && dist.Wards) {
            dist.Wards.forEach(function (w) {
                const opt = document.createElement('option');
                opt.value = w.Name; opt.text = w.Name;
                wardSel.add(opt);
            });
        }
    });
</script>
</body>
</html>
